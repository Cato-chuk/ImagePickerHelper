//
//  ViewController.swift
//  ImagePickerHelper
//
//  Created by cato.chuk@gmail.com on 06/19/2019.
//  Copyright (c) 2019 cato.chuk@gmail.com. All rights reserved.
//

import UIKit
import ImagePickerHelper

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ImagePickerHelper.sharedInstance.photoAlbumPermissions()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

