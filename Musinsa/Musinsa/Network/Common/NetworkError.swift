//
//  NetworkError.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/22.
//

import Foundation

enum NetworkError: Error, CustomStringConvertible {
    case unknown
    case decodeError

    var description: String {
        switch self {
        case .unknown:
            return "알 수 없는 에러가 발생했습니다."
        case .decodeError:
            return "데이터 형식이 올바르지 않습니다."
        }
    }
}
