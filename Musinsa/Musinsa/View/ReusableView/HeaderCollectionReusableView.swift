//
//  HeaderCollectionReusableView.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/22.
//

import UIKit
import SnapKit
import Resource
import Kingfisher
import RxCocoa

final class HeaderCollectionReusableView: BaseCollectionReusableView {
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = Resource.Font.header2
        view.textColor = Resource.Color.black
        view.numberOfLines = 1
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let view = UIImageView()
        view.isHidden = true
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let allButton: UIButton = {
        let view = UIButton()
        view.titleLabel?.font = Resource.Font.title3
        view.setTitleColor(Resource.Color.gray400, for: .normal)
        view.setTitle(.common(.all), for: .normal)
        view.isHidden = true
        return view
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = Resource.Color.gray100
        return view
    }()
    
    override func addSubviews() {
        super.addSubviews()
        addSubviews([titleLabel, iconImageView, allButton, divider])
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.greaterThanOrEqualTo(iconImageView.snp.leading).offset(-8)
            $0.trailing.lessThanOrEqualTo(iconImageView.snp.leading).offset(-2)
        }
        iconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(16)
            $0.height.equalTo(iconImageView.snp.width)
        }
        allButton.snp.makeConstraints {
            $0.leading.greaterThanOrEqualTo(iconImageView.snp.trailing).offset(2)
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }
        divider.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func configure(header: Header) {
        titleLabel.text = header.title
        if let iconURL = header.iconURL {
            iconImageView.isHidden = false
            iconImageView.kf.setImage(with: iconURL)
        }
        
        allButton.isHidden = header.linkURL == nil
    }
}
