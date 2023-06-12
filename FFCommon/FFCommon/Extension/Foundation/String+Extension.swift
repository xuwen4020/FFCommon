//
//  String+Extension.swift
//  FFCommon
//
//  Created by xuwen on 2023/6/12.
//

import Foundation
import UIKit

// MARK: String 基本操作
public extension String {
    // MARK: - 下标方式

    /// 从某个位置开始截取：
    /// - Parameter index: 起始位置
    subscript(from index: Int) -> String? {
        guard index >= 0 && index < count else { return nil }
        let startIndex = self.index(self.startIndex,offsetBy: index)
        let subString = self[startIndex..<self.endIndex];
        return String(subString);
    }
    
    /// 从零开始截取到某个位置：
    /// - Parameter index: 达到某个位置
    subscript(to index: Int) -> String? {
        guard index >= 0 && index < count else { return nil }
        let endIndex = self.index(self.startIndex, offsetBy: index)
        let subString = self[self.startIndex..<endIndex]
        return String(subString)
    }
    
    /// 安全下标字符串与索引
    ///
    ///     "Hello World!"[safe: 3] -> "l"
    ///     "Hello World!"[safe: 20] -> nil
    ///
    /// - Parameter index: 索引.
    subscript(safe index: Int) -> Character? {
        guard index >= 0, index < count else { return nil }
        return self[self.index(startIndex, offsetBy: index)]
    }
    
    /// 某个范围内截取
    /// - Parameter range: 范围
    subscript<R>(range range: R) -> String? where R: RangeExpression, R.Bound == Int {
        let range = range.relative(to: Int.min..<Int.max)
        guard range.lowerBound >= 0,
            let lowerIndex = index(startIndex, offsetBy: range.lowerBound, limitedBy: endIndex),
            let upperIndex = index(startIndex, offsetBy: range.upperBound, limitedBy: endIndex) else {
                return nil
        }
        return String(self[lowerIndex..<upperIndex])
    }
    
    // MARK: - 普通模式
    /// 截取 from 位置后的所有字符，from 超过字符串长度，返回空字符 ""
    func subString(from: Int) -> String {
        if from >= self.count {
            return ""
        }
        let rang = self.index(startIndex, offsetBy: from)..<self.endIndex
        return String(self[rang])
    }
    
    /// 从起始位置开始截取到 to 位置的所有字符，to 超过字符串长度，返回整个字符串
    func subString(to: Int) -> String {
        if to >= self.count {
            return self;
        }
        let rang = self.startIndex..<self.index(startIndex, offsetBy: to)
        return String(self[rang])
    }
    
    /// 截取字符串
    ///
    /// - Parameter index: 根据开始位置和长度截取字符串
    /// - Returns: 返回一个新的字符串
    func subString(start index:Int, length:Int = -1) -> String {
        var len = length
        if len == -1 {
            len = self.count - index
        }
        let st = self.index(startIndex, offsetBy:index)
        let en = self.index(st, offsetBy:len)
        return String(self[st ..< en])
    }
    
    
    /// 检测字符串所在位置
    ///
    ///     let num:String = "15989954385"
    ///     print("\(num.getIndexOf("3"))")
    ///
    /// - Parameter char: 字符
    /// - Returns: 返回指定字符所在索引
    func getIndexOf(_ char: Character) -> Int? {
      for (index, c) in enumerated() {
        if c == char {
          return index
        }
      }
      return nil
    }
    
    /// 获取Range字符串
    func subStringWithRange(location: Int, length: Int) -> String{
        if location+length > self.count { return self }
        let str: String = self
        let start = str.startIndex
        let startIndex = str.index(start, offsetBy: location)
        let endIndex = str.index(startIndex, offsetBy:length)
        return String(str[startIndex..<endIndex])
    }
    
    /// 查询位置
    func ranges(frist other: String) -> NSRange {
        guard let range = range(of: other) else { return NSRange.init(location: 0, length: 0) }
        return NSRange(range, in: self)
    }
    
    
    /// 判断一个字符串是否为空字符串
    var isBlank: Bool {
        let trimmedStr = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedStr.isEmpty
    }
    
    /// 去掉首尾空格
    var removeHeadAndTailSpace:String {
        let whitespace = NSCharacterSet.whitespaces
        return self.trimmingCharacters(in: whitespace)
    }
    
