//
//  Double+Extension.swift
//  FFCommon
//
//  Created by xuwen on 2023/6/12.
//

import Foundation

public extension Double {
    
    var stringValue: String {
        return String(self)
    }
    /// 向上取整
    var intTopValue: Int {
        return Int(ceil(self))
    }
    /// 向下取整
    var intBottomValue: Int {
        return Int(floor(self))
    }
    
    var cgFloatValue: CGFloat {
        return CGFloat(self)
    }
    /// of : 默认保留2位小数
    func stringValue(of: Int = 2) -> String {
        return String(format:"%.\(of)f", self)
    }
}

