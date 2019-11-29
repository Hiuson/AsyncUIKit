//
//  BaseNode.swift
//  NodeDemo
//
//  Created by Amino on 2019/11/29.
//  Copyright © 2019 Amino. All rights reserved.
//

import UIKit

class BaseNode: NSObject {
    lazy var view: UIView = {
        let view = viewClass().init(frame: .zero)
        return view
    }()
    
    func viewClass<T>() -> T.Type where T: UIView {
        return UIView.self as! T.Type
    }
    
    func sizeThatFits(_ size: CGSize) -> CGSize {
        CGSize.zero
    }
    
    func updateView() {}
}

extension UIView {
    func addSubnode(_ subnode: BaseNode) {
        addSubview(subnode.view)
        subnode.updateView()
    }
}
