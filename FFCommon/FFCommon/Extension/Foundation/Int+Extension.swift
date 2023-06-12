//
//  Int+Extension.swift
//  FFCommon
//
//  Created by xuwen on 2023/6/12.
//

import Foundation

public extension Int {
    var stringValue: String {
        return String(Double(self))
    }
    var doubleValue: Double {
        return Double(self)
    }
    var cgFloatValue: CGFloat {
        return CGFloat(self)
    }
}
