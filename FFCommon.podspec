

Pod::Spec.new do |spec|

  spec.name         = "FFCommon"
  spec.version      = "0.1.0"
  spec.summary      = "Swift 公共扩展"
  spec.description  = "Swift 公共扩展"

  spec.homepage     = "https://github.com/xuwen4020/FFCommon"
  spec.swift_version = '5.0'

  spec.license      = { :type => "MIT" }
  spec.author             = { "xuwen" => "996592197@qq.com" }

  spec.platform     = :ios, '13.0'
  spec.source       = { :git => "https://github.com/xuwen4020/FFCommon.git", :tag => spec.version }

  spec.static_framework = true
  spec.source_files  = "FFCommon/**/*.swift"

  spec.dependency 'Toast-Swift', '~> 5.0.1'
  
 # spec.dependency 'AFNetworking', '~> 1.0'
  #spec.dependency 'AFNetworking', '~> 1.0', :configurations => ['Debug']
  #spec.dependency 'AFNetworking', '~> 1.0', :configurations => :debug
  #spec.dependency 'RestKit/CoreData', '~> 0.20.0'
  #spec.ios.dependency 'MBProgressHUD', '~> 0.5'

end
