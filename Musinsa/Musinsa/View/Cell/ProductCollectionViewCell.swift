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
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private let couponButton: UIButton = {
        let view = UIButton()
        view.setTitle(.common(.coupon), for: .normal)
        view.setTitleColor(Resource.Color.white, for: .normal)
        view.titleLabel?.font = Resource.Font.body1
        view.backgroundColor = Resource.Color.blue100
        view.titleEdgeInsets = .init(top: 4, left: 9, bottom: 4, right: 9)
        view.isHidden = true
        return view
    }()
    
    private let brandLabel: UILabel = {
        let view = UILabel()
        view.font = Resource.Font.subtitle1
        view.textColor = Resource.Color.gray400
        return view
    }()
    
    private let priceLabel: UILabel = {
        let view = UILabel()
        view.font = Resource.Font.title3
        view.textColor = Resource.Color.black
        return view
    }()
    
    private let saleRateLabel: UILabel = {
        let view = UILabel()
        view.font = Resource.Font.title3
        view.textColor = Resource.Color.red100
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnavilImageView.image = nil
        couponButton.isHidden = true
        brandLabel.text = nil
        priceLabel.text = nil
        saleRateLabel.text = nil
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        contentView.addSubviews([
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
            $0.bottom.equalTo(brandLabel.snp.top).offset(-8)
            $0.width.lessThanOrEqualTo(UIScreen.main.bounds.width / 3)
            $0.height.lessThanOrEqualTo(150)
        }
        couponButton.snp.makeConstraints {
            $0.leading.bottom.equalTo(thumbnavilImageView)
            $0.width.equalTo(36)
        }
        brandLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(priceLabel.snp.top).offset(-4)
        }
        priceLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
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
        let discountedPrice = Double(goods.saleRate) / Double(100) * Double(goods.price)
        priceLabel.text = Int(discountedPrice).insertComma() + .common(.won)
        saleRateLabel.text = "\(goods.saleRate)" + .common(.percent)
    }
}
