//
//  CaptureUIView.swift
//  GoodbyeMoney
//
//  Created by Yifei.Chen on 12/12/23.
//

import Foundation
import SwiftUI
import UIKit

struct CaptureUIView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }

    static func capture(view: UIView, rect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(rect.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.translateBy(x: -rect.origin.x, y: -rect.origin.y)
        view.layer.render(in: context)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        return img
    }
}
