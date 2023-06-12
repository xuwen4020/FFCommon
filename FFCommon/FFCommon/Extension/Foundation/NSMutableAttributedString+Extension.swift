//
//  NSMutableAttributedString+Extension.swift
//  FFCommon
//
//  Created by xuwen on 2023/6/12.
//

import Foundation
import UIKit

public extension NSAttributedString {

    func width(considering height: CGFloat) -> CGFloat {
        let size = self.size(consideringHeight: height)
        return size.width
    }
    
    func height(considering width: CGFloat) -> CGFloat {
        let size = self.size(consideringWidth: width)
        return size.height
    }
    
    func size(consideringHeight height: CGFloat) -> CGSize {
        let constraintBox = CGSize(width: .greatestFiniteMagnitude, height: height)
        return self.size(considering: constraintBox)
    }
    
    func size(consideringWidth width: CGFloat) -> CGSize {
        let constraintBox = CGSize(width: width, height: .greatestFiniteMagnitude)
        return self.size(considering: constraintBox)
    }
    
    func size(considering size: CGSize) -> CGSize {
        let rect = self.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return rect.size
    }
}

public extension NSMutableAttributedString {
    /// 设置前景色
    /// - Parameters:
    ///   - value: 前景色
    ///   - range: 设置范围
    func setTextColor(_ value: UIColor, range: NSRange? = nil) {
        let rag = range == nil ? .init(location: 0, length: length) : range
        setAttributes([.foregroundColor: value], range: rag!)
    }
    
    /// 设置背景色
    /// - Parameters:
    ///   - value: 背景色
    ///   - range: 设置范围
    func setBackgroundColor(_ value: UIColor, range: NSRange? = nil) {
        let rag = range == nil ? .init(location: 0, length: length) : range
        setAttributes([.backgroundColor: value], range: rag!)
    }
    
    /// 设置字体
    /// - Parameters:
    ///   - value: 字体
    ///   - range: 设置范围
    func setFont(_ value: UIFont, range: NSRange? = nil) {
        let rag = range == nil ? .init(location: 0, length: length) : range
        setAttributes([.font: value], range: rag!)
    }
    
    /// 斜体
    /// - Parameters:
    ///   - value: 斜体
    ///   - range: 设置范围
    func setOblique(_ value: CGFloat, range: NSRange? = nil) {
        let rag = range == nil ? .init(location: 0, length: length) : range
        setAttributes([.obliqueness: value], range: rag!)
    }

    /// 文本横向拉伸属性，正值横向拉伸文本，负值横向压缩文本
    /// - Parameters:
    ///   - value: 拉伸
    ///   - range: 设置范围
    func setExpansion(_ value: CGFloat, range: NSRange? = nil) {
        let rag = range == nil ? .init(location: 0, length: length) : range
        setAttributes([.expansion: value], range: rag!)
    }

    /// 字间距
    /// - Parameters:
    ///   - value: 间距
    ///   - range: 设置范围
    func setKern(_ value: CGFloat, range: NSRange? = nil) {
        let rag = range == nil ? .init(location: 0, length: length) : range
        setAttributes([.kern: value], range: rag!)
    }
    
    /// 添加Link
    /// - Parameters:
    ///   - value: link
    ///   - range: 设置范围
    func setLinkValue(_ value: URL, range: NSRange? = nil) {
        let rag = range == nil ? .init(location: 0, length: length) : range
        setAttributes([.link: value], range: rag!)
    }
    
    /// 行间距
    /// - Parameters:
    ///   - value: 间距
    ///   - range: 设置范围
    func setLineSpacing(_ value: CGFloat, range: NSRange? = nil) {
        let rag = range == nil ? .init(location: 0, length: length) : range
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = value
        setAttributes([.paragraphStyle: paragraphStyle], range: rag!)
    }

