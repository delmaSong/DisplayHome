//
//  BaseView.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/23.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    func configure() {
        addSubviews()
        configureConstraints()
    }

    func addSubviews() {}

    func configureConstraints() {}
}
