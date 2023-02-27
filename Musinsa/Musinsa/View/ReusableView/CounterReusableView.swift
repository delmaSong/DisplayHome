//
//  BannerCounterReusableView.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/27.
//

import UIKit
import Resource

final class CounterReusableView: BaseCollectionViewCell {
    private let pagingBackgroundView: UIView = {
       let view = UIView()
        view.backgroundColor = Resource.Color.black.withAlphaComponent(0.5)
        return view
    }()
    
    private let pagingLabel: UILabel = {
       let view = UILabel()
        view.textColor = Resource.Color.white
        view.font = Resource.Font.subtitle1
        view.text = "1 / 10"
        return view
    }()
    
    override func addSubviews() {
        super.addSubviews()

        contentView.addSubviews([
            pagingBackgroundView,
            pagingLabel
        ])
    }

    override func configureConstraints() {
        super.configureConstraints()

        pagingBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        pagingLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(pagingBackgroundView).inset(12)
            $0.top.equalTo(pagingBackgroundView).inset(6)
        }
    }
}
