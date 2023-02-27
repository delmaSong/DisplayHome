//
//  Array+Extension.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/27.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