    /// 去掉首尾空格 包括后面的换行
    var removeHeadAndTailSpacePro:String {
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: whitespace)
    }
    
    /// 去掉所有空格
    var removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    
    /// 去掉首尾空格 后 指定开头空格数
    func beginSpaceNum(num: Int) -> String {
        var beginSpace = ""
        for _ in 0..<num {
            beginSpace += " "
        }
        return beginSpace + self.removeHeadAndTailSpacePro
    }
    
    // 多个换行替换为一个
    func replacingNewlineMatches() -> String {
        
        guard let regex = try? NSRegularExpression(pattern: "\n+") else {
            return self
        }
        
        let newString = regex.stringByReplacingMatches(in: self, range: NSRange(location: 0, length: self.count), withTemplate: "\n")
        
        return newString
    }
    
    
    static func random(length:Int) -> String{
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

        var str = ""
        for _ in 1...length{
            let data = arc4random_uniform(UInt32(letters.count))
            let c = letters.substring(from: Int(data), length: 1)
            str.append(c)
        }
        return str
    }
}

/// 空格
public func space(_ count: Int = 1) -> String {
    var s = ""
    for _ in 0..<count {
        s += " "
    }
    return s
}

public extension String {
    /// 根据宽度跟字体，计算文字的高度
    func textAutoHeight(width:CGFloat, font: UIFont) -> CGFloat {
        let string = self as NSString
        let origin = NSStringDrawingOptions.usesLineFragmentOrigin
        let lead = NSStringDrawingOptions.usesFontLeading
        let ssss = NSStringDrawingOptions.usesDeviceMetrics
        let rect = string.boundingRect(with:CGSize(width: width, height: 0), options: [origin, lead, ssss], attributes:
                                        [NSAttributedString.Key.font:font], context:nil)
        return rect.height
    }
    
    /// 根据高度跟字体，计算文字的宽度
    func textAutoWidth(height: CGFloat, font: UIFont) -> CGFloat {
        let string = self as NSString
        let origin = NSStringDrawingOptions.usesLineFragmentOrigin
        let lead = NSStringDrawingOptions.usesFontLeading
        let ssss = NSStringDrawingOptions.usesDeviceMetrics

        let rect = string.boundingRect(with:CGSize(width: 0, height: height), options: [origin, lead, ssss], attributes:
                                        [NSAttributedString.Key.font:font], context:nil)
        
        return rect.width
    }
    
}

// MARK: String 数据转换
public extension String {
    
    var decimalNumber: NSDecimalNumber {
        let decimalNumber = NSDecimalNumber(string: self)
        return decimalNumber == NSDecimalNumber.notANumber ? 0 : decimalNumber
    }
    
    var int: Int {
        let decimalNumber = NSDecimalNumber(string: self)
        return decimalNumber.intValue
    }
    
    var float: Float {
        let decimalNumber = NSDecimalNumber(string: self)
        return decimalNumber.floatValue
    }
    
    var double: Double {
        let decimalNumber = NSDecimalNumber(string: self)
        return decimalNumber.doubleValue
    }
    
    var cgFloat: CGFloat {
        let decimalNumber = NSDecimalNumber(string: self)
        return CGFloat(decimalNumber.floatValue)
    }
    
    var int64: Int64 {
        let decimalNumber = NSDecimalNumber(string: self)
        return decimalNumber.int64Value
    }
}

// MARK: String 文件操作
public extension String {
    ///最后的文件路径
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    ///文件后缀
    var pathExtension: String {
        return (self as NSString).pathExtension
    }

    /// 删除最后一个文件路径
    var deletingLastPathComponent: String {
        NSString(string: self).deletingLastPathComponent
    }

    /// 删除路径扩展名
    var deletingPathExtension: String {
        NSString(string: self).deletingPathExtension
    }

    /// 返回文件路径的数组
    var pathComponents: [String] {
        NSString(string: self).pathComponents
    }
    
    /// 给字符串拼接 文件路径
    /// appendingPathComponent: 自动格式化文件路径
    /// eg："http://xxx" appendingPathComponent:"keng"    =>    http:/xxx/keng
    ///
    /// - Parameter path: 要附加的文件路径
    /// - Returns: Returns all the string.
    func appendingPathComponent(_ path: String) -> String {
        let string = NSString(string: self)
        
        return string.appendingPathComponent(path)
    }
    
