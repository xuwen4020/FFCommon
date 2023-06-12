//
//  AppConstant.swift
//  FFCommon
//
//  Created by xuwen on 2023/6/12.
//

import Foundation
import UIKit

// MARK:- 常用距离
/// 屏幕Bounds
public let kScreenBounds = UIScreen.main.bounds
/// 屏幕宽度
public let kScreenWidth = UIScreen.main.bounds.size.width
/// 屏幕高度
public let kScreenHeight = UIScreen.main.bounds.size.height
/// 底部安全区高度
public let kSafeAreaBottom = kWindowSafeAreaInset().bottom
/// 顶部安全区高度
public let kSafeAreaTop = kWindowSafeAreaInset().top == 0 ? 20 : kWindowSafeAreaInset().top
/// 状态栏高度
public let kStatusHeight = kWindowSafeAreaInset().top
/// 导航栏高度
public let kNavigaHeight = 44 + kStatusHeight
/// 底部TabBar高度
public let kTabBarHeight = 49 + kSafeAreaBottom
/// kWindow保护区边距
public let kWindowSafeAreaInset = { () -> UIEdgeInsets in
    var insets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    return UIApplication.shared.windows.first?.safeAreaInsets ?? insets
}
/// 是否是IphoneX之后的机型
public let isIphoneXLater: Bool = (UIApplication.keyWindow?.safeAreaInsets.bottom ?? 0) > 0

// MARK:- 常用间距

/// 统一间距设置
public struct KMetric {
    /// 外边距
    static let margin: CGFloat = kFitScale(AT: 16)
    /// 内边距
    static let padding: CGFloat = kFitScale(AT: 8)
    /// 分割线高度
    static let lineHeight: CGFloat = kFitScale(AT: 1)
    /// 间距
    static let inset: CGFloat = 8
}

// MARK: - App版本

/// App版本号
public let kVersion: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? ""
// app build号
public let kBuild: String = Bundle.main.infoDictionary!["CFBundleVersion"] as? String ?? ""
// app 包名
public let kBundleId: String = Bundle.main.infoDictionary!["CFBundleIdentifier"] as? String ?? ""

// App 名称
public let KAppName: String = Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String ?? ""

// MARK: - FileManager Path

/// 缓存路径
public let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
/// 库路径
public let libraryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first


// MARK:- 自定义打印日志

/// 自定义打印日志
public func printLog<T>(_ message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line){
    //文件名、方法、行号、打印信息
    #if DEBUG
    let clsn = fileName.components(separatedBy: "/").last?.components(separatedBy: ".").first ?? ""
    print("")
    print("======================================================")
    print("\(clsn): \(Date())")
    print("方法:\(methodName) 行号:\(lineNumber) 打印信息:")
    print("\(message)")
    print("======================================================")
    print("")
    #endif
}

/// 设备唯一标识码
public let kDeviceUUID = { () -> String in
    if let uuid = UIDevice.current.identifierForVendor?.uuidString {
        return uuid
    }
    return ""
}

// 1 代表320 x 480 的分辨率
// 2 代表640 x 960 的分辨率
// 3 代表1242 x 2208 的分辨率
/// 分辨率
public let scale = UIScreen.main.scale


// MARK:- 屏幕适配

/// 屏幕适配 以375 | 6s尺寸
public func kFitScale(AT: CGFloat) -> CGFloat {
    return (UIScreen.main.bounds.width / 375) * AT
}

