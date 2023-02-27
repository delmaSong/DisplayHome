//
//  HomeViewReactor.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/25.
//

import ReactorKit

final class HomeViewReactor: Reactor {
    enum Action {
        case refresh
        case turnPage(Int)
    }
    
    enum Mutation {
        case replace([DisplaySection])
        case turnPage(Int)
    }
    
    struct State {
        var sections: [DisplaySection] = []
        var currentBannerPage: Int = 1
        var bannersCount: Int = 0
    }
    
    var initialState: State
    var useCase = DisplayServiceUseCase()
    
    init() {
        self.initialState = State()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return useCase.fetchList()
                .compactMap { .replace($0.data) }
        case .turnPage(let currentPage):
            return .just(.turnPage(currentPage))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .replace(let sections):
            newState.sections = sections
            newState.bannersCount = sections.first { $0.contents?.type == .banner }?.contents?.items.count ?? 0

        case .turnPage(let currentPage):
            newState.currentBannerPage = currentPage
        }
        
        return newState
    }
}
