//
//  Header.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/22.
//

import Foundation

struct Header: Decodable {
    let title: String
    let iconURL: String?
    let linkURL: String?
}
