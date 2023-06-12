//
//  Validator.swift
//  FFCommon
//
//  Created by xuwen on 2023/6/12.
//

import Foundation
import UIKit

open class Validator {
    
    // MARK: 人脸检测
    /// 人脸检测
    /// - Parameter image: 被检测图像
    /// - Returns: 是否含有人像
    public static func checkFace(_ image: UIImage) -> Bool {
        let ciimage = CIImage(cgImage: image.cgImage!)
        let detector = CIDetector(ofType: CIDetectorTypeFace,
                                  context: nil,
                                  options: [CIDetectorAccuracy: CIDetectorAccuracyLow])!
        let result = detector.features(in: ciimage)
        // 识别出的特征数量
        return result.count > 0 ? true : false
    }
    
    // MARK: URL验证
    /// URL验证
    /// - Parameter email: 被校验字符串
    /// - Returns: 验证结果
    ///
    ///     checkUrl("https://google.com") -> true
    ///
    public static func checkUrl(_ string: String) -> Bool {
        return URL(string: string) != nil
    }
    
    // MARK: URL Schemed 是否有效
    /// URL Schemed 是否有效
    /// - Parameter email: 被校验字符串
    /// - Returns: 验证结果
    ///
    ///     checkSchemedUrl("https://google.com") -> true
    ///     checkSchemedUrl("google.com") -> false
    public static func checkSchemedUrl(_ string: String) -> Bool {
        guard let url = URL(string: string) else { return false }
        return url.scheme != nil
    }
    
    // MARK: 邮箱验证
    /// 邮箱验证
    /// - Parameter email: 被校验字符串
    /// - Returns: 验证结果
    ///
    ///     "john@doe.com".isValidEmail -> true‘
    ///
    public static func checkEmail(_ email: String) -> Bool
    {
        let regex = "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }
    
    // MARK: 密码验证
    /// 密码验证
    /// - Parameter email: 被校验字符串，8到20位，数字+小写+大写
    /// - Returns: 验证结果
    public static func checkPassword(_ password: String) -> Bool
    {
        let regex = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: password)
    }
    
    // MARK: 手机号验证（🇨🇳）
    /// 手机号验证（🇨🇳）
    /// - Parameter email: 被校验字符串
    /// - Returns: 验证结果
    public static func checkPhone(_ phone: String) -> Bool
    {
        let regex = "^1[0-9]{10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: phone)
    }
    
    // MARK: 数字验证
    /// 数字验证
    /// - Parameter email: 被校验字符串
    /// - Returns: 验证结果
    public static func checkNumber(_ number: String) -> Bool
    {
        if number.count == 0 { return false }
        let regex = "[0-9]*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: number)
    }
    
    // MARK: 检查字符串是否包含一个或多个字母
    /// 检查字符串是否包含一个或多个字母
    ///
    ///        checkLetter("123abc") -> true
    ///        checkLetter("123") -> false
    ///
    public static func checkLetter(_ string: String) -> Bool
    {
        let regex = "^[A-Za-z0-9]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: string)
    }
    
    // MARK: 身份证验证
    /// 身份证验证（🇨🇳）
    /// - Parameter email: 被校验字符串
    /// - Returns: 验证结果
    public static func checkIdentityCard(_ number: String) -> Bool
    {
        //判断位数
        if number.count != 15 && number.count != 18 {
            return false
        }
        var carid = number
        
        var lSumQT = 0
        
        //加权因子
        let R = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]
        
        //校验码
        let sChecker: [Int8] = [49, 48, 88, 57, 56, 55, 54, 53, 52, 51, 50]
        
        //将15位身份证号转换成18位
        let mString = NSMutableString.init(string: number)
        
        if number.count == 15
        {
            mString.insert("19", at: 6)
            var p = 0
            let pid = mString.utf8String
            for i in 0...16
            {
                let t = Int(pid![i])
                p += (t - 48) * R[i]
            }
            let o = p % 11
            let stringContent = NSString(format: "%c", sChecker[o])
            mString.insert(stringContent as String, at: mString.length)
            carid = mString as String
        }
        
        let cStartIndex = carid.startIndex
        let _ = carid.endIndex
        let index = carid.index(cStartIndex, offsetBy: 2)
        //判断地区码
        let sProvince = String(carid[cStartIndex..<index])
        if (!self.areaCodeAt(sProvince))
        {
            return false
        }
        
        //判断年月日是否有效
        //年份
        let yStartIndex = carid.index(cStartIndex, offsetBy: 6)
        let yEndIndex = carid.index(yStartIndex, offsetBy: 4)
        let strYear = Int(carid[yStartIndex..<yEndIndex])
        
        //月份
        let mStartIndex = carid.index(yEndIndex, offsetBy: 0)
        let mEndIndex = carid.index(mStartIndex, offsetBy: 2)
        let strMonth = Int(carid[mStartIndex..<mEndIndex])
        
        //日
        let dStartIndex = carid.index(mEndIndex, offsetBy: 0)
        let dEndIndex = carid.index(dStartIndex, offsetBy: 2)
        let strDay = Int(carid[dStartIndex..<dEndIndex])
        
        let localZone = NSTimeZone.local
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.timeZone = localZone
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date = dateFormatter.date(from: "\(String(format: "%02d",strYear!))-\(String(format: "%02d",strMonth!))-\(String(format: "%02d",strDay!)) 12:01:01")
        
        if date == nil
        {
            return false
        }
        let paperId = carid.utf8CString
        //检验长度
        if 18 != carid.count
        {
            return false
        }
        //校验数字
        func isDigit(c: Int) -> Bool
        {
            return 0 <= c && c <= 9
        }
        for i in 0...18
        {
            let id = Int(paperId[i])
            if isDigit(c: id) && !(88 == id || 120 == id) && 17 == i
            {
                return false
            }
        }
        //验证最末的校验码
        for i in 0...16
        {
            let v = Int(paperId[i])
            lSumQT += (v - 48) * R[i]
        }
        if sChecker[lSumQT%11] != paperId[17]
        {
            return false
        }
        return true
    }
    
    // MARK: 地区码验证
    /// 地区码验证
    /// - Parameter code: 地区码
    /// - Returns: 验证结果
    public static func areaCodeAt(_ code: String) -> Bool {
        var dic: [String: String] = [:]
        dic["11"] = "北京"
        dic["12"] = "天津"
        dic["13"] = "河北"
        dic["14"] = "山西"
        dic["15"] = "内蒙古"
        dic["21"] = "辽宁"
        dic["22"] = "吉林"
        dic["23"] = "黑龙江"
        dic["31"] = "上海"
        dic["32"] = "江苏"
        dic["33"] = "浙江"
        dic["34"] = "安徽"
        dic["35"] = "福建"
        dic["36"] = "江西"
        dic["37"] = "山东"
        dic["41"] = "河南"
        dic["42"] = "湖北"
        dic["43"] = "湖南"
        dic["44"] = "广东"
        dic["45"] = "广西"
        dic["46"] = "海南"
        dic["50"] = "重庆"
        dic["51"] = "四川"
        dic["52"] = "贵州"
        dic["53"] = "云南"
        dic["54"] = "西藏"
        dic["61"] = "陕西"
        dic["62"] = "甘肃"
        dic["63"] = "青海"
        dic["64"] = "宁夏"
        dic["65"] = "新疆"
        dic["71"] = "台湾"
        dic["81"] = "香港"
        dic["82"] = "澳门"
        dic["91"] = "国外"
        if (dic[code] == nil) {
            return false
        }
        return true
    }
}

