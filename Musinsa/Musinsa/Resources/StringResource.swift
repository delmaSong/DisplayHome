//
//  StringResource.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/22.
//

import Foundation

protocol StringCreatable {
    func text() -> String
}

extension String {
    static func common(_ common: Common) -> String {
        common.text()
    }
    
    enum Common: String, StringCreatable {
        /// 전체
        case all = "전체"
        /// 쿠폰
        case coupon = "쿠폰"
        /// 새로운 추천
        case newRecommend = "새로운 추천"
        /// 더보기
        case more = "더보기"
        /// 원
        case won = "원"
        /// %
        case percent = "%"
        
        func text() -> String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
}