    /// 给字符串加后缀
    ///  eg:  "11111".appendingPathExtension("jpg")    =>    11111.jpg
    ///
    /// - Parameter ext: 附加的扩展名.
    /// - Returns: Returns all the string.
    func appendingPathExtension(_ ext: String) -> String? {
        let nsSt = NSString(string: self)
        return nsSt.appendingPathExtension(ext)
    }
}
// MARK: String 其他转换
public extension String {
    
    var url: URL? {
        return URL(string: self)
    }
    
    var nib: UINib  {
        return UINib(nibName: self, bundle: nil)
    }
    
    /// 通知
    var notifi: NSNotification.Name {
        return NSNotification.Name(self)
    }
    
    /// 手机号验证 简单点就看是否是1开头的数字吧
    var isMobile: Bool {
        let mobileReg = "^1\\d{10}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobileReg)
        return regextestmobile.evaluate(with: self)
    }
    
    var isEmail: Bool {
        
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    
    /// JSON转数组
    func toArray() -> [Any]? {
        guard
            let jsonData: Data = self.data(using: .utf8),
            let dics = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        else {
            return nil
        }
        return dics as? [Any]
    }
    
    /// JSON转字典
    func toDictionary() -> [String: Any]? {
        guard
            let jsonData: Data = self.data(using: .utf8),
            let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        else {
            return nil
        }
        return dict as? [String: Any]
    }
    
    /// 字符串转时间
    func toDate(format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
    
    /// 隐藏手机号中间4位
    func hiddenPhone() -> String {
        let start = self.prefix(3)
        let end = self.suffix(4)
        return "\(start)****\(end)"
    }
    
    /// 显示首字符
    func showFirst() -> String {
        let start = self.prefix(1)
        return "\(start)****"
    }
}
// MARK: Emoji
public extension String {
    /// 是否包含表情
    var containsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case
            0x00A0...0x00AF,
            0x2030...0x204F,
            0x2120...0x213F,
            0x2190...0x21AF,
            0x2310...0x329F,
            0x1F000...0x1F9CF:
                return true
            default:
                continue
            }
        }
        return false
    }
    /// 移除字符串中的表情符号，返回一个新的字符串
    func removeEmoji() -> String {
        return self.reduce("") {
            if $1.isEmoji {
                return $0 + ""
            } else {
                return $0 + String($1)
            }
        }
    }
}
public extension Character {
    /// SwifterSwift: Check if character is emoji.
    ///
    ///        Character("😀").isEmoji -> true
    ///
    var isEmoji: Bool {
        // http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
        let scalarValue = String(self).unicodeScalars.first!.value
        switch scalarValue {
        case 0x1F600...0x1F64F, // Emoticons
             0x1F300...0x1F5FF, // Misc Symbols and Pictographs
             0x1F680...0x1F6FF, // Transport and Map
             0x1F1E6...0x1F1FF, // Regional country flags
             0x2600...0x26FF, // Misc symbols
             0x2700...0x27BF, // Dingbats
             0xE0020...0xE007F, // Tags
             0xFE00...0xFE0F, // Variation Selectors
             0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
             127_000...127_600, // Various asian characters
             65024...65039, // Variation selector
             9100...9300, // Misc items
             8400...8447: // Combining Diacritical Marks for Symbols
            return true
        default:
            return false
        }
    }
}

public extension String {
    /// 模糊搜索，大海捞针算法
    func fuzzySearch(needle: String) -> (Bool, Int) {
        guard needle != self else { return (true, 3) }
        guard !localizedCaseInsensitiveContains(needle) else { return (true, 2) }
        guard needle.count <= count else { return (false, -1) }

        var needleIndex = needle.startIndex
        var haystackIndex = startIndex

        while needleIndex != needle.endIndex {
            guard haystackIndex != endIndex else { return (false, -1) }
            if needle[needleIndex].uppercased() == self[haystackIndex].uppercased() {
                needleIndex = needle.index(after: needleIndex)
            }
            haystackIndex = index(after: haystackIndex)
        }
        return (true, 1)
    }
    
    
    static func safeUrlBase64Encode(_ base64Str: String) -> String{
        
        var safeBase64Str = base64Str
        safeBase64Str = safeBase64Str.replacingOccurrences(of: "+", with: "-")
        safeBase64Str = safeBase64Str.replacingOccurrences(of: "/", with: "_")
        safeBase64Str = safeBase64Str.replacingOccurrences(of: "=", with: "")
        
        return safeBase64Str
    }
    
