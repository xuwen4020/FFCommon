//
//  Data+Extension.swift
//  FFCommon
//
//  Created by xuwen on 2023/6/12.
//

import Foundation

public extension Data {
    
    var stringValue: String {
        return String(decoding: self, as: UTF8.self)
    }
    
    func hexString() -> String {
        return map { String(format: "%02x", $0)}.joined()
    }
}
