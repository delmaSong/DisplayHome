//
//  DisplayServiceRouter.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/22.
//

import Foundation

import Alamofire

enum DisplayServiceRouter: APIRouter {
    case list
    
    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .list:
            return "/interview/list.json"
        }
    }
}
