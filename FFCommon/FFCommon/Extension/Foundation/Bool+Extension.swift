//
//  Bool+Extension.swift
//  FFCommon
//
//  Created by xuwen on 2023/6/12.
//

import Foundation

public extension Bool {

    /// Toggle boolean value.
    mutating func toggle() -> Bool {
        self = !self
        return self
    }
}
