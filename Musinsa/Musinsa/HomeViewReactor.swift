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
    }
    
    enum Mutation {
        case replace([DisplaySection])
    }
    
    struct State {
        var sections: [DisplaySection] = []
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
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .replace(let sections):
            newState.sections = sections
        }
        
        return newState
    }
}
