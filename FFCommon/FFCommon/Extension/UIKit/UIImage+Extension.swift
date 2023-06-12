//
//  UIImage+Extension.swift
//  FFCommon
//
//  Created by xuwen on 2023/6/12.
//

import Foundation
import UIKit

public extension UIImage {
    
    /// 从 base64 字符串创建图像。
    ///
    /// - Parameter base64: Base64 String.
    convenience init?(base64: String) {
        guard let data = Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
        else { return nil }
        
        self.init(data: data)
    }
    /// 从给定的颜色创建图像。
    /// - Parameters:
    ///   - color: Color value.
    ///   - size: 颜色大小
    convenience init?(color: UIColor, size: CGSize = .init(width: 1, height: 1)) {
        let rect = CGRect(x: 0, y: 0, width: size.width * UIImage.screenScale(), height: size.height * UIImage.screenScale())
        
        UIGraphicsBeginImageContext(rect.size)
        
        color.setFill()
        UIRectFill(rect)
        
        guard let image: UIImage = UIGraphicsGetImageFromCurrentImageContext(),
              let cgImage = image.cgImage
        else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        UIGraphicsEndImageContext()
        
        self.init(cgImage: cgImage, scale: UIImage.screenScale(), orientation: .up)
    }
    /// 创建按给定角度旋转
    ///
    ///     // Rotate the image by 180°
    ///     image.rotated(by: .pi)
    ///
    /// - Parameter radians: 旋转图像的角度(以弧度为单位)
    /// - Returns: 按给定角度旋转的新图像
    func rotated(by radians: CGFloat) -> UIImage? {
        let destRect = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: radians))
        let roundedDestRect = CGRect(x: destRect.origin.x.rounded(),
                                     y: destRect.origin.y.rounded(),
                                     width: destRect.width.rounded(),
                                     height: destRect.height.rounded())

        UIGraphicsBeginImageContextWithOptions(roundedDestRect.size, false, scale)
        guard let contextRef = UIGraphicsGetCurrentContext() else { return nil }

        contextRef.translateBy(x: roundedDestRect.width / 2, y: roundedDestRect.height / 2)
        contextRef.rotate(by: radians)

        draw(in: CGRect(origin: CGPoint(x: -size.width / 2,
                                        y: -size.height / 2),
                        size: size))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    /// 根据设备返回屏幕比例。
    ///
    /// - Returns: Returns the screen scale, based on the device.
    static func screenScale() -> CGFloat {
        // UIScreen.main.scale == 1; //代表320 x 480 的分辨率
        // UIScreen.main.scale == 2; //代表640 x 960 的分辨率
        // UIScreen.main.scale == 3; //代表1242 x 2208 的分辨率
        return UIScreen.main.scale
    }
    ///设置image的透明度
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
// MARK: - 图片压缩
extension UIImage {
    
