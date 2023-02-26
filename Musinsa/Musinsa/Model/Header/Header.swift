//
//  Header.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/22.
//

import Foundation

struct Header: Decodable, Equatable {
    let title: String
    let iconURL: URL?
    let linkURL: URL?
}
