//
//  StyleCollectionViewCell.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/23.
//

import UIKit
import SnapKit
import Kingfisher

final class StyleCollectionViewCell: BaseCollectionViewCell {
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        addSubview(imageView)
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configure(style: Style) {
        imageView.kf.setImage(with: style.thumbnailURL)
    }
}
