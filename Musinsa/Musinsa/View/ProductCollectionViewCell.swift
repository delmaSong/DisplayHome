//
//  ProductCollectionViewCell.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/22.
//

import UIKit
import Resource
import SnapKit
import Kingfisher

final class ProductCollectionViewCell: BaseCollectionViewCell {
    private let thumbnavilImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let couponButton: UIButton = {
        let view = UIButton()
        view.setTitle(.common(.coupon), for: .normal)
        view.setTitleColor(Resource.color.white, for: .normal)
        view.titleLabel?.font = Resource.font.body1
        view.backgroundColor = Resource.color.blue100
        view.titleEdgeInsets = .init(top: 4, left: 9, bottom: 4, right: 9)
        view.isHidden = true
        return view
    }()
    
    private let brandLabel: UILabel = {
        let view = UILabel()
        view.font = Resource.font.subtitle1
        view.textColor = Resource.color.gray400
        return view
    }()
    
    private let priceLabel: UILabel = {
        let view = UILabel()
        view.font = Resource.font.title3
        view.textColor = Resource.color.black
        return view
    }()
    
    private let saleRateLabel: UILabel = {
        let view = UILabel()
        view.font = Resource.font.title3
        view.textColor = Resource.color.red100
        return view
    }()
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubviews([
            thumbnavilImageView,
            couponButton,
            brandLabel,
            priceLabel,
            saleRateLabel,
        ])
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        thumbnavilImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(brandLabel.snp.top).offset(16)
        }
        couponButton.snp.makeConstraints {
            $0.leading.bottom.equalTo(thumbnavilImageView)
        }
        brandLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(priceLabel.snp.top).offset(8)
        }
        priceLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.trailing.equalTo(saleRateLabel.snp.leading)
        }
        saleRateLabel.snp.makeConstraints {
            $0.bottom.equalTo(priceLabel)
            $0.trailing.equalToSuperview()
        }
    }
    
    func configure(goods: Goods) {
        thumbnavilImageView.kf.setImage(with: goods.thumbnailURL)
        couponButton.isHidden = !goods.hasCoupon
        brandLabel.text = goods.brandName
        let discountedPrice = (100 - goods.saleRate) % 100 * goods.price
        priceLabel = discountedPrice.insertComma() + .common(.won)
        saleRateLabel.text = goods.saleRate + .common(.percent)
    }
}
