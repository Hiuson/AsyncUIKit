//
//  TextModel.swift
//  NodeDemo
//
//  Created by HiusonZ on 2019/11/30.
//  Copyright © 2019 Amino. All rights reserved.
//

import UIKit

class TextModel: NSObject {
    var calculatedSize: CGSize {
        get { return pCalculatedSize == nil ? CGSize.zero : pCalculatedSize! }
    }
    
    private(set) var constraintSize: CGSize?
    
    var attributeString: NSAttributedString?
    var attributeStringImage: UIImage?
    
    func prepareForRender(_ constraintSize: CGSize) {
        self.constraintSize = constraintSize
        let size = sizeThatFits(constraintSize)
        pCalculatedSize = size
        attributeStringImage = drawStringImage(size)
    }
    
    
    private var pCalculatedSize: CGSize?
    
    private func sizeThatFits(_ size: CGSize) -> CGSize {
        guard attributeString != nil else {
            return CGSize.zero
        }
        
        return TextDrawer.shared.sizeForAttributedString(attributeString!, size)
    }
    
    private func drawStringImage(_ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
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
    func updateWithModel(_ model: TextModel, _ fittingSize: CGSize) {
        guard model.constraintSize != nil else {
            assert(true, "Unreachable")
            return
        }
        assert(fittingSize.equalTo(model.constraintSize!))
        
        frame = CGRect(origin: frame.origin, size: model.calculatedSize)
        attributedText = model.attributeString
    }
}

extension UIImageView {
    func updateWithModel(_ model: TextModel, _ fittingSize: CGSize) {
        guard model.constraintSize != nil else {
            assert(true, "Unreachable")
            return
        }
        assert(fittingSize.equalTo(model.constraintSize!))
        
        frame = CGRect(origin: frame.origin, size: model.calculatedSize)
        image = model.attributeStringImage
    }
}
