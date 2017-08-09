//
//  LPKitUIImage.swift
//  LPExtensions
//
//  Created by Guo Zhiqiang on 16/11/9.
//  Copyright © 2016年 Guo Zhiqiang. All rights reserved.
//

import UIKit

extension UIImage: NamespaceWrappable {}

public extension TypeWrapperProtocol where WrappedType == UIImage {
    
    /// Apply the alpha to the current image, return the new image
    func applying(alpha:CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(wrappedValue.size, false, 0.0)
        
        let ctx = UIGraphicsGetCurrentContext()
        let area = CGRect(x: 0, y: 0, width: wrappedValue.size.width, height: wrappedValue.size.height)
        
        if let ctx = ctx {
            ctx.translateBy(x: 1, y: -1)
            ctx.translateBy(x: 0, y: -area.size.height)
            
            ctx.setBlendMode(.multiply)
            
            ctx.setAlpha(alpha)
            
            ctx.draw(wrappedValue.cgImage!, in: area)
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            return newImage
        }
        return nil
    }
    
    /// Image placeholder
    static func imageWith(color: UIColor, size: CGSize = CGSize(width: 1, height: 1), hasBorder: Bool = false, cornerRadius: CGFloat = 0, borderColor: UIColor = UIColor.red) -> UIImage {
        let rect = CGRect(origin: CGPoint.zero, size: CGSize(width: size.width * UIScreen.main.scale, height: size.height * UIScreen.main.scale))
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext()
        
        context!.setLineWidth(0)
        if hasBorder {
            context!.setStrokeColor(borderColor.cgColor)
            context!.setLineWidth(0.5 * UIScreen.main.scale)
        }
        
        context!.setFillColor(color.cgColor)
        
        context!.addPath(CGPath(roundedRect: rect, cornerWidth: cornerRadius * UIScreen.main.scale, cornerHeight: cornerRadius * UIScreen.main.scale, transform: nil))
        context!.drawPath(using: .fillStroke)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func scaleImage(to size: CGSize,
                        contentMode: UIViewContentMode,
                        corner: CGFloat,
                        backGroundColor: UIColor = UIColor.clear) -> UIImage?
    {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        
        var newSize = wrappedValue.size
        var newImageFrame = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        switch contentMode {
        case .scaleAspectFit:
            newSize = wrappedValue.size.constrainedSize(toSize: size)
            if newSize.width == size.width {
                newImageFrame = CGRect(x: 0,
                                       y: (size.height - newSize.height)/2,
                                       width: newSize.width,
                                       height: newSize.height)
            }
            if newSize.height == size.height {
                newImageFrame = CGRect(x: 0,
                                       y: (size.width - newSize.width)/2,
                                       width: newSize.width,
                                       height: newSize.height)
            }
        case .scaleAspectFill:
            newSize = wrappedValue.size.fillingSize(toSize: size)
            if newSize.width > size.width {
                newImageFrame = CGRect(x: -(newSize.width - size.width)/2,
                                y: 0,
                                width: newSize.width,
                                height: newSize.height)
            }
            if newSize.height > size.height {
                newImageFrame = CGRect(x: 0,
                                y: -(newSize.height - size.height)/2,
                                width: newSize.width,
                                height: newSize.height)
            }
        default: break
        }
        backGroundColor.set()
        UIRectFill(newImageFrame)
        UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: corner).addClip()
        wrappedValue.draw(in: newImageFrame)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}

private extension CGSize {
    
    func fillingSize(toSize: CGSize) -> CGSize {
        let aspectWidth = round(aspectRatio * toSize.height)
        let aspectHeight = round(toSize.width / aspectRatio)
        return aspectWidth < toSize.width ?
            CGSize(width: toSize.width, height: aspectHeight) :
            CGSize(width: aspectWidth, height: toSize.height)
    }
    
    func constrainedSize(toSize: CGSize) -> CGSize {
        let aspectWidth = round(aspectRatio * toSize.height)
        let aspectHeight = round(toSize.width / aspectRatio)
        return aspectWidth > toSize.width ?
            CGSize(width: toSize.width, height: aspectHeight) :
            CGSize(width: aspectWidth, height: toSize.height)
    }
    private var aspectRatio: CGFloat {
        return height == 0.0 ? 1.0 : width / height
    }
}

