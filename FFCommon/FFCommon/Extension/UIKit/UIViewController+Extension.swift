//
//  UIViewController+Extension.swift
//  FFCommon
//
//  Created by xuwen on 2023/6/12.
//

import Foundation
import UIKit

public extension UIViewController {
    
    /// 顶部controller
    class func currentViewController(base: UIViewController? = UIApplication.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return currentViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
    
    /// push
    func push(_ viewController: UIViewController, animated: Bool = true) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    /// pop
    func pop(animated: Bool = true) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    /// pop到指定控制器
    func popControllerTo(_ viewController: UIViewController.Type, animated: Bool = true) {
        var orContainVC = false
        navigationController?.viewControllers.forEach ({ temp in
            if temp.isKind(of: viewController.self) {
                orContainVC = true
                navigationController?.popToViewController(temp, animated: animated)
            }
        })
        if !orContainVC{
            navigationController?.popToRootViewController(animated: animated)
        }
    }
    
    /// pop到指定控制器
    /// - Parameter removeCount: 默认为1，仅返回上一层 ，中间需要移除的（n-1）控制器
    func popController(_ removeCount: Int = 1) {
        guard let childs = navigationController?.children else {
            return
        }
        guard childs.count >= removeCount else {
            return
        }
        let vc = childs[childs.count - removeCount - 1]
        navigationController?.popToViewController(vc, animated: true)
    }

    /// popRoot
    func popRoot(animated: Bool = true) {
        self.navigationController?.popToRootViewController(animated: animated)
    }
    
    /// present
    func present(_ viewController: UIViewController, completion: (() -> Void)? = nil) {
    
        self.present(viewController, animated: true, completion: completion)
    }
    
    /// dismiss
    func dismiss(completion: (() -> Void)? = nil) {
        self.dismiss(animated: true, completion: completion)
    }
    
    /// 呈现带有标题、消息和一组操作的 UIAlertController。
    ///
    /// - parameter title: The title of the UIAlerController.
    /// - parameter message: An optional String for the UIAlertController's message.
    /// - parameter actions: An array of actions that will be added to the UIAlertController.
    /// - parameter alertType: The style of the UIAlertController.
    func present(title: String, message: String, actions: [UIAlertAction], alertType: UIAlertController.Style = .alert) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: alertType)
        for action in actions {
            alert.addAction(action)
        }
        present(alert, animated: true, completion: nil)
    }
    
    /// 设置 tab bar 是否可见。
    /// 这不能在 viewDidLayoutSubviews() 之前调用，因为在这个时间之前没有设置 frame 。
    ///
    /// - Parameters:
    ///   - visible: Set if visible.
    ///   - animated: Set if the transition must be animated.
    func setTabBarVisible(_ visible: Bool, animated: Bool, duration: TimeInterval = 0.3) {
        let frame = tabBarController?.tabBar.frame
        
        guard isTabBarVisible() != visible, let height = frame?.size.height else {
            return
        }
        
        let offsetY = (visible ? -height : height)
        
        let duration: TimeInterval = (animated ? duration : 0.0)
        
        if let frame = frame {
            UIView.animate(withDuration: duration) {
                self.tabBarController?.tabBar.frame = frame.offsetBy(dx: 0, dy: offsetY)
                return
            }
        }
    }
    
    /// 如果 tab bar 可见，则返回
    ///
    /// - Returns: Returns if the tab bar is visible.
    func isTabBarVisible() -> Bool {
        guard let tabBarOriginY = tabBarController?.tabBar.frame.origin.y else {
            return false
        }
        
        return tabBarOriginY < view.frame.maxY
    }
}

