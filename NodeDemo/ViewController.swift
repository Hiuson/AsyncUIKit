//
//  ViewController.swift
//  NodeDemo
//
//  Created by Amino on 2019/11/29.
//  Copyright © 2019 Amino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var dataArr = [TextModel]()
    
    lazy var scrollView = UIScrollView()
    lazy var tableView = UITableView(frame: self.view.bounds, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.frame = self.view.bounds
        
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)

        NSLog("1")
        let viewSize = view.bounds.size
        DispatchQueue.global().async {
            NSLog("2")
            for _ in 1...5000 {
                self.dataArr.append(TextModel())
            }

            for textModel in self.dataArr {
                textModel.attributeString = self.randomStr()
                textModel.prepareForRender(CGSize(width: viewSize.width, height: CGFloat.greatestFiniteMagnitude))
            }

            NSLog("3")
            DispatchQueue.main.async {
                NSLog("4")
                self.tableView.reloadData()
            }
        }
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        scrollView.frame = self.view.bounds
//        self.view.addSubview(scrollView)
//
//        view.backgroundColor = UIColor.orange
//
//        NSLog("1")
//        let viewSize = view.bounds.size
//        DispatchQueue.global().async {
//            NSLog("2")
//            for _ in 1...5000 {
//                self.dataArr.append(TextNode())
//            }
//
//            for textNode in self.dataArr {
//                textNode.attributeString = self.randomStr()
//                textNode.calculateSize(viewSize)
//            }
//
//            NSLog("3")
//            DispatchQueue.main.async {
//                NSLog("4")
//                var height: CGFloat = 0
//                for textNode in self.dataArr {
//                    textNode.view.frame = CGRect(origin: CGPoint(x: 0, y: height), size: textNode.cacheSize!)
//                    height += textNode.cacheSize!.height + 2.0
//                    self.scrollView.addSubnode(textNode)
//                }
//                self.scrollView.contentSize = CGSize(width: viewSize.width, height: height)
//                NSLog("5")
//
//                self.view.backgroundColor = UIColor.white
//            }
//        }
//    }
    
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

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dataArr[indexPath.row].calculatedSize.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
            let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize.zero))
            imageView.tag = 10086
            cell?.addSubview(imageView)
        }
        
        let expectSize = CGSize(width: self.view.bounds.size.width, height: CGFloat.greatestFiniteMagnitude)
        cell!.imageView?.updateWithModel(dataArr[indexPath.row], expectSize)
        
        return cell!
    }
}

extension UITableViewCell {
    var imageView: UIImageView? {
        get {
            for view in subviews {
                if view.tag == 10086 {
                    return view as? UIImageView
                }
            }
            return nil
        }
    }
}
