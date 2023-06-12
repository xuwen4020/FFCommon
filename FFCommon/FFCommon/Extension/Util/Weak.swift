//
//  weak.swift
//  FFCommon
//
//  Created by xuwen on 2023/6/12.
//

import Foundation

public struct Weak<T> {
    private weak var _value: AnyObject?

    public var value: T? {
        get {
            return _value as? T
        }
        set {
            _value = newValue as AnyObject
        }
    }

    public init(value: T) {
        self.value = value
    }
}

