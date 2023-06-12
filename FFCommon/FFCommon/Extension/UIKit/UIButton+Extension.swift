//
//  UIButton+Extension.swift
//  FFCommon
//
//  Created by xuwen on 2023/6/12.
//

import UIKit

public extension UIButton {
    
    @discardableResult
    func backgroundColor<T: UIButton>(_ color: UIColor,
                                      _ state: UIControl.State) -> T {
        setBackgroundImage(UIImage(color: color), for: state)
        return self as! T
    }
    
    @discardableResult
    func titleFont<T: UIButton>(_ font: UIFont) -> T {
        titleLabel?.font = font
        return self as! T
    }
    
    /// 渐变背景
    @discardableResult
    func backgroundGradient<T: UIButton>(_ colours: [UIColor],
                                         _ isVertical: Bool = false,
                                         for state: UIControl.State) -> T {
        
        // 如果有渐变色就先移除
        let _ = layer.sublayers?.filter{ $0.isKind(of: CAGradientLayer.self)}.map { $0.removeFromSuperlayer() }
        
        let gradientLayer = CAGradientLayer()
        //几个颜色
        gradientLayer.colors = colours.map { $0.cgColor }
        //颜色的分界点
        gradientLayer.locations = [0.2,1.0]
        //开始
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        //结束,主要是控制渐变方向
        gradientLayer.endPoint = isVertical == true ? CGPoint(x: 0.0, y: 1.0) : CGPoint(x: 1.0, y: 0)
        //多大区域
        gradientLayer.frame = self.bounds.isEmpty ? CGRect(x: 0, y: 0, width: 320, height: 30) : self.bounds
        
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        
        if let context = UIGraphicsGetCurrentContext() {
            
            gradientLayer.render(in: context)
            
            let outputImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            setBackgroundImage(outputImage, for: state)
        }
        return self as! T
    }
    
    enum Position {
        case top,  bottom, left, right
    }
    /// 图片位置
    @discardableResult
    func imagePosition<T: UIButton>(with style: Position, spacing: CGFloat) -> T {
        let imageWidth = imageView?.width
        let imageHeight = imageView?.height
        var labelWidth: CGFloat! = 0.0
        var labelHeight: CGFloat! = 0.0
        labelWidth = titleLabel?.intrinsicContentSize.width
        labelHeight = titleLabel?.intrinsicContentSize.height

        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero

        switch style {
        case .top:
        imageEdgeInsets = UIEdgeInsets(top: -labelHeight-spacing/2, left: 0, bottom: 0, right: -labelWidth)
        labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!, bottom: -imageHeight!-spacing/2, right: 0)

        case .left:
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing/2, bottom: 0, right: spacing)
        labelEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2, bottom: 0, right: -spacing/2)

        case .bottom:
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight!-spacing/2, right: -labelWidth)
        labelEdgeInsets = UIEdgeInsets(top: -imageHeight!-spacing/2, left: -imageWidth!, bottom: 0, right: 0)

        case .right:
        imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+spacing/2, bottom: 0, right: -labelWidth-spacing/2)
        labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!-spacing/2, bottom: 0, right: imageWidth!+spacing/2)

        }
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
        
        return self as! T
    }
    /// Add a right image with custom offset to the current button.
    /// - Pa rameters:
    ///     - image: The image that will be added to the button.
    ///     - offset: The trailing margin that will be added between the image and the button's right border.
    func addRightImage(_ image: UIImage?, offset: CGFloat) {
        setImage(image, for: .normal)
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0.0).isActive = true
        imageView?.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset).isActive = true
    }
}

//MARK: 防止按钮连续点击
public typealias ActionBlock = ((UIButton)->Void)
extension UIButton {
    
    private struct AssociatedKeys {
        static var ActionBlock = "ActionBlock"
        static var ActionDelay = "ActionDelay"
    }
    
    /// 运行时关联
    private var actionBlock: ActionBlock? {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ActionBlock, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ActionBlock) as? ActionBlock
        }
    }
    
    private var actionDelay: TimeInterval {
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ActionDelay, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ActionDelay) as? TimeInterval ?? 0
        }
    }
    
    /// 点击回调
    @objc private func btnDelayClick(_ button: UIButton) {
        actionBlock?(button)
        isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + actionDelay) { [weak self] in
            print("恢复时间\(Date())")
            self?.isEnabled = true
        }
    }
    
    /// 添加点击事件
    /// - Parameters:
    ///   - delay: 延时时间 TimeInterval 默认0.8
    ///   - action: 点击回调
    public func addAction(_ delay: TimeInterval = 0.8, action: @escaping ActionBlock) {
        addTarget(self, action: #selector(btnDelayClick(_:)) , for: .touchUpInside)
        actionDelay = delay
        actionBlock = action
    }
}






private var key: Void?
private var expandSizeKey = "expandSizeKey"

extension UIButton {
    
    //MARK: - 快捷构造
    
    /// 通过图片构造
    public static func createByimage(name: String) -> UIButton{
        let button = UIButton(type: .custom)
        button.setImage(UIImage.init(named: name), for: .normal)
        return button
    }
    
    /// 一般构造
    public static func create(title: String,
                              font: UIFont,
                              titleColor: UIColor,
                              alignment: UIControl.ContentHorizontalAlignment = .center) -> UIButton{
        let button = UIButton(type: .custom)
        button.config(title: title, font: font, titleColor: titleColor, alignment: alignment)
        return button
    }
    
    /// 构造下一步按钮
    public static func createNextButton(title: String) -> UIButton{
        let button = self.create(title: title, font: UIFont.FontBold(size: 16), titleColor: .white, alignment: .center)
        button.backgroundColor = .black
        button.drawCorner(radiuce: 24)
        return button
    }
    
    /// 一般配置
    public func config(title: String,
                       font: UIFont,
                       titleColor: UIColor,
                       alignment: UIControl.ContentHorizontalAlignment) {
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = font
        self.setTitleColor(titleColor, for: .normal)
        self.contentHorizontalAlignment = alignment
    }
    
    // MARK: - 点击事件
    public func setAction(_ block:@escaping () -> Void){
        self.ButtonClicked = block
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(extensionTouchClick))
        self.addGestureRecognizer(tap)
    }
    
    var ButtonClicked:(() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &key) as? () -> Void
        }
        set {
            objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    @objc func extensionTouchClick(tap:UITapGestureRecognizer){
        guard let tag = tap.view?.tag else {
            return
        }
        if let block = self.ButtonClicked{
            block()
        }
    }
    
    //MARK: - 扩大热区
    public func expandTouchArea(size:CGFloat) {
        objc_setAssociatedObject(self, &expandSizeKey,size, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY)
    }
    
    private func expandRect() -> CGRect {
        let expandSize = objc_getAssociatedObject(self, &expandSizeKey)
        if (expandSize != nil) {
            return CGRect(x: bounds.origin.x - (expandSize as! CGFloat), y: bounds.origin.y - (expandSize as! CGFloat), width: bounds.size.width + 2*(expandSize as! CGFloat), height: bounds.size.height + 2*(expandSize as! CGFloat))
        }else{
            return bounds;
        }
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let buttonRect =  expandRect()
        if (buttonRect.equalTo(bounds)) {
            return super.point(inside: point, with: event)
        }else{
            return buttonRect.contains(point)
        }
    }
    
}

