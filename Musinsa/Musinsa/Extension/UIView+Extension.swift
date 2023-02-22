//
//  UIView+Extension.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/22.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}
