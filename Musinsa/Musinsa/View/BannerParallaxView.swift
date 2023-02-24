//
//  BannerParallaxView.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/23.
//

import UIKit
import SnapKit
import Resource
import Kingfisher

final class BannerParallaxView: BaseView {
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = Resource.Color.white
        view.font = Resource.Font.header2
        return view
    }()
    
    private let subtitleLabel: UILabel = {
        let view = UILabel()
        view.textColor = Resource.Color.white
        view.font = Resource.Font.title2
        return view
    }()
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubviews([
            imageView,
            titleLabel,
            subtitleLabel
        ])
    }

    override func configureConstraints() {
        super.configureConstraints()
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(subtitleLabel).inset(22)
        }
        subtitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(42)
        }
    }
    
    func configure(banner: Banner) {
        imageView.kf.setImage(with: banner.thumbnailURL)
        titleLabel.text = banner.title
        subtitleLabel.text = banner.description
    }
}
