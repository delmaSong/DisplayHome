//
//  Identificable.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/22.
//

import Foundation

/// identifier를 프로퍼티로 가짐
protocol Identificable {
    static var identifier: String {
        String(describing: self)
    }
}
