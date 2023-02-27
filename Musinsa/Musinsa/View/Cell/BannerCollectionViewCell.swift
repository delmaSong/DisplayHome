//
//  BannerCollectionViewCell.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/23.
//

import UIKit
import Resource

final class BannerCollectionViewCell: BaseCollectionViewCell {
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = Resource.Color.white
        view.font = Resource.Font.header1
        view.textAlignment = .center
        view.numberOfLines = 1
        return view
    }()
    
    private let subtitleLabel: UILabel = {
        let view = UILabel()
        view.textColor = Resource.Color.white
        view.font = Resource.Font.title3
        view.numberOfLines = 1
        view.textAlignment = .center
        return view
    }()
    
    override func addSubviews() {
        super.addSubviews()

        contentView.addSubviews([
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
            $0.centerX.equalToSuperview().priority(.high)
            $0.bottom.equalTo(subtitleLabel).inset(22)
            $0.leading.greaterThanOrEqualToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }
        subtitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview().priority(.high)
            $0.bottom.equalToSuperview().inset(42)
            $0.leading.greaterThanOrEqualToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }
    }
    
    func configure(banner: Banner) {
        imageView.kf.setImage(with: banner.thumbnailURL)
        titleLabel.text = banner.title
        subtitleLabel.text = banner.description
    }
    
    func parallaxOffsetX(from contentOffset: CGPoint) {
        let factor = 0.5
        let newX = (contentOffset.x - self.frame.origin.x) * factor
        let frame = imageView.bounds
        let offsetFame = CGRectOffset(frame, CGFloat(newX), 0)
        imageView.frame = offsetFame
    }
}
