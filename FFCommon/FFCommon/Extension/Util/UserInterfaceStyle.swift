//
//  UserInterfaceStyle.swift
//  FFCommon
//
//  Created by xuwen on 2023/6/12.
//

import Foundation
import UIKit

public enum UserInterfaceStyle {
    private static let DarkToSystem = "DarkToSystemOrNot"
    
    public static func configColorModel(index: Int) {
        UserDefaults.standard.set(index, forKey: DarkToSystem)
        UIApplication.keyWindow?.overrideUserInterfaceStyle = UIUserInterfaceStyle(rawValue: index) ?? .unspecified
    }
    
    public static var colorModel: UIUserInterfaceStyle {
        let index = UserDefaults.standard.integer(forKey: DarkToSystem)
        return UIUserInterfaceStyle(rawValue: index) ?? .unspecified
    }
    
    public static func faceStyle() {
        let style = UserInterfaceStyle.colorModel
        printLog(style.rawValue)
        UIApplication.keyWindow?.overrideUserInterfaceStyle = style
    }
}

public extension UIColor {
    /// 暗黑模式
    /// - Parameters:
    ///   - lightColor:浅色模式颜色
    ///   - darkColor: 深色模式颜色
    /// - Returns: 当前模式颜色
    static func color(lightColor: UIColor, darkColor: UIColor) -> UIColor {
        UIColor(dynamicProvider: { (traitCollection: UITraitCollection) -> UIColor in
            if UserInterfaceStyle.colorModel == .unspecified {
                return traitCollection.userInterfaceStyle == .light ? lightColor : darkColor
            } else {
                return UserInterfaceStyle.colorModel == .light ? lightColor : darkColor
            }
        })
    }
    
    /// 暗黑模式
    static func color(lightColor: String, darkColor: String) -> UIColor {
        return UIColor.color(lightColor: UIColor(hexString: lightColor),
                             darkColor: UIColor(hexString: darkColor))
    }
}

