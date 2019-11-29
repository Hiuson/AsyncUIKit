//
//  TextNode.swift
//  NodeDemo
//
//  Created by Amino on 2019/11/29.
//  Copyright © 2019 Amino. All rights reserved.
//

import UIKit

class TextNode: BaseNode {
    var attributeString: NSAttributedString? {
        didSet {
//            strImage =
            cacheSize = nil
        }
    }
    
    var strImage: UIImage?
    
    override func viewClass<T>() -> T.Type where T : UIView {
        return UIImageView.self as! T.Type
    }
    
    func view() -> UIImageView {
        return view as! UIImageView
    }
    
    override func updateView() {
//        view().attributedText = attributeString
        view().image = strImage
    }
    
    var cacheSize: CGSize?
    
    func calculateSize(_ size: CGSize) {
        cacheSize = self.sizeThatFits(size)
        
        guard cacheSize != nil else {
            return
        }
        
        UIGraphicsBeginImageContextWithOptions(cacheSize!, false, 1)
        let ctx = UIGraphicsGetCurrentContext()
        guard ctx != nil else {
            return
        }
        
        ctx?.saveGState()
        
        attributeString?.draw(with: CGRect(origin: CGPoint.zero, size: cacheSize!), options: [.usesLineFragmentOrigin, .usesFontLeading, .truncatesLastVisibleLine], context: nil)
        
        ctx?.restoreGState()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        strImage = image;
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        if cacheSize != nil {
            return cacheSize!
        }
        
        guard attributeString != nil else {
            return CGSize.zero
        }
        
        return attributeString!.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).size
    }
}
