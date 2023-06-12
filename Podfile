#source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'
# 指定工作空间
workspace 'FFCommonDemo.xcworkspace'

#指定主项目
#project 'FFCommonDemo.xcodeproj'

platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!

def commonPods()
 pod 'Toast-Swift', '~> 5.0.1'
end


target 'FFCommonDemo' do
  project 'FFCommonDemo.xcodeproj'
  commonPods()
end


target 'FFCommon' do
  project 'FFCommon/FFCommon.xcodeproj'  
  commonPods()
end


post_install do |installer|
  installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                
#                if $static_framework.include?(config.build_settings["PRODUCT_NAME"])
                  config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
#                end
                    
                if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 13.0
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
                end
               end
          end
   end
  
end

