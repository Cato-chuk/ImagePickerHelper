//
//  ImagePickerHelper.swift
//
//  Created by Cato on 2018/7/20.
//

import UIKit
import AVFoundation
import Photos

public class ImagePickerHelper: NSObject {
    
    public typealias VoidBlock = () -> Void
    public typealias ImageBlock = (_ image: UIImage) -> Void
    
    /// 单例对象
    public static let sharedInstance = ImagePickerHelper()
    
    var selectedImageCompletion: ImageBlock?
    weak var currentViewController: UIViewController?
    var imagePickerVC = UIImagePickerController()
    
    //MARK: Public Method
    
    /// 使用 ActionSheet 显示 相机/照片 选项
    ///
    /// - Parameters:
    ///   - title: ActionSheet 显示的标题
    ///   - message: ActionSheet 显示的信息
    ///   - controller: 当前需要显示 ActionSheet 的 Controller
    ///   - completion: 选择照片完成后执行的 Closure
    public func showObtainPhotoOptionSheet(withTipsTitle title: String, message: String, controller: UIViewController, completion: @escaping ImageBlock) {
        currentViewController = controller
        selectedImageCompletion = completion
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertVC.addAction(cancel)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let camera = UIAlertAction(title: "相机", style: .default) { (action) in
                self.cameraPermissions(deniedBlock: nil)
            }
            alertVC.addAction(camera)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibrary = UIAlertAction(title: "相册", style: .default) { (action) in
                self.photoAlbumPermissions()
            }
            alertVC.addAction(photoLibrary)
        }
        controller.present(alertVC, animated: true, completion: nil)
    }
    
    /// 打开照片
    ///
    /// - Parameters:
    ///   - controller: 负责 present UIImagePickerController(.photoLibrary) 的 Controller
    ///   - completion: 选择照片完成后执行的 Closure
    public func showPhotoLibrary(byController controller: UIViewController, completion: @escaping ImageBlock) {
        currentViewController = controller
        selectedImageCompletion = completion
        photoAlbumPermissions()
    }
    
    
    /// 打开相机
    ///
    /// - Parameters:
    ///   - controller: 负责 present UIImagePickerController(.camera) 的 Controller
    ///   - completion: 选择照片完成后执行的 Closure
    public func showCamera(byController controller: UIViewController, completion: @escaping ImageBlock) {
        currentViewController = controller
        selectedImageCompletion = completion
        cameraPermissions(deniedBlock: nil)
    }
    
    //MARK: Check photo permission
    /// 检查相册权限，notDetermined：请求相册权限m，authorized：直接打开相册, 被拒绝则弹窗提示
    ///
    /// - Parameters:
    ///   - callSystemImagePicker: 是否使用系统的相册图库来选择图片
    ///   - authorizedBlock: 权限验证成功后执行的 Closure
    ///   - deniedBlock: 权限被拒绝后执行的 Closure
    public func photoAlbumPermissions(callSystemImagePicker: Bool = true, authorizedBlock: @escaping VoidBlock = {}, deniedBlock: @escaping VoidBlock = {}) {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        
        if authStatus == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (status: PHAuthorizationStatus) -> Void in
                self.photoAlbumPermissions(authorizedBlock: authorizedBlock, deniedBlock: deniedBlock)
            }
        } else if authStatus == .authorized  {
            authorizedBlock()
            if callSystemImagePicker {
                showPhotoPickerController(sourceType: .photoLibrary)
            }
        } else {
            deniedBlock()
        }
    }
    
    //MARK: Private Method
    //MARK: Check camera permission
    
    /// 相机的权限验证
    ///
    /// - Parameter deniedBlock: 权限被拒绝后执行的 Closure
    private func cameraPermissions(deniedBlock: VoidBlock?) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        if authStatus == .notDetermined {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                self.cameraPermissions(deniedBlock: deniedBlock)
            })
        } else if authStatus == .authorized {
            showPhotoPickerController(sourceType: .camera)
        } else {
            deniedBlock?()
        }
    }
    
    /// 显示 UIImagePickerController
    ///
    /// - Parameter sourceType: UIImagePickerController.SourceType: (photoLibrary || camera || savedPhotosAlbum)
    private func showPhotoPickerController(sourceType: UIImagePickerController.SourceType) {
        imagePickerVC.delegate = self
        imagePickerVC.sourceType = sourceType
        imagePickerVC.allowsEditing = true
        currentViewController?.present(imagePickerVC, animated: true, completion: nil)
    }
}

extension ImagePickerHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        selectedImageCompletion?(image)
        picker.dismiss(animated: true, completion: nil)
        imagePickerVC = UIImagePickerController()
    }
    
    private func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        imagePickerVC = UIImagePickerController()
    }
}
