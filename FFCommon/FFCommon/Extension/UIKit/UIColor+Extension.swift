//
//  UIColor+Extension.swift
//  FFCommon
//
//  Created by xuwen on 2023/6/12.
//

import Foundation
import UIKit

public extension UIColor {
    
    /// RGBA properties: alpha.
    var alpha: CGFloat {
        return cgColor.alpha
    }
    
    /// 从 UIColor 或 NSColor 返回 HEX 字符串。
    var hexString: String {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let redInt = (Int)(red * 255)
        let greenInt = (Int)(green * 255)
        let blueInt = (Int)(blue * 255)
        let rgb: Int = redInt << 16 | greenInt << 8 | blueInt << 0

        return String(format: "#%06x", rgb)
    }
    
    /// 从 HEX 字符串创建颜色。
    /// 支持以下类型：
    /// - #RRGGBB.
    /// - #AARRGGBB
    ///
    /// - Parameters:
    ///   - hexString: HEX string.
    ///   - alpha:  透明度
    convenience init(hexString: String, _ alpha: CGFloat = 1.0) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = alpha
        var hex: String = hexString
        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex = String(hex[index...])
        }
        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.count) {
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                print("error HexString")
            }

        }
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// 创建并返回一个颜色对象，该对象具有与给定颜色相同的颜色空间和分量值，但具有指定的 alpha 分量。
    ///
    /// - Parameters:
    ///   - color: UIColor or NSColor value.
    ///   - alpha: Alpha value.
    /// - Returns: Returns an UIColor or NSColor instance.
    static func color(color: UIColor, alpha: CGFloat) -> UIColor {
        color.withAlphaComponent(alpha)
    }
    
    /// 创建随机颜色。
    ///
    /// - Parameter alpha: Alpha value.
    /// - Returns: Returns the UIColor or NSColor instance.
    static func random(alpha: CGFloat = 1.0) -> UIColor {
        let red = Int.random(in: 0...255)
        let green = Int.random(in: 0...255)
        let blue = Int.random(in: 0...255)

        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
}
public extension UIColor {
    
    /// RGB properties: red.
    var redComponent: CGFloat {
        guard canProvideRGBComponents(), let component = cgColor.__unsafeComponents else {
            return 0.0
        }

        return component[0]
    }

    /// RGB properties: green.
    var greenComponent: CGFloat {
        guard canProvideRGBComponents(), let component = cgColor.__unsafeComponents else {
            return 0.0
        }

        guard cgColor.colorSpace?.model == CGColorSpaceModel.monochrome else {
            return component[1]
        }
        return component[0]
    }

    /// RGB properties: blue.
    var blueComponent: CGFloat {
        guard canProvideRGBComponents(), let component = cgColor.__unsafeComponents else {
            return 0.0
        }

        guard cgColor.colorSpace?.model == CGColorSpaceModel.monochrome else {
            return component[2]
        }
        return component[0]
    }

    /// RGB properties: white.
    var whiteComponent: CGFloat {
        guard cgColor.colorSpace?.model == CGColorSpaceModel.monochrome, let component = cgColor.__unsafeComponents else {
            return 0.0
        }

        return component[0]
    }
    
    /// 检查颜色是否为 RGB 格式。
    ///
    /// - Returns: Returns if the color is in RGB format.
    func canProvideRGBComponents() -> Bool {
        guard let colorSpace = cgColor.colorSpace else {
            return false
        }
        switch colorSpace.model {
        case CGColorSpaceModel.rgb, CGColorSpaceModel.monochrome:
            return true

        default:
            return false
        }
    }
}


