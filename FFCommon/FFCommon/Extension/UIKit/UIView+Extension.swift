//
//  UIView+Extension.swift
//  FFCommon
//
//  Created by xuwen on 2023/6/12.
//

import CoreGraphics
import Foundation
import QuartzCore
import UIKit

// MARK: - UIView Frame extension
public extension UIView {
    /// frame.size.width
    var width: CGFloat {
        get {
            frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
    /// frame.size.height
    var height: CGFloat {
        get {
            frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
    /// frame.origin.x
    var x: CGFloat {
        get {
            frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }
    /// frame.origin.y
    var y: CGFloat {
        get {
            frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
    /// center.x
    var centerX: CGFloat {
        get {
            center.x
        }
        set {
            center = CGPoint(x: newValue, y: self.center.y)
        }
    }
    /// center.y
    var centerY: CGFloat {
        get {
            center.y
        }
        set {
            center = CGPoint(x: self.center.x, y: newValue)
        }
    }
    /// frame.origin.x
    var left: CGFloat {
        get {
            frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }
    /// frame.origin.x + width
    var right: CGFloat {
        get {
            frame.origin.x + width
        }
        set {
            frame.origin.x = newValue - width
        }
    }
    /// frame.origin.y
    var top: CGFloat {
        get {
            frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
    /// frame.origin.y + height
    var bottom: CGFloat {
        get {
            frame.origin.y + height
        }
        set {
            frame.origin.y = newValue - height
        }
    }
    /// frame.size
    var size: CGSize {
        get {
            frame.size
        }
        set {
            frame.size = newValue
        }
    }
    /// frame.origin
    var origin: CGPoint {
        get {
            frame.origin
        }
        set {
            frame.origin = newValue
        }
    }
}

// MARK: - UIView inspectable extension

/// Extends UIView with inspectable variables.
@IBDesignable
extension UIView {
    // MARK: - Variables
    
    /// 边框线宽
    @IBInspectable public var bordersWidth: CGFloat {
        get {
            layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    /// 边框颜色
    @IBInspectable public var borderColor: UIColor {
        get {
            guard let borderColor = layer.borderColor else {
                return UIColor.clear
            }
            
            return UIColor(cgColor: borderColor)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
    
    /// 视图的图层上的子图层,如果超出父图层的部分就截取掉
    ///
    /// Set it to true if you want to enable corner radius.
    ///
    /// Set it to false if you want to enable shadow.
    @IBInspectable public var maskToBounds: Bool {
        get {
            layer.masksToBounds
        }
        set {
            layer.masksToBounds = newValue
        }
    }
    
    /// 设置圆角（圆角半径）
    ///
    /// Remeber to set maskToBounds to true.
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    /// 阴影颜色
    ///
    /// Remeber to set maskToBounds to false.
    @IBInspectable public var shadowColor: UIColor {
        get {
            guard let shadowColor = layer.shadowColor else {
                return UIColor.clear
            }
            
            return UIColor(cgColor: shadowColor)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    
    /// 阴影可见度 0--1
    ///
    /// Remeber to set maskToBounds to false.
    @IBInspectable public var shadowOpacity: Float {
        get {
            layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    ///  阴影X轴偏移
    ///
    /// Remeber to set maskToBounds to false.
    @IBInspectable public var shadowOffsetX: CGFloat {
        get {
            layer.shadowOffset.width
        }
        set {
            layer.shadowOffset = CGSize(width: newValue, height: layer.shadowOffset.height)
        }
    }
    
    /// 阴影Y轴偏移
    ///
    /// Remeber to set maskToBounds to false.
    @IBInspectable public var shadowOffsetY: CGFloat {
        get {
            layer.shadowOffset.height
        }
        set {
            layer.shadowOffset = CGSize(width: layer.shadowOffset.width, height: newValue)
        }
    }
    /// 阴影偏移量 默认为(0，-3)
    @IBInspectable public var shadowOffset: CGSize {
        get {
            layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    /// 阴影半径
    ///
    /// Remeber to set maskToBounds to false.
    @IBInspectable public var shadowRadius: CGFloat {
        get {
            layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
}

// MARK: - UIView extension
/// 这个扩展为 UIView 添加了一些有用的功能。
public extension UIView {
    // MARK: - Functions
    
    /// 使用给定的框架和背景颜色创建一个 UIView。
    ///
    /// - Parameters:
    ///   - frame: UIView frame.
    ///   - backgroundColor: UIView background color.
    convenience init(frame: CGRect, backgroundColor: UIColor) {
        self.init(frame: frame)
        self.backgroundColor = backgroundColor
    }
    
    /// 添加模糊视图
    /// - Parameter style: 模糊类型
    func blur(style: UIBlurEffect.Style) {
        unBlur()
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        insertSubview(blurEffectView, at: 0)
        blurEffectView.frame = self.bounds
//        blurEffectView.snp.makeConstraints({ (make) in
//            make.edges.equalToSuperview()
//        })
    }

    /// 移除模糊视图
    func unBlur() {
        subviews.filter { (view) -> Bool in
            view as? UIVisualEffectView != nil
        }.forEach { (view) in
            view.removeFromSuperview()
        }
    }
    /// 在 UIView 周围创建一个边框。
    ///
    /// - Parameters:
    ///   - color: Border color.
    ///   - radius: Border radius.
    ///   - width: Border width.
    func border(color: UIColor, radius: CGFloat, width: CGFloat) {
        layer.borderWidth = width
        layer.cornerRadius = radius
        layer.shouldRasterize = false
        layer.rasterizationScale = 2
        clipsToBounds = true
        layer.masksToBounds = true
        
        let cgColor: CGColor = color.cgColor
        layer.borderColor = cgColor
    }
    
    /// 移除 UIView 周围的边框。
    func removeBorder(maskToBounds: Bool = true) {
        layer.borderWidth = 0
        layer.cornerRadius = 0
        layer.borderColor = nil
        layer.masksToBounds = maskToBounds
    }
    
    /// 仅在给定角处设置 UIView 的角半径。
    /// 目前不支持 `frame` 属性更改。
    /// 如果你改变了框架，你必须再次调用这个函数。
    ///
    /// - Parameters:
    ///   - corners: Corners to apply radius.
    ///   - radius: Radius value.
    func cornerRadius(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
    
    /// 为所有角设置UIView的角半径。
    /// 这个函数支持`frame`属性的变化，
    /// 它不同于 `cornerRadius(corners: UIRectCorner, radius: CGFloat)`
    /// 不支持它。
    ///
    /// - Parameter radius: Radius value.
    func cornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    /// 直接画圆
    func setHalfRadius() {
        cornerRadius(height / 2.0)
    }
    
    /// 在 UIView 上创建阴影。
    ///
    /// - Parameters:
    ///   - offset: Shadow offset.
    ///   - opacity: Shadow opacity.
    ///   - radius: Shadow radius.
    ///   - color: Shadow color. Default is black.
    func shadow(offset: CGSize, opacity: Float, radius: CGFloat, cornerRadius: CGFloat = 0, color: UIColor = UIColor.black) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        if cornerRadius != 0 {
            layer.cornerRadius = cornerRadius
            layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        }
        layer.masksToBounds = false
    }
    
    /// 移除 UIView 周围的阴影。
    func removeShadow(maskToBounds: Bool = true) {
        layer.shadowColor = nil
        layer.shadowOpacity = 0.0
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 0
        layer.cornerRadius = 0
        layer.shadowPath = nil
        layer.masksToBounds = maskToBounds
    }
    
    /// 绘制虚线
    /// - Parameters:
    ///   - rect: 虚线框Rect
    ///   - radius: 虚线圆角
    ///   - color: 虚线颜色
    func dottedLine(_ rect: CGRect, _ radius: CGFloat, _ color: UIColor) {
        let layer = CAShapeLayer()
        layer.bounds = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
        layer.position = CGPoint(x: rect.midX, y: rect.midY)
        layer.path = UIBezierPath(rect: layer.bounds).cgPath
        layer.path = UIBezierPath(roundedRect: layer.bounds, cornerRadius: radius).cgPath
        layer.lineWidth = 1/UIScreen.main.scale
        //虚线边框
        layer.lineDashPattern = [NSNumber(value: 5), NSNumber(value: 5)]
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color.cgColor
        
        self.layer.addSublayer(layer)
    }
    /// 截取当前视图的屏幕截图
    ///
    /// - Parameter save: Save the screenshot in user pictures. Default is false.
    /// - Returns: Returns screenshot as UIImage
    func screenshot(save: Bool = false, rect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        UIRectClip(rect)
        layer.render(in: context)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        
        UIGraphicsEndImageContext()
        
        if save {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        
        return image
    }
    
    /// 从当前视图中删除所有子视图
    func removeAllSubviews() {
        subviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
}

// MARK: - UIView extension
/// 这个扩展为 UIView 添加渐变
public extension UIView {
    // MARK: - Variables
    
    /// Direction of flip animation.
    enum UIViewAnimationFlipDirection: String {
        /// Flip animation from top.
        case top = "fromTop"
        /// Flip animation from left.
        case left = "fromLeft"
        /// Flip animation from right.
        case right = "fromRight"
        /// Flip animation from bottom.
        case bottom = "fromBottom"
    }
    
    /// Direction of the translation.
    enum UIViewAnimationTranslationDirection: Int {
        /// Translation from left to right.
        case leftToRight
        /// Translation from right to left.
        case rightToLeft
    }
    
    /// Direction of the linear gradient.
    enum UIViewGradientDirection {
        /// Linear gradient vertical. y: 0.5 --> 1
        case vertical
        /// Linear gradient horizontal. x: 0.5 --> 1
        case horizontal
        /// y: 0 --> 1
        case verticalTopToDown
        /// x: 0 --> 1
        case horizontalLeftToRight
        /// Linear gradient from left top to right down.
        case diagonalLeftTopToRightDown
        /// Linear gradient from left down to right top.
        case diagonalLeftDownToRightTop
        /// Linear gradient from right top to left down.
        case diagonalRightTopToLeftDown
        ///  Linear gradient from right down to left top.
        case diagonalRightDownToLeftTop
        /// Custom gradient direction.
        case custom(startPoint: CGPoint, endPoint: CGPoint)
    }
    
    /// Type of gradient.
    enum UIViewGradientType {
        /// Linear gradient.
        case linear
        /// Radial gradient.
        case radial
    }
    
    /// 创建一个线性渐变。
    ///
    /// - Parameters:
    ///   - colors: Array of UIColor instances.
    ///   - direction: Direction of the gradient.
    /// - Returns: Returns the created CAGradientLayer.
    @discardableResult
    func gradient(colors: [UIColor], rect: CGRect? = nil, direction: UIViewGradientDirection) -> CAGradientLayer {

        // 如果有渐变色就先移除
        let _ = layer.sublayers?.filter{ $0.isKind(of: CAGradientLayer.self)}.map { $0.removeFromSuperlayer() }
        
        let gradient = CAGradientLayer()
        if let rect = rect {
            gradient.frame = rect
        } else {
            gradient.frame = bounds
        }
        var mutableColors: [Any] = colors
        for index in 0 ..< colors.count {
            let currentColor: UIColor = colors[index]
            mutableColors[index] = currentColor.cgColor
        }
        gradient.colors = mutableColors
        gradient.locations = [0, 1]
        
        switch direction {
        case .vertical:
            gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
            
        case .horizontal:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)

        case .verticalTopToDown:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.0, y: 1.0)

        case .horizontalLeftToRight:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
            
        case .diagonalLeftTopToRightDown:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 1.0)

        case .diagonalLeftDownToRightTop:
            gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.0)

        case .diagonalRightTopToLeftDown:
            gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.0, y: 1.0)

        case .diagonalRightDownToLeftTop:
            gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.0)

        case let .custom(startPoint, endPoint):
            gradient.startPoint = startPoint
            gradient.endPoint = endPoint
        }
        layer.insertSublayer(gradient, at: 0)
        
        return gradient
    }
    
    /// 创建平滑的线性渐变，需要更多的计算时间
    ///
    ///     gradient(colors:,direction:)
    ///
    /// - Parameters:
    ///   - colors: Array of UIColor instances.
    ///   - direction: Direction of the gradient.
    func smoothGradient(colors: [UIColor], direction: UIViewGradientDirection, type: UIViewGradientType = .linear) {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIImage.screenScale())
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var locations: [CGFloat] = [0.0, 1.0]
        var components: [CGFloat] = []
        
        for (index, color) in colors.enumerated() {
            if index != 0 && index != 1 {
                locations.insert(CGFloat(Float(1) / Float(colors.count - 1)), at: 1)
            }
            
            components.append(color.redComponent)
            components.append(color.greenComponent)
            components.append(color.blueComponent)
            components.append(color.alpha)
        }
        
        var startPoint: CGPoint
        var endPoint: CGPoint
        
        switch direction {
        case .vertical:
            startPoint = CGPoint(x: bounds.midX, y: 0.0)
            endPoint = CGPoint(x: bounds.midX, y: bounds.height)

        case .horizontal:
            startPoint = CGPoint(x: 0.0, y: bounds.midY)
            endPoint = CGPoint(x: bounds.width, y: bounds.midY)

        case .diagonalLeftTopToRightDown:
            startPoint = CGPoint(x: 0.0, y: 0.0)
            endPoint = CGPoint(x: bounds.width, y: bounds.height)

        case .diagonalLeftDownToRightTop:
            startPoint = CGPoint(x: 0.0, y: bounds.height)
            endPoint = CGPoint(x: bounds.width, y: 0.0)

        case .diagonalRightTopToLeftDown:
            startPoint = CGPoint(x: bounds.width, y: 0.0)
            endPoint = CGPoint(x: 0.0, y: bounds.height)

        case .diagonalRightDownToLeftTop:
            startPoint = CGPoint(x: bounds.width, y: bounds.height)
            endPoint = CGPoint(x: 0.0, y: 0.0)

        case let .custom(customStartPoint, customEndPoint):
            startPoint = customStartPoint
            endPoint = customEndPoint
            
        case .verticalTopToDown:
            startPoint = CGPoint(x: 0.0, y: 0.0)
            endPoint = CGPoint(x: 0.0, y: bounds.height)
            
        case .horizontalLeftToRight:
            startPoint = CGPoint(x: 0.0, y: 0.0)
            endPoint = CGPoint(x: bounds.width, y: bounds.midY)
        }
        
        guard let gradient = CGGradient(colorSpace: colorSpace, colorComponents: components, locations: locations, count: locations.count) else {
            return
        }
        
        switch type {
        case .linear:
            context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: .drawsBeforeStartLocation)

        case .radial:
            context.drawRadialGradient(gradient, startCenter: startPoint, startRadius: 0.0, endCenter: endPoint, endRadius: 1.0, options: .drawsBeforeStartLocation)
        }
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return
        }
        
        UIGraphicsEndImageContext()
        
        let imageView = UIImageView(image: image)
        insertSubview(imageView, at: 0)
    }
    
    /// 边框渐变
    /// - Parameters:
    ///   - colors: 渐变颜色数组
    ///   - radius: 边框圆角
    ///   - lineWidth: 线宽
    func border(gradient colors: [UIColor], radius: CGFloat, lineWidth: CGFloat) {
        
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: frame.size)
        
        gradient.colors = colors.map{ $0.cgColor }
        gradient.cornerRadius = radius
        
        let shape = CAShapeLayer()
        shape.lineWidth = lineWidth
        let rounde = lineWidth/2
        shape.path = UIBezierPath(roundedRect:
                                    CGRect(x: rounde, y: rounde, width: width - lineWidth, height: height - lineWidth),
                                  cornerRadius: radius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.cornerRadius = radius
        gradient.mask = shape
        
        layer.addSublayer(gradient)
    }
}


public extension UIView {
    
    //MARK: - 画圆角
    func drawCorner(corners:UIRectCorner, color:UIColor, radiuce:CGFloat, width:CGFloat) {
        var path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSizeMake(radiuce, radiuce))
        path.lineWidth = width;
        color.set()
        path.stroke()
        var maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        self.layer.masksToBounds = true
    }
    
    func drawCorner(color:UIColor, radiuce:CGFloat, width:CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.cornerRadius = radiuce
        self.layer.masksToBounds = true
    }
    
    func drawCorner(radiuce:CGFloat) {
        self.layer.cornerRadius = radiuce
        self.layer.masksToBounds = true
    }
    
    
    enum BorderCorners: Int32 {
        case top = 1
        case left = 2
        case bottom = 4
        case right  = 8
    }
    
    func setBorderWithView(corners:[BorderCorners],width:CGFloat,color:UIColor) {
        if corners.contains(.top) {
            
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
            layer.backgroundColor = color.cgColor
            self.layer.addSublayer(layer)
        }
        
        if corners.contains(.left) {
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
            layer.backgroundColor = color.cgColor
            self.layer.addSublayer(layer)
        }
        
        if corners.contains(.bottom) {
            let layer = CALayer()
            layer.frame = CGRect(x: 0, y: self.frame.size.height - width, width: width, height: width)
            layer.backgroundColor = color.cgColor
            self.layer.addSublayer(layer)
        }
        
        if corners.contains(.right){
            
            let layer = CALayer()
            layer.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
            layer.backgroundColor = color.cgColor
            self.layer.addSublayer(layer)
        }
    }
}


