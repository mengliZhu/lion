#
#  Be sure to run `pod spec lint lion.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "lion"
  s.version      = "0.0.1"
  s.summary      = "A short description of lion."
  s.homepage     = "https://github.com/mengliZhu/lion.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Alex" => "zhumengli@zuoyebang.com" }
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/mengliZhu/lion.git", :tag => s.version.to_s }
  s.source_files  = "lion/Classes/*.{h,m}"
  s.public_header_files = "lion/Classes/*.h"
  s.resources = "lion/Resources/*.png"
  s.requires_arc = true
  s.frameworks = "UIKit", "Foundation"

end
