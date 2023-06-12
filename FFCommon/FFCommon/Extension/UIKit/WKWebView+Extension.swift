//
//  WKWebView+Extension.swift
//  FFCommon
//
//  Created by xuwen on 2023/6/12.
//

import WebKit

// MARK: - Methods

extension WKWebView {
    
    /// SwifterSwift: Navigate to `url`.
    /// - Parameter url: URL to navigate.
    /// - Returns: A new navigation for given `url`.
    @discardableResult
    public func loadURL(_ url: URL) -> WKNavigation? {
        return load(URLRequest(url: url))
    }

    /// SwifterSwift: Navigate to url using `String`.
    /// - Parameter urlString: The string specifying the URL to navigate to.
    /// - Returns: A new navigation for given `urlString`.
    @discardableResult
    public func loadURLString(_ urlString: String, timeout: TimeInterval? = nil) -> WKNavigation? {
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        if let timeout = timeout {
          request.timeoutInterval = timeout
        }
        return load(request)
    }
    /// 运行JS
    public func webViewEvaluateJS(jsString: String, callresult: @escaping (_: String) -> Void) {
        
        evaluateJavaScript(jsString) { result, error in
            if result != nil && error == nil {
                callresult(result as? String ?? "")
            }
        }
    }
}

