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
    
    /// 뷰에 둥근 테두리를 추가한다
    /// - Parameters:
    ///   - corner: corner radius 값
    ///   - borderWidth: 보더 너비. 기본값 0
    ///   - borderColor: 보더 컬러. 기본색 clear
    func setRounded(
        corner: CGFloat,
        borderWidth: CGFloat = 0,
        borderColor: UIColor = .clear
    ) {
        layer.masksToBounds = true
        layer.cornerRadius = corner
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
    }
}
