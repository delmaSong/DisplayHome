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

struct DisplaySection: Decodable, Equatable {
    let header: Header?
    let contents: Contents?
    let footer: Footer?
    
    static func == (lhs: DisplaySection, rhs: DisplaySection) -> Bool {
        return lhs.header == rhs.header &&
        lhs.contents == rhs.contents &&
        lhs.footer == rhs.footer
    }
}
