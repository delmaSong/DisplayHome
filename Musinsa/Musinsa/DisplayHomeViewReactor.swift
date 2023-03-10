//
//  DisplayHomeViewReactor.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/25.
//

import ReactorKit

final class DisplayHomeViewReactor: Reactor {
    enum Action {
        case load
        case turnPageAutoScroll
        case turnPage(Int)
        case loadMore(Contents.`Type`)
        case newRecommend(Contents.`Type`)
    }
    
    enum Mutation {
        case replace([DisplaySection])
        case turnPageAutoScroll
        case turnPage(Int)
        case append(Contents.`Type`)
        case shuffle(Contents.`Type`)
    }
    
    struct State {
        var sections: [DisplaySection] = []
        var banners: [Banner] = []
        var scrollGoods: [Goods] = []
        var gridGoods: [Goods] = []
        var styles: [Style] = []
        
        var currentBannerPage: Int = 1
        var bannersCount: Int = 0

        var originGridGoods: [Goods] = []
        var originStyles: [Style] = []
    }
    
    var initialState: State
    var dispatcher = DisplayServiceDispatcher()
    
    private let defaultDisplayCount = 6
    private let gridAppendCount = 3
    private let styleAppendCount = 6
    
    init() {
        self.initialState = State()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            return dispatcher.fetchList()
                .compactMap { .replace($0.data) }
            
        case .turnPageAutoScroll:
            return .just(.turnPageAutoScroll)
            
        case .turnPage(let currentPage):
            return .just(.turnPage(currentPage))
            
        case .loadMore(let type):
            return .just(.append(type))
            
        case .newRecommend(let type):
            return .just(.shuffle(type))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .replace(let sections):
            sections.forEach { section in
                guard let type = section.contents?.type else { return }
                switch type {
                case .banner:
                    guard let banners = section.contents?.items as? [Banner] else { return }
                    newState.banners = banners
                    newState.bannersCount = banners.count
                    
                case .scroll:
                    guard let goods = section.contents?.items as? [Goods] else { return }
                    newState.scrollGoods = goods
                    
                case .grid:
                    guard let goods = section.contents?.items as? [Goods] else { return }
                    let appendedCount = state.gridGoods.count + gridAppendCount
                    let maxCount = appendedCount < defaultDisplayCount ? defaultDisplayCount : appendedCount
                    let displayedCount = min(maxCount, goods.count)
                    newState.originGridGoods = goods
                    newState.gridGoods = Array(goods[0..<displayedCount])
                    
                case .style:
                    guard let styles = section.contents?.items as? [Style] else { return }
                    let appendedCount = state.styles.count + styleAppendCount
                    let maxCount = appendedCount < defaultDisplayCount ? defaultDisplayCount : appendedCount
                    let displayedCount = min(maxCount, styles.count)
                    newState.originStyles = styles
                    newState.styles = Array(styles[0..<displayedCount])
                }
            }
            
            newState.sections = sections
            
        case .turnPageAutoScroll:
            if newState.currentBannerPage < newState.bannersCount {
                newState.currentBannerPage += 1
            } else {
                newState.currentBannerPage = 1
            }
            
        case .turnPage(let currentPage):
            newState.currentBannerPage = currentPage
        
        case .append(let type):
            switch type {
            case .grid:
                let displayedCount = min(
                    state.gridGoods.count + gridAppendCount,
                    state.originGridGoods.count
                )
                newState.gridGoods = Array(state.originGridGoods[0..<displayedCount])

            case .style:
                let displayedCount = min(
                    state.styles.count + styleAppendCount,
                    state.originStyles.count
                )
                newState.styles = Array(state.originStyles[0..<displayedCount])
                
            default: break
            }
            
        case .shuffle(let type):
            switch type {
            case .scroll:
                newState.scrollGoods.shuffle()
                
            default: break
            }
        }
        
        return newState
    }
}
