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
        
        let cacheKey = [normalized, constraint] as [Any]
        
        var size = CGSize.zero
        
        let cachedSize = cachedSizes.object(forKey: cacheKey as NSArray)?.cgSizeValue
        
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
    
    let cachedSizes: NSCache<NSArray, NSValue> = NSCache()
    
    private func cleanAttrString(_ attributeString: NSAttributedString) -> NSAttributedString {
        let clean = NSMutableAttributedString.init(attributedString: attributeString)
        clean.removeAttribute(.foregroundColor, range: NSRange.init(location: 0, length: clean.length))
        
        return clean.copy() as! NSAttributedString
    }
}
