//
//  ViewController.swift
//  NodeDemo
//
//  Created by Amino on 2019/11/29.
//  Copyright © 2019 Amino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var dataArr = [TextNode]()
    
    lazy var scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.frame = self.view.bounds
        self.view.addSubview(scrollView)
        
        view.backgroundColor = UIColor.orange
        
        NSLog("1")
        let viewSize = view.bounds.size
        DispatchQueue.global().async {
            NSLog("2")
            for _ in 1...5000 {
                self.dataArr.append(TextNode())
            }
            
            for textNode in self.dataArr {
                textNode.attributeString = self.randomStr()
                textNode.calculateSize(viewSize)
            }
            
            NSLog("3")
            DispatchQueue.main.async {
                NSLog("4")
                var height: CGFloat = 0
                for textNode in self.dataArr {
                    textNode.view.frame = CGRect(origin: CGPoint(x: 0, y: height), size: textNode.cacheSize!)
                    height += textNode.cacheSize!.height + 2.0
                    self.scrollView.addSubnode(textNode)
                }
                self.scrollView.contentSize = CGSize(width: viewSize.width, height: height)
                NSLog("5")
                
                self.view.backgroundColor = UIColor.white
            }
        }
    }
    
    func randomStr() -> NSAttributedString {
        let font = UIFont.systemFont(ofSize: CGFloat(6 + arc4random()%30))
        let textColor = UIColor(displayP3Red: CGFloat(arc4random()%255) / 255.0,
                                green: CGFloat(arc4random()%255) / 255.0,
                                blue: CGFloat(arc4random()%255) / 255.0,
                                alpha: 1.0)
        
        let attribute: [NSAttributedString.Key:Any] = [.font: font, .foregroundColor: textColor]
        
        return NSAttributedString(string: "今天天气好askjdhfaskjhsadf🐎🐎🐎🐎🐎", attributes: attribute)
    }
}
