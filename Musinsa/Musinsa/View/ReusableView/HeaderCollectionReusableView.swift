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
        view.titleLabel?.font = Resource.Font.body1
        view.setTitleColor(Resource.Color.gray100, for: .normal)
        view.isHidden = true
        return view
    }()
    
    override func configure() {
        super.configure()
        
//        allButton.rx.tap
//            .bind {
//                // TODO: - 전체 화면으로 이동처리
//            }
//            .disposed(by: <#T##DisposeBag#>)
    }
    
    override func addSubviews() {
        super.addSubviews()
        addSubviews([titleLabel, iconImageView, allButton])
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().offset(22)
        }
        iconImageView.snp.makeConstraints {
            $0.top.bottom.equalTo(titleLabel)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
            $0.height.equalTo(iconImageView.snp.width)
        }
        allButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(22)
            $0.top.bottom.equalTo(iconImageView)
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
