#
# Be sure to run `pod lib lint ImagePickerHelper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ImagePickerHelper'
  s.version          = '0.1.0'
  s.summary          = 'iOS 照片选择组件'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
一个方便的、可扩展使用自定义照片选择器的 Helper，访问相册/相机前自动检测权限，避免 Crash。
                       DESC

  s.homepage         = 'https://github.com/Cato-chuk/ImagePickerHelper'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Cato' => 'cato.chuk@gmail.com' }
  s.source           = { :git => 'https://github.com/Cato-chuk/ImagePickerHelper.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'ImagePickerHelper/Classes/'
  
  # s.resource_bundles = {
  #   'ImagePickerHelper' => ['ImagePickerHelper/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'AVFoundation', 'Photos'
  # s.dependency 'AFNetworking', '~> 2.3'
end
