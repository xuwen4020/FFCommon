//
//  UIApplication+Extension.swift
//  FFCommon
//
//  Created by xuwen on 2023/6/12.
//

import Foundation
import UIKit

public extension UIApplication {
    
    static var keyWindow: UIWindow? {
        if #available(iOS 15, *) {
            if let w = shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first {
                return w
            }
        }
        return UIApplication.shared.windows.first
    }
}

