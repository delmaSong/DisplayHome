//
//  DisplaySection.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/22.
//

import Foundation

struct WrappedDisplaySection: Decodable {
    let data: [DisplaySection]
}

struct DisplaySection: Decodable {
    let header: Header?
    let contents: [Content]?
    let footer: Footer?
}
