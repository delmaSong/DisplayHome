//
//  Footer.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/22.
//

import Foundation

struct Footer: Decodable {
    enum `Type`: String, Decodable {
        case refresh = "REFRESH"
        case more = "MORE"
    }
    
    let title: String
    let iconURL: URL?
    let type: `Type`
}
