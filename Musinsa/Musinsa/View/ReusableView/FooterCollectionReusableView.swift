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
import ReactorKit

final class FooterCollectionReusableView: BaseCollectionReusableView {
    private var disposeBag = DisposeBag()
    
    private let button: UIButton = {
        let view = UIButton()
        view.setRounded(
            corner: 16,
            borderWidth: 1,
            borderColor: Resource.Color.gray100
        )
        view.titleLabel?.font = Resource.Font.title3
        view.setTitleColor(Resource.Color.black, for: .normal)
        view.backgroundColor = Resource.Color.white
        view.imageView?.contentMode = .scaleAspectFit
        view.imageEdgeInsets = UIEdgeInsets(
            top: 12,
            left: 0,
            bottom: 12,
            right: 0
        )
        return view
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubview(button)
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        button.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(48)
        }
    }
    
    func configure(reactor: DisplayHomeViewReactor?, section: DisplaySection?) {
        guard let footer = section?.footer,
              let contentsType = section?.contents?.type
        else { return }
        
        let title: String = footer.type == .refresh ? .common(.newRecommend) : .common(.more)
        button.setTitle(title, for: .normal)
        if let iconURL = footer.iconURL {
            button.kf.setImage(with: iconURL, for: .normal)
            button.titleEdgeInsets = .init(
                top: .zero,
                left: -36,
                bottom: .zero,
                right: .zero
            )
        }
        
        button.rx.tap
            .asDriver()
            .drive { _ in
                if footer.type == .more {
                    reactor?.action.onNext(.loadMore(contentsType))
                } else if footer.type == .refresh {
                    reactor?.action.onNext(.newRecommend(contentsType))
                }
            }
            .disposed(by: disposeBag)
    }
}
