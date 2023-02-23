//
//  Int+Extension.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/23.
//

import Foundation

extension Int {
    /// 세자리마다 comma를 삽입
    /// - Returns: 세자리마다 commar가 삽입된 옵셔널 문자열
    func insertComma() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self))!
    }
}
