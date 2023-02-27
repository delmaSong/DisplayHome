//
//  Banner.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/22.
//

import Foundation

struct Banner: Content, Equatable {
    let linkURL: URL
    let thumbnailURL: URL
    let title: String
    let description: String
    let keyword: String
}
