//
//  Dictionary+Extension.swift
//  FFCommon
//
//  Created by xuwen on 2023/6/12.
//

import Foundation

// MARK: - Dictionary extension

/// This extension adds some useful functions to Dictionary.
public extension Dictionary {
    // MARK: - Functions
    
    /// Append a Value for a given Key in the Dictionary.
    /// If the Key already exist it will be ovrewritten.
    ///
    /// - Parameters:
    ///   - value: Value to be added.
    ///   - key: Key to be added.
    mutating func append(_ value: Value, forKey key: Key) {
        self[key] = value
    }
    
    /// 转JSON String
    var jsonString: String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self,
                                                     options: .prettyPrinted) else {
            return nil
        }
        guard let str = String(data: data, encoding: .utf8) else {
            return nil
        }
        return str
    }
}

