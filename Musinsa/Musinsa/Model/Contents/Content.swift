//
//  Content.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/22.
//

import Foundation

struct Content: Decodable {
    enum `Type`: String, Decodable {
        case banner = "BANNER"
        case grid = "GRID"
        case scroll = "SCROLL"
        case style = "STYLE"
    }
    
    let type: `Type`
    let banners: [Banner]?
    let goods: [Goods]?
    let styles: [Style]?
}
