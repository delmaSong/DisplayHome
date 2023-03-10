//
//  Contents.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/22.
//

import Foundation

protocol Content: Decodable {
    var linkURL: URL { get }
    var thumbnailURL: URL { get }
    
    func isEqual(to: Content) -> Bool
}

extension Content {
    func isEqual(to: Content) -> Bool {
        return self.linkURL == to.linkURL && self.thumbnailURL == to.thumbnailURL
    }
}

struct Contents: Decodable, Equatable {
    enum `Type`: String, Decodable {
        case banner = "BANNER"
        case grid = "GRID"
        case scroll = "SCROLL"
        case style = "STYLE"
    }
    
    enum CodingKeys: String, CodingKey {
        case type, items
        case banners
        case goods
        case styles
    }
    
    let type: `Type`
    let items: [Content]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(`Type`.self, forKey: .type)
        
        switch type {
        case .banner:
            items = try container.decode([Banner].self, forKey: .banners)
        case .style:
            items = try container.decode([Style].self, forKey: .styles)
        default:
            items = try container.decode([Goods].self, forKey: .goods)
        }
    }
    
    static func == (lhs: Contents, rhs: Contents) -> Bool {
        return lhs.type == rhs.type && isEqual(lhs: lhs, rhs: rhs)
    }
    
    static func isEqual(lhs: Contents, rhs: Contents) -> Bool {
        if lhs.type != rhs.type { return false }
        
        for i in 0..<lhs.items.count {
            if !lhs.items[i].isEqual(to: rhs.items[i]) {
                return false
            }
        }
        return true
    }
}
