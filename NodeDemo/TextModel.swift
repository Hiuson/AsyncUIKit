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
    
    var attributeString: NSAttributedString?
    var attributeStringImage: UIImage?
    
    func prepareForRender(_ constraintSize: CGSize) {
        guard attributeString != nil else {
            return
        }
        
        self.constraintSize = constraintSize
        pCalculatedSize = TextDrawer.shared.sizeForAttributedString(attributeString!, constraintSize)
        attributeStringImage = TextDrawer.shared.drawnImageForAttributedString(attributeString!, pCalculatedSize!)
    }
    
    private(set) var constraintSize: CGSize?
    private var pCalculatedSize: CGSize?
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