    /// 最小行高
    /// - Parameters:
    ///   - value: 行高
    ///   - range: 设置范围
    func setMinimumLineHeight(_ value: CGFloat, range: NSRange? = nil) {
        let rag = range == nil ? .init(location: 0, length: length) : range
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = value
        setAttributes([.paragraphStyle: paragraphStyle], range: rag!)
    }

    /// 最大行高
    /// - Parameters:
    ///   - value: 行高
    ///   - range: 设置范围
    func setMaximumLineHeight(_ value: CGFloat, range: NSRange? = nil) {
        let rag = range == nil ? .init(location: 0, length: length) : range
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = value
        setAttributes([.paragraphStyle: paragraphStyle], range: rag!)
    }

    /// 段落间距
    /// - Parameters:
    ///   - value: 间距
    ///   - range: 设置范围
    func setParagraphSpacing(_ value: CGFloat, range: NSRange? = nil) {
        let rag = range == nil ? .init(location: 0, length: length) : range
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = value
        setAttributes([.paragraphStyle: paragraphStyle], range: rag!)
    }
    
    
    /// 添加附件
    /// - Parameters:
    ///   - image: 图片
    ///   - attachmentSize: 附件大小
    /// - Returns: 富文本
    static func addAttachment(_ image: UIImage, attachmentSize: CGSize) -> NSMutableAttributedString {
        let attch = NSTextAttachment()
        attch.image = image
        attch.bounds = CGRect(x: 0, y: 0, width: attachmentSize.width, height: attachmentSize.height)
        return NSMutableAttributedString(attachment: attch)
    }
}

public extension NSMutableAttributedString {
    /// 快捷初始化
    convenience init(_ text: String, attributes: ((_ item: AttributesItem) -> Void)? = nil) {
        let item = AttributesItem()
        attributes?(item)
        self.init(string: text, attributes: item.attributes)
    }

    /// 添加字符串并为此段添加对应的Attribute
    @discardableResult
    func addText(_ text: String, attributes: ((_ item: AttributesItem) -> Void)? = nil) -> NSMutableAttributedString {
        let item = AttributesItem()
        attributes?(item)
        append(NSMutableAttributedString(string: text, attributes: item.attributes))
        return self
    }

    /// 添加Attribute作用于当前整体字符串，如果不包含传入的attribute，则增加当前特征
    @discardableResult
    func addAttributes(_ attributes: (_ item: AttributesItem) -> Void) -> NSMutableAttributedString {
        let item = AttributesItem()
        attributes(item)
        enumerateAttributes(in: NSRange(string.startIndex ..< string.endIndex, in: string), options: .reverse) { oldAttribute, range, _ in
            var newAtt = oldAttribute
            for item in item.attributes where !oldAttribute.keys.contains(item.key) {
                newAtt[item.key] = item.value
            }
            addAttributes(newAtt, range: range)
        }
        return self
    }

    /// 添加图片
    @discardableResult
    func addImage(_ image: UIImage?, _ bounds: CGRect) -> NSMutableAttributedString {
        let attch = NSTextAttachment()
        attch.image = image
        attch.bounds = bounds
        append(NSAttributedString(attachment: attch))
        return self
    }
    
    /// 添加图片
    @discardableResult
    func addImage(_ image: UIImage?, _ font: UIFont) -> NSMutableAttributedString {
        let attch = NSTextAttachment()
        attch.image = image
        let w = CGFloat(attch.image?.cgImage?.width ?? 1)
        let h = CGFloat(attch.image?.cgImage?.height ?? 1)
        let scale = w/h
        attch.bounds = CGRect(x: 0, y: -4, width: font.lineHeight*CGFloat(scale), height: font.lineHeight)
        append(NSAttributedString(attachment: attch))
        return self
    }
    
    
    /// 计算行数
    func calculateLines(with width: CGFloat) -> Int {
        let frameSetter = CTFramesetterCreateWithAttributedString(self)
        let path = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: width, height: 100_000), transform: .identity)
        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        let lines = CTFrameGetLines(frame)
        let linesArray = lines as Array
        return linesArray.count
    }
}