    /// 高斯模糊
    func createGaussianBlurImage() -> UIImage? {
        guard let ciImage = CIImage(image: self) else { return nil }
        // 创建高斯模糊滤镜类
        guard let blurFilter = CIFilter(name: "CIGaussianBlur") else { return nil }
        
        // key 可以在控制台打印 po blurFilter.inputKeys
        // 设置图片
        blurFilter.setValue(ciImage, forKey: "inputImage")
        // 设置模糊值
        blurFilter.setValue(25, forKey: "inputRadius")
        // 从滤镜中 取出图片
        guard let outputImage = blurFilter.outputImage else { return nil }

        // 创建上下文
        let context = CIContext(options: nil)
        // 根据滤镜中的图片 创建CGImage
        guard let cgImage = context.createCGImage(outputImage, from: ciImage.extent) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
    
    /// 压缩图片大小
    ///
    /// - Parameter maxSize: maxSize.
    func compressSize(with maxSize: Int) -> Data? {
        // 先判断当前质量是否满足要求，不满足再进行压缩
        guard var finallImageData = jpegData(compressionQuality: 1.0) else {return nil}
        if finallImageData.count / 1024 <= maxSize {
            return finallImageData
        }
        //先调整分辨率
        var defaultSize = CGSize(width: 1024, height: 1024)
        guard let compressImage = scaleSize(defaultSize), let compressImageData = compressImage.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        finallImageData = compressImageData
        
        //保存压缩系数
        var compressionQualityArray = [CGFloat]()
        let avg: CGFloat = 1.0 / 250
        var value = avg
        var i: CGFloat = 250.0
        repeat {
            i -= 1
            value = i * avg
            compressionQualityArray.append(value)
        } while i >= 1
        
        //调整大小，压缩系数数组compressionQualityArr是从大到小存储，思路：使用二分法搜索
        guard let halfData = halfFuntion(array: compressionQualityArray, image: compressImage, sourceData: finallImageData, maxSize: maxSize) else {
            return nil
        }
        finallImageData = halfData
        //如果还是未能压缩到指定大小，则进行降分辨率
        while finallImageData.count == 0 {
            //每次降100分辨率
            if defaultSize.width - 100 <= 0 || defaultSize.height - 100 <= 0 {
                break
            }
            defaultSize = CGSize(width: defaultSize.width - 100, height: defaultSize.height - 100)
            guard let lastValue = compressionQualityArray.last,
                let newImageData = compressImage.jpegData(compressionQuality: lastValue),
                let tempImage = UIImage(data: newImageData),
                let tempCompressImage = tempImage.scaleSize(defaultSize),
                let sourceData = tempCompressImage.jpegData(compressionQuality: 1.0),
                let halfData = halfFuntion(array: compressionQualityArray, image: tempCompressImage, sourceData: sourceData, maxSize: maxSize) else {
                return nil
            }
            finallImageData = halfData
        }
        return finallImageData
    }

    /// 调整图片分辨率/尺寸（等比例缩放）
    ///
    /// - Parameter newSize: newSize.
    func scaleSize(_ newSize: CGSize) -> UIImage? {
        let heightScale = size.height / newSize.height
        let widthScale = size.width / newSize.width
        
        var finallSize = CGSize(width: size.width, height: size.height)
        if widthScale > 1.0 && widthScale > heightScale {
            finallSize = CGSize(width: size.width / widthScale, height: size.height / widthScale)
        } else if heightScale > 1.0 && widthScale < heightScale {
            finallSize = CGSize(width: size.width / heightScale, height: size.height / heightScale)
        }
        UIGraphicsBeginImageContext(CGSize(width: Int(finallSize.width), height: Int(finallSize.height)))
        draw(in: CGRect(x: 0, y: 0, width: finallSize.width, height: finallSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    ///view转换成Image
    class func screenViewToImg(view: UIView) -> UIImage? {
        let s = view.bounds.size
        UIGraphicsBeginImageContextWithOptions(s, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
        }
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        UIGraphicsEndImageContext()
        return image
    }
    // MARK: - 二分法
    private func halfFuntion(array: [CGFloat], image: UIImage, sourceData: Data, maxSize: Int) -> Data? {
        var tempFinallImageData = sourceData
        var finallImageData = Data()
        var start = 0
        var end = array.count - 1
        var index = 0
        
        var difference = Int.max
        while start <= end {
            index = start + (end - start) / 2
            guard let data = image.jpegData(compressionQuality: array[index]) else {
                return nil
            }
            tempFinallImageData = data
            let sizeOrigin = tempFinallImageData.count
            let sizeOriginKB = sizeOrigin / 1024
            if sizeOriginKB > maxSize {
                start = index + 1
            } else if sizeOriginKB < maxSize {
                if maxSize - sizeOriginKB < difference {
                    difference = maxSize - sizeOriginKB
                    finallImageData = tempFinallImageData
                }
                if index<=0 {
                    break
                }
                end = index - 1
            } else {
                break
            }
        }
        return finallImageData
    }
    
    
    class func avatarPlaceholder() -> UIImage {
        
        return UIImage(named: "avatar_placeholder")!
    }
    
    class func imagePlaceholder() -> UIImage {
        
        return UIImage(named: "zhanwei_pic_placeholder")!
    }
}

