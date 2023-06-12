//
//  NSObject+Extension.swift
//  FFCommon
//
//  Created by xuwen on 2023/6/12.
//


import Foundation
import UIKit

public extension NSObject{
    
    //获取当前的控制器
    func getCurrentVC() -> UIViewController? {
        if let window:UIWindow = (UIApplication.shared.delegate?.window)!{

            var keyWindow = window

            if window.windowLevel != UIWindow.Level.normal{
                let windows = UIApplication.shared.windows
                for tmp in windows{
                    if tmp.windowLevel == UIWindow.Level.normal{
                        keyWindow = tmp
                        break
                    }
                }
            }

            var rootVC = keyWindow.rootViewController
            var activityVC:UIViewController?

            while(true){
                if let vc = rootVC as? UINavigationController{
                    activityVC = vc.visibleViewController
                }else if let vc = rootVC as? UITabBarController{
                    activityVC = vc.selectedViewController
                }else if(rootVC?.presentedViewController != nil){
                    activityVC = rootVC?.presentedViewController;
                }else{
                    break
                }
                rootVC = activityVC
            }
            
            return activityVC
        }else{
            return nil
        }
    }
}

