//
//  BannerCollectionView.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/23.
//

import UIKit
import SnapKit

final class BannerCollectionView: BaseCollectionViewCell {
    private var banners: [Banner]?
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isPagingEnabled = true
        view.delegate = self
        view.bounces = false
        return view
    }()
    
    override func addSubviews() {
        super.addSubviews()
        addSubview(scrollView)
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(banners: [Banner]) {
        self.banners = banners
        scrollView.contentSize.width = scrollView.frame.width * CGFloat(banners.count)
        
        for (i, banner) in banners.enumerated() {
            let view = BannerParallaxView()
            view.frame = CGRect(
                x: scrollView.frame.width * CGFloat(i),
                y: 0,
                width: scrollView.frame.width,
                height: scrollView.frame.height
            )
            view.configure(banner: banner)
            view.tag = i + 10
            scrollView.addSubview(view)
        }
    }
}

// MARK: - UIScrollViewDelegate

extension BannerCollectionView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let tempo = 200 / scrollView.frame.width
        guard let banners = self.banners else { return }
        for i in 0 ..< banners.count {
            let parallaxView = scrollView.viewWithTag(i + 10) as! BannerParallaxView
            let newX: CGFloat = tempo * (scrollView.contentOffset.x - CGFloat(i) * scrollView.frame.width)
            parallaxView.imageView.frame = CGRect(
                x: newX,
                y: parallaxView.imageView.frame.origin.y,
                width: parallaxView.imageView.frame.width,
                height: parallaxView.imageView.frame.height
            )
        }
    }
}
