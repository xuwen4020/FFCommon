//
//  URL+Extension.swift
//  FFCommon
//
//  Created by xuwen on 2023/6/12.
//

import Foundation

public extension URL {
    /// 获取URL内的Parameters
    func getUrlParameters() -> [String: String]? {
        
        var params: [String: String] = [:]
        
        let array = self.absoluteString.components(separatedBy: "?")
        if array.count == 2 {
            let paramsStr = array[1]
            if paramsStr.count > 0 {
                let paramsArray = paramsStr.components(separatedBy: "&")
                for param in paramsArray {
                    let arr = param.components(separatedBy: "=")
                    if arr.count == 2 {
                        params[arr[0]] = arr[1]
                    }
                }
            }
        }
        return params
    }
}

