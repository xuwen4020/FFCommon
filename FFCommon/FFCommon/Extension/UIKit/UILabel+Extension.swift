//
//  UILabel+Extension.swift
//  FFCommon
//
//  Created by xuwen on 2023/6/6.
//

import Foundation
import UIKit

public extension UILabel {
    
    /// UILabel 工厂方法
    static func create(textColor: UIColor,
                              font: UIFont = UIFont(),
                              aliment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.commomConfig(textColor: textColor, font: font, aliment: aliment)
        label.textAlignment = aliment
        return label
    }
    
    // UILabel 配置
    func commomConfig(textColor: UIColor,
                             font: UIFont,
                             aliment: NSTextAlignment){
        self.textColor = textColor
        self.font = font
        self.textAlignment = aliment
    }
}

//
//extension UILabel {
//    
//    /// 字行间距
//    /// 赋值之后使用，为赋值之前不生效
//    ///
//    /// - Parameter value: 间距px
//    public func lineSpacing(_ value: CGFloat) {
//        guard let text = text else { return }
//        let atx = NSMutableAttributedString.init(text) { item in
//            item.lineSpacing(value)
//            item.alignment(self.textAlignment)
//            item.foregroundColor(self.textColor)
//            item.font(self.font)
//        }
//        attributedText = atx
//    }
//}
