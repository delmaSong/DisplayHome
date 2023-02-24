//
//  APIRouter.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/22.
//

import Foundation

enum HTTPMethod: String {
    case get, post, put, patch, delete
}

protocol APIRouter {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    
    func asURLRequest() -> URLRequest?
}

extension APIRouter {
    var baseURL: String {
        return Bundle.main.infoDictionary!["BaseURL"] as! String
    }
    
    func asURLRequest() -> URLRequest? {
        guard let url = URL(string: baseURL + path) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue
        return request
    }
}