public extension NSAttributedString {
    class AttributesItem {
        private(set) var attributes = [NSAttributedString.Key: Any]()
        private(set) lazy var paragraphStyle = NSMutableParagraphStyle()
        /// 字体
        @discardableResult
        public func font(_ value: UIFont) -> AttributesItem {
            attributes[.font] = value
            return self
        }

        /// 字体颜色
        @discardableResult
        public func foregroundColor(_ value: UIColor) -> AttributesItem {
            attributes[.foregroundColor] = value
            return self
        }
        
        /// 背景颜色
        @discardableResult
        public func backgroundColor(_ value: UIColor) -> AttributesItem {
            attributes[.backgroundColor] = value
            return self
        }

        /// 斜体
        @discardableResult
        public func oblique(_ value: CGFloat) -> AttributesItem {
            attributes[.obliqueness] = value
            return self
        }

        /// 文本横向拉伸属性，正值横向拉伸文本，负值横向压缩文本
        @discardableResult
        public func expansion(_ value: CGFloat) -> AttributesItem {
            attributes[.expansion] = value
            return self
        }

        /// 字间距
        @discardableResult
        public func kern(_ value: CGFloat) -> AttributesItem {
            attributes[.kern] = value
            return self
        }
        
        /// 删除线
        @discardableResult
        public func strikeStyle(_ value: NSUnderlineStyle) -> AttributesItem {
            attributes[.strikethroughStyle] = value.rawValue
            return self
        }

        /// 删除线颜色
        @discardableResult
        public func strikeColor(_ value: UIColor) -> AttributesItem {
            attributes[.strikethroughColor] = value
            return self
        }

        /// 下划线
        @discardableResult
        public func underlineStyle(_ value: NSUnderlineStyle) -> AttributesItem {
            attributes[.underlineStyle] = value.rawValue
            return self
        }

        /// 下划线颜色
        @discardableResult
        public func underlineColor(_ value: UIColor) -> AttributesItem {
            attributes[.underlineColor] = value
            return self
        }

        /// 设置基线偏移值，正值上偏，负值下偏
        @discardableResult
        public func baselineOffset(_ value: CGFloat) -> AttributesItem {
            attributes[.baselineOffset] = value
            return self
        }

        /// 居中方式
        @discardableResult
        public func alignment(_ value: NSTextAlignment) -> AttributesItem {
            paragraphStyle.alignment = value
            attributes[.paragraphStyle] = paragraphStyle
            return self
        }

        /// 字符截断类型
        @discardableResult
        public func lineBreakMode(_ value: NSLineBreakMode) -> AttributesItem {
            paragraphStyle.lineBreakMode = value
            attributes[.paragraphStyle] = paragraphStyle
            return self
        }

        /// 行间距
        @discardableResult
        public func lineSpacing(_ value: CGFloat) -> AttributesItem {
            paragraphStyle.lineSpacing = value
            attributes[.paragraphStyle] = paragraphStyle
            return self
        }

        /// 最小行高
        @discardableResult
        public func minimumLineHeight(_ value: CGFloat) -> AttributesItem {
            paragraphStyle.minimumLineHeight = value
            attributes[.paragraphStyle] = paragraphStyle
            return self
        }

        /// 最大行高
        @discardableResult
        public func maximumLineHeight(_ value: CGFloat) -> AttributesItem {
            paragraphStyle.maximumLineHeight = value
            attributes[.paragraphStyle] = paragraphStyle
            return self
        }

        /// 段落间距
        @discardableResult
        public func paragraphSpacing(_ value: CGFloat) -> AttributesItem {
            paragraphStyle.paragraphSpacing = value
            attributes[.paragraphStyle] = paragraphStyle
            return self
        }
        
        /// 添加Link
        @discardableResult
        public func linkValue(_ value: URL) -> AttributesItem {
            attributes[.link] = value
            return self
        }
    }
}

