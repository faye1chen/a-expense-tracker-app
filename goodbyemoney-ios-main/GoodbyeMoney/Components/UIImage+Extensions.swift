//
//  UIImage+Extensions.swift
//  GoodbyeMoney
//
//  Created by Yifei.Chen on 12/12/23.
//

import Foundation
import UIKit

//extension UIImage {
//    func addingText(_ text: String) -> UIImage {
//        let renderer = UIGraphicsImageRenderer(size: size)
//        return renderer.image { context in
//            draw(at: CGPoint.zero)
//            let attributes: [NSAttributedString.Key: Any] = [
//                .font: UIFont.systemFont(ofSize: 20),
//                .foregroundColor: UIColor.white
//            ]
//            let textSize = text.size(withAttributes: attributes)
//            let textRect = CGRect(x: 20, y: size.height - textSize.height - 20, width: textSize.width, height: textSize.height)
//            text.draw(in: textRect, withAttributes: attributes)
//        }
//    }
//}
extension UIImage {
    func addingText(_ text: String) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            draw(at: CGPoint.zero)

            // 定义文字的属性
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 30), // 改变字体大小和风格
                .foregroundColor: UIColor.blue, // 改变字体颜色
                .paragraphStyle: paragraphStyle
            ]

            // 计算文字大小，以确保它能够适应图片
            let textSize = text.size(withAttributes: attributes)

            // 设置文字位置为图片的最上方，水平居中
            let textRect = CGRect(x: (size.width - textSize.width) / 2, y: 20, width: textSize.width, height: textSize.height)
            
            // 在图片上绘制文字
            text.draw(in: textRect, withAttributes: attributes)
        }
    }
}
