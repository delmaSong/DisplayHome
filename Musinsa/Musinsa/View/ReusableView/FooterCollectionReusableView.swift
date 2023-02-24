//
//  FooterCollectionReusableView.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/22.
//

import UIKit
import Resource
import SnapKit
import Kingfisher

final class FooterCollectionReusableView: BaseCollectionReusableView {
    private let button: UIButton = {
        let view = UIButton()
        view.setRounded(
            corner: 16,
            borderWidth: 1,
            borderColor: Resource.Color.gray100
        )
        view.titleLabel?.font = Resource.Font.title1
        view.setTitleColor(Resource.Color.black, for: .normal)
        view.backgroundColor = Resource.Color.white
        view.titleEdgeInsets = .init(
            top: .zero,
            left: 8,
            bottom: .zero,
            right: .zero
        )
        return view
    }()

    override func addSubviews() {
        super.addSubviews()
        
        addSubview(button)
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        button.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(18)
        }
    }
    
    func configure(footer: Footer) {
        let title: String = footer.type == .refresh ? .common(.newRecommend) : .common(.more)
        button.setTitle(title, for: .normal)
        if let iconURL = footer.iconURL {
            button.kf.setImage(with: iconURL, for: .normal)
        }
    }
}
