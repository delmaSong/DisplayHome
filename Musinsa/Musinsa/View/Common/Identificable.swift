//
//  Identificable.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/22.
//

import UIKit

/// identifier를 프로퍼티로 가짐
protocol Identificable: AnyObject {
    static var identifier: String { get }
}

extension Identificable where Self: BaseCollectionViewCell {
    static var identifier: String {
        String(describing: self)
    }
}

extension Identificable where Self: BaseCollectionReusableView {
    static var identifier: String {
        String(describing: self)
    }
}
