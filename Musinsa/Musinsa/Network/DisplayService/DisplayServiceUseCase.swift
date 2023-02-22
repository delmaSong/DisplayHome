//
//  DisplayServiceUseCase.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/22.
//

import Foundation
import RxSwift

final class DisplayServiceUseCase {
    
    typealias router = DisplayServiceRouter
    
    func fetchList() -> Single<WrappedDisplaySection?> {
        let request = router.list.asURLRequest()!

        return NetworkDispatcher.shared.fetch(
            request: request,
            dataType: WrappedDisplaySection.self
        )
        .asSingle()
        .map { result -> WrappedDisplaySection? in
            switch result {
            case .success(let section):
                return section
            case .failure:
                return nil
            }
        }
    }
}
