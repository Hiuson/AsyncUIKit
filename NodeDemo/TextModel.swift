//
//  TextModel.swift
//  NodeDemo
//
//  Created by HiusonZ on 2019/11/30.
//  Copyright © 2019 Amino. All rights reserved.
//

import UIKit

class TextModel: NSObject {
    private var calculateSize: CGSize?
    
    var size: CGSize {
        get {
            guard calculateSize != nil else {
                return CGSize.zero
            }
            
            return calculateSize!
        }
    }
    
    var constraintSize: CGSize?
    
    var attributeString: NSAttributedString?
    var attributeStringImage: UIImage?
    
    func prepareForRender() {
        let size = sizeThatFits(constraintSize ?? CGSize())
        calculateSize = size
        attributeStringImage = drawStringImage(size)
    }
    
    private func sizeThatFits(_ size: CGSize) -> CGSize {
        guard attributeString != nil else {
            return CGSize.zero
        }
        
        return attributeString!.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil).size
    }
    
    private func drawStringImage(_ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        let ctx = UIGraphicsGetCurrentContext()
        guard ctx != nil else {
            return nil
        }
        
        ctx!.saveGState()
        
        attributeString?.draw(with: CGRect(origin: CGPoint.zero, size: size), options: [.usesLineFragmentOrigin, .usesFontLeading, .truncatesLastVisibleLine], context: nil)
        
        ctx!.restoreGState()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

extension UILabel {
    func updateWithModel(_ model: TextModel) {
        frame = CGRect(origin: frame.origin, size: model.size)
        attributedText = model.attributeString
    }
}

extension UIImageView {
    func updateWithModel(_ model: TextModel) {
        frame = CGRect(origin: frame.origin, size: model.size)
        image = model.attributeStringImage
    }
}
