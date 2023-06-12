//
//  Result+Extension.swift
//  FFCommon
//
//  Created by xuwen on 2023/6/12.
//

import Foundation

public extension Result {
    
    ///是否成功
    var isSuccess: Bool { if case .success = self { return true } else { return false } }
    
    ///是否错误
    var isError: Bool {  return !isSuccess  }
//    typealias success = (_ data: String) -> ()
//    typealias fail = (_ error: String) -> ()
    ///成功case
    var success: Success? {
        if case .success(let item) = self {
            return item
        }
        return nil
    }
    
    ///失败case
    var failure: Failure? {
        if case .failure(let item) = self {
            return item
        }
        return nil
    }

    ///成功case
    @discardableResult
    func success(_ callback: ((Success) -> ())) -> Self {
        if case .success(let item) = self {
            callback(item)
        }
        return self
    }
    
    ///失败case
    @discardableResult
    func failure(_ callback: ((Failure) -> ())) -> Self {
        if case .failure(let item) = self {
            callback(item)
        }
        return self
    }
}