    static func safeUrlBase64Decode(_ safeBase64Str: String) -> String {
        var base64Str = safeBase64Str
        
        base64Str = base64Str.replacingOccurrences(of: "-", with: "+")
        base64Str = base64Str.replacingOccurrences(of: "_", with: "/")
       
        let mod4 = base64Str.count % 4
        if mod4 > 0 {
            base64Str.append("====".subString(to: mod4))
        }
        
        return base64Str
    }
}

// MARK: Size

public extension String {
    
    // MARK:- 获取字符串大小
    func getSize(font: UIFont, width: CGFloat = UIScreen.main.bounds.width) -> CGSize {
        let str = self as NSString
        
        let size = CGSize(width: width, height: CGFloat(MAXFLOAT))
        return str.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil).size
    }
    
    /// 数字简写转换
    static func simplifyValues(_ number: Int64) -> String {
        var value = "0"
        
        if number > 1000 {
            value = "\(number)"
        }
        else if number > 1000 {
            value = String(format: "%.0f", number) + "k"
        }
        else if number > 10000 {
            value = String(format: "%.0f", number) + "w"
        }
        else {
            value = "\(number)"
        }
        return value
    }
}

//subString
extension String {
    func substring(from: Int?, to: Int?) -> String {
        if let start = from {
            guard start < self.count else {
                return ""
            }
        }

        if let end = to {
            guard end >= 0 else {
                return ""
            }
        }

        if let start = from, let end = to {
            guard end - start >= 0 else {
                return ""
            }
        }

        let startIndex: String.Index
        if let start = from, start >= 0 {
            startIndex = self.index(self.startIndex, offsetBy: start)
        } else {
            startIndex = self.startIndex
        }

        let endIndex: String.Index
        if let end = to, end >= 0, end < self.count {
            endIndex = self.index(self.startIndex, offsetBy: end + 1)
        } else {
            endIndex = self.endIndex
        }

        return String(self[startIndex ..< endIndex])
    }

    func substring(from: Int) -> String {
        return self.substring(from: from, to: nil)
    }

    func substring(to: Int) -> String {
        return self.substring(from: nil, to: to)
    }

    func substring(from: Int?, length: Int) -> String {
        guard length > 0 else {
            return ""
        }

        let end: Int
        if let start = from, start > 0 {
            end = start + length - 1
        } else {
            end = length - 1
        }

        return self.substring(from: from, to: end)
    }

    func substring(length: Int, to: Int?) -> String {
        guard let end = to, end > 0, length > 0 else {
            return ""
        }

        let start: Int
        if let end = to, end - length > 0 {
            start = end - length + 1
        } else {
            start = 0
        }

        return self.substring(from: start, to: to)
    }
}


public extension String {
    
    func createQRCodeImage(size:CGSize)->UIImage {
        let stringData = self.data(using: String.Encoding.utf8)
        let qrFilter = CIFilter(name: "CIQRCodeGenerator")
        
        qrFilter?.setValue(stringData, forKey: "inputMessage")
        qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
        
        let colorFilter = CIFilter(name: "CIFalseColor")
        colorFilter?.setDefaults()
        
        colorFilter?.setValuesForKeys(["inputImage" : (qrFilter?.outputImage)!,"inputColor0":CIColor.init(cgColor: UIColor.black.cgColor),"inputColor1":CIColor.init(cgColor: UIColor.white.cgColor)])
        
        let qrImage = colorFilter?.outputImage
        let cgImage = CIContext(options: nil).createCGImage(qrImage!, from: (qrImage?.extent)!)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context!.interpolationQuality = .none
        context!.scaleBy(x: 1.0, y: -1.0)
        context?.draw(cgImage!, in: (context?.boundingBoxOfClipPath)!)
        let codeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return codeImage!
    }
}

