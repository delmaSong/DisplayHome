//
//  BannerCounterReusableView.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/27.
//

import UIKit
import Resource
import ReactorKit

final class CounterReusableView: BaseCollectionViewCell {
    private let disposeBag = DisposeBag()
    
    private let pagingBackgroundView: UIView = {
       let view = UIView()
        view.backgroundColor = Resource.Color.black.withAlphaComponent(0.5)
        return view
    }()
    
    private let pagingLabel: UILabel = {
       let view = UILabel()
        view.textColor = Resource.Color.white
        view.font = Resource.Font.subtitle1
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
            $0.center.equalTo(pagingBackgroundView)
        }
    }
    
    func configure(reactor: DisplayHomeViewReactor?) {
        reactor?.state.subscribe(onNext: { [weak self] state in
            self?.pagingLabel.text = "\(state.currentBannerPage) / \(state.bannersCount)"
        })
        .disposed(by: disposeBag)
    }
}
