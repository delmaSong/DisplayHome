//
//  Goods.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/22.
//

import Foundation

struct Goods: Content {
    let linkURL: URL
    let thumbnailURL: URL
    let brandName: String
    let price: Int
    let saleRate: Int
    let hasCoupon: Bool
}
