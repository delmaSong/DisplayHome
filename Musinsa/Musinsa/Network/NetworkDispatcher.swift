//
//  NetworkDispatcher.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol NetworkDispatcher {
    func fetch<T: Decodable>(
        request: URLRequest,
        dataType: T.Type
    ) -> Observable<Result<T, NetworkError>>
}

extension NetworkDispatcher {
    func fetch<T: Decodable>(
        request: URLRequest,
        dataType: T.Type
    ) -> Observable<Result<T, NetworkError>> {
        return Observable.just(request)
            .flatMap { req in
                URLSession.shared.rx.data(request: req)
            }.map { data -> Result<T, NetworkError> in
                do {
                    let decodedData = try JSONDecoder()
                        .decode(T.self, from: data)
                    return .success(decodedData)
                } catch {
                    return .failure(.decodeError)
                }
            }
    }
}
