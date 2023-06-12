//
//  UIFont+Extension.swift
//  FFCommon
//
//  Created by xuwen on 2023/6/12.
//

import Foundation
import UIKit

public extension UIFont {
    
    static func Font(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size)
    }
    
    static func FontBold(size: CGFloat) -> UIFont {
        return UIFont.boldSystemFont(ofSize: size)
    }
    
    /// 细体 light weight
    static func light(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: .light)
    }
    /// 中黑体 medium weight
    static func medium(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: .medium)
    }
    /// 常规体 regular weight
    static func regular(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: .regular)
    }
    /// 中粗体 semibold weight
    static func semibold(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: .semibold)
    }
    /// 加粗体 bold weight
    static func bold(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
    /// 纤细体 ultraLight weight
    static func ultralight(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: .ultraLight)
    }
    /// 极细体 thin weight
    static func thin(ofSize fontSize: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: .thin)
    }
}

// MARK: 段落样式

extension UIFont {
    
    // MARK: regular
    /// Regular 24
    public static var large: UIFont {
        return UIFont.systemFont(ofSize: 24)
    }
    /// Regular 20
    public static var big: UIFont {
        return UIFont.systemFont(ofSize: 20)
    }
    /// Regular 16
    public static var normal: UIFont {
        return UIFont.systemFont(ofSize: 16)
    }
    /// Regular 14
    public static var small: UIFont {
        return UIFont.systemFont(ofSize: 14)
    }
    /// Regular 12
    public static var mini: UIFont {
        return UIFont.systemFont(ofSize: 12)
    }
    /// Regular 10
    public static var tiny: UIFont {
        return UIFont.systemFont(ofSize: 10)
    }
    
    // MARK: Bold
    /// Bold 24
    public static var bold_large: UIFont {
        return UIFont.boldSystemFont(ofSize: 24)
    }
    /// Bold 20
    public static var bold_big: UIFont {
        return UIFont.boldSystemFont(ofSize: 20)
    }
    /// Bold 16
    public static var bold_normal: UIFont {
        return UIFont.boldSystemFont(ofSize: 16)
    }
    /// Bold 14
    public static var bold_small: UIFont {
        return UIFont.boldSystemFont(ofSize: 14)
    }
    /// Bold 12
    public static var bold_mini: UIFont {
        return UIFont.boldSystemFont(ofSize: 12)
    }
    /// Bold 10
    public static var bold_tiny: UIFont {
        return UIFont.boldSystemFont(ofSize: 10)
    }
    
    // MARK: Medium
    /// Medium 24
    public static var medium_large: UIFont {
        return UIFont.systemFont(ofSize: 24, weight: .medium)
    }
    /// Medium 20
    public static var medium_big: UIFont {
        return UIFont.systemFont(ofSize: 20, weight: .medium)
    }
    /// Medium 16
    public static var medium_normal: UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    /// Medium 14
    public static var medium_small: UIFont {
        return UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    /// Medium 12
    public static var medium_mini: UIFont {
        return UIFont.systemFont(ofSize: 12, weight: .medium)
    }
    /// Medium 10
    public static var medium_tiny: UIFont {
        return UIFont.systemFont(ofSize: 10, weight: .medium)
    }
    
    
    // MARK: Semibold
    /// Semibold 24
    public static var semibold_large: UIFont {
        return UIFont.systemFont(ofSize: 24, weight: .semibold)
    }
    /// Semibold 20
    public static var semibold_big: UIFont {
        return UIFont.systemFont(ofSize: 20, weight: .semibold)
    }
    /// Semibold 16
    public static var semibold_normal: UIFont {
        return UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    /// Semibold 14
    public static var semibold_small: UIFont {
        return UIFont.systemFont(ofSize: 14, weight: .semibold)
    }
    /// Semibold 12
    public static var semibold_mini: UIFont {
        return UIFont.systemFont(ofSize: 12, weight: .semibold)
    }
    /// Semibold 10
    public static var semibold_tiny: UIFont {
        return UIFont.systemFont(ofSize: 10, weight: .semibold)
    }
}

