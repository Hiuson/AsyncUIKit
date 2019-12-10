//
//  TextDrawer.swift
//  NodeDemo
//
//  Created by Amino on 2019/12/9.
//  Copyright © 2019 Amino. All rights reserved.
//

import UIKit

class TextDrawer: NSObject {
    static let shared = TextDrawer()
    
    func sizeForAttributedString(_ attributeString: NSAttributedString, _ constraint: CGSize, _ onlyFromCache: Bool = false) -> CGSize {
        guard attributeString.length > 0 else {
            return CGSize.zero
        }
        
        let normalized = cleanAttrString(attributeString)
        
        let cacheKey = [normalized, constraint] as NSArray
        
        var size = CGSize.zero
        
        let cachedSize = cachedSizes.object(forKey: cacheKey)?.cgSizeValue
        
        if cachedSize != nil {
            size = cachedSize!
        } else {
            if onlyFromCache {
                size = CGSize.zero;
            } else {
                let rect = attributeString.boundingRect(with: constraint, options: [.usesLineFragmentOrigin, .usesFontLeading, .truncatesLastVisibleLine], context: nil)
                
                size = CGSize(width: ceil(rect.size.width), height: ceil(rect.size.height))
                cachedSizes.setObject(NSValue.init(cgSize: size), forKey: cacheKey as NSArray)
            }
        }
        
        return size
    }
    
    func drawnImageForAttributedString(_ attributeString: NSAttributedString, _ constraint: CGSize) -> UIImage? {
        let cachedSize = sizeForAttributedString(attributeString, constraint, true)

        if !cachedSize.equalTo(CGSize.zero) {
            let cacheKey = [attributeString, cachedSize] as NSArray
            let cacheImage = cachedImages.object(forKey: cacheKey)
            if cacheImage != nil {
                return cacheImage!
            }
        }
        
        let stringSize = sizeForAttributedString(attributeString, constraint)
        let cacheKey = [attributeString, stringSize] as NSArray
        let cacheImage = cachedImages.object(forKey: cacheKey)
        if cacheImage != nil {
            return cacheImage!
        } else {
            let drawnImage = drawAttributeStringImage(attributeString, stringSize)
            guard drawnImage != nil else {
                return nil
            }
            self.cachedImages.setObject(drawnImage!, forKey: cacheKey)
            
            return drawnImage!
        }
    }
    
    let cachedSizes: NSCache<NSArray, NSValue> = NSCache()
    let cachedImages: NSCache<NSArray, UIImage> = NSCache()
    
    private func cleanAttrString(_ attributeString: NSAttributedString) -> NSAttributedString {
        let clean = NSMutableAttributedString.init(attributedString: attributeString)
        clean.removeAttribute(.foregroundColor, range: NSRange.init(location: 0, length: clean.length))
        
        return clean.copy() as! NSAttributedString
    }
    
    private func drawAttributeStringImage(_ attributeString: NSAttributedString, _ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let ctx = UIGraphicsGetCurrentContext()
        guard ctx != nil else {
            return nil
        }
        
        ctx!.saveGState()
        
        attributeString.draw(with: CGRect(origin: CGPoint.zero, size: size), options: [.usesLineFragmentOrigin, .usesFontLeading, .truncatesLastVisibleLine], context: nil)
        
        ctx!.restoreGState()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
