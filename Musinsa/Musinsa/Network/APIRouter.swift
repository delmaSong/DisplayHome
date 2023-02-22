//
//  APIRouter.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/22.
//

import Foundation
import Alamofire

protocol APIRouter: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
}

extension APIRouter {
    var baseURL: String {
        return Bundle.main.infoDictionary!["BaseURL"] as! String
    }
    
    func getBaseRequest() throws -> URLRequest {
        let base = try baseURL.asURL()

        var urlRequest = URLRequest(url: base.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue

        return urlRequest
    }
}
