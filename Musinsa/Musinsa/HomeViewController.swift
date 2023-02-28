//
//  HomeViewController.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/22.
//

import UIKit
import RxSwift
import SnapKit
import ReactorKit
import RxCocoa

enum HomeSection: CaseIterable {
    case banner
    case grid
    case scroll
    case style
}

struct HomeItem: Hashable {
    let id = UUID()
    let type: ItemType
    
    enum ItemType {
        case banner(Banner)
        case grid(Goods)
        case scroll(Goods)
        case style(Style)
    }
    
    static func == (lhs: HomeItem, rhs: HomeItem) -> Bool {
        lhs.id == rhs.id
    }
 
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

final class HomeViewController: BaseViewController, ReactorKit.View {
    typealias Reactor = HomeViewReactor
    typealias DataSource = UICollectionViewDiffableDataSource<HomeSection, HomeItem>
    
    private var dataSource: DataSource!
    var disposeBag = DisposeBag()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(
            frame: .zero,
            collectionViewLayout: self.generateCollectionViewLayout()
        )
        view.register(
            CounterReusableView.self,
            forSupplementaryViewOfKind: CounterReusableView.identifier,
            withReuseIdentifier: CounterReusableView.identifier
        )
        view.register(
            HeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: HeaderCollectionReusableView.identifier,
            withReuseIdentifier: HeaderCollectionReusableView.identifier
        )
        view.register(
            FooterCollectionReusableView.self,
            forSupplementaryViewOfKind: FooterCollectionReusableView.identifier,
            withReuseIdentifier: FooterCollectionReusableView.identifier
        )
        view.register(
            ProductCollectionViewCell.self,
            forCellWithReuseIdentifier: ProductCollectionViewCell.identifier
        )
        view.register(
            StyleCollectionViewCell.self,
            forCellWithReuseIdentifier: StyleCollectionViewCell.identifier
        )
        view.register(
            BannerCollectionViewCell.self,
            forCellWithReuseIdentifier: BannerCollectionViewCell.identifier
        )
        return view
    }()
    
    override func configure() {
        super.configure()
        
        configureCell()
        configureCollectionViewSupplementaryView()
        makeSnapshot()
        
        self.reactor = HomeViewReactor()
        reactor?.action.onNext(.refresh)
    }
    
    override func addSubviews() {
        super.addSubviews()

        view.addSubviews([collectionView])
    }

    override func configureConstraints() {
        super.configureConstraints()

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bind(reactor: HomeViewReactor) {
        var snapshot = self.dataSource.snapshot()
        
        reactor.state.map { $0.banners }
            .asDriver(onErrorJustReturn: [])
            .distinctUntilChanged()
            .drive { [weak self] banners in
                let bannerItems = banners.map { HomeItem(type: .banner($0)) }
                snapshot.appendItems(bannerItems, toSection: .banner)
                self?.dataSource.apply(snapshot)
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.scrollGoods }
            .asDriver(onErrorJustReturn: [])
            .distinctUntilChanged()
            .drive { [weak self] goods in
                let goodsItems = goods.map { HomeItem(type: .scroll($0)) }
                let items = snapshot.itemIdentifiers(inSection: .scroll)
                snapshot.deleteItems(items)
                snapshot.appendItems(goodsItems, toSection: .scroll)
                self?.dataSource.apply(snapshot)
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.gridGoods }
            .asDriver(onErrorJustReturn: [])
            .distinctUntilChanged()
            .drive { [weak self] goods in
                let goodsItems = goods.map { HomeItem(type: .grid($0)) }
                let items = snapshot.itemIdentifiers(inSection: .grid)
                snapshot.deleteItems(items)
                snapshot.appendItems(goodsItems, toSection: .grid)
                self?.dataSource.apply(snapshot)
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.styles }
            .asDriver(onErrorJustReturn: [])
            .distinctUntilChanged()
            .drive { [weak self] styles in
                let styleItems = styles.map { HomeItem(type: .style($0)) }
                let items = snapshot.itemIdentifiers(inSection: .style)
                snapshot.deleteItems(items)
                snapshot.appendItems(styleItems, toSection: .style)
                self?.dataSource.apply(snapshot)
            }.disposed(by: disposeBag)
    }
}

// MARK: - Layout

extension HomeViewController {
    private func generateCollectionViewLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 30
        
        return UICollectionViewCompositionalLayout(
            sectionProvider: { [unowned self] sectionIndex, _ in
                switch HomeSection.allCases[sectionIndex] {
                case .banner:
                    return self.bannerSectionLayout(at: sectionIndex)
                case .grid:
                    return self.gridSectionLayout(at: sectionIndex)
                case .scroll:
                    return self.scrollSectionLayout(at: sectionIndex)
                case .style:
                    return self.styleSectionLayout(at: sectionIndex)
                }
            },
            configuration: configuration
        )
    }
    
    private func bannerSectionLayout(at index: Int) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1.2)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(UIScreen.main.bounds.width)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let counterSize = NSCollectionLayoutSize(
            widthDimension: .absolute(60),
            heightDimension: .estimated(30)
        )
        let counterAnchor = NSCollectionLayoutAnchor(
            edges: [.bottom, .trailing],
            absoluteOffset: CGPoint(x: 0, y: 0)
        )
        let counterItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: counterSize,
            elementKind: CounterReusableView.identifier,
            containerAnchor: counterAnchor
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        section.boundarySupplementaryItems.append(counterItem)
        addSupplementaryItem(at: section, sectionIndex: index)
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, contentOffset, _ in
            guard let self,
                  let currentIndexPath = visibleItems.last?.indexPath,
                  let cell = self.collectionView.cellForItem(
                      at: currentIndexPath
                  ) as? BannerCollectionViewCell
            else { return }
            cell.parallaxOffsetX(from: contentOffset)
            self.reactor?.action.onNext(.turnPage(currentIndexPath.item + 1))
        }
        return section
    }
    
    private func gridSectionLayout(at index: Int) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.3),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 2, bottom: 8, trailing: 2)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(200)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 3
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 22, leading: 12, bottom: 22, trailing: 12)
        addSupplementaryItem(at: section, sectionIndex: index)
        return section
    }
    
    private func scrollSectionLayout(at index: Int) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.3),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 2, bottom: 8, trailing: 2)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(200)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 3
        )

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 22, leading: 12, bottom: 22, trailing: 12)
        section.orthogonalScrollingBehavior = .continuous
        addSupplementaryItem(at: section, sectionIndex: index)
        return section
    }

    private func styleSectionLayout(at index: Int) -> NSCollectionLayoutSection {
        let defaultInsets = NSDirectionalEdgeInsets(
            top: 2,
            leading: 2,
            bottom: 2,
            trailing: 2
          )
        
        let mainItem = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(2/3),
            heightDimension: .fractionalHeight(1.0))
        )
        mainItem.contentInsets = defaultInsets

        let pairItem = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.5))
        )
        pairItem.contentInsets = defaultInsets
        
        let trailingGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1.0)),
          subitem: pairItem,
          count: 2
        )

        let mainWithPairGroup = NSCollectionLayoutGroup.horizontal(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(2/3)),
          subitems: [mainItem, trailingGroup]
        )
        mainWithPairGroup.contentInsets = defaultInsets

        let tripletItem = NSCollectionLayoutItem(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1.0))
        )
        tripletItem.contentInsets = defaultInsets

        let tripletGroup = NSCollectionLayoutGroup.horizontal(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1/3)),
          subitems: [tripletItem, tripletItem, tripletItem]
        )
        tripletGroup.contentInsets = defaultInsets
        
        let nestedGroup = NSCollectionLayoutGroup.vertical(
          layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(600)),
          subitems: [
            mainWithPairGroup,
            tripletGroup,
          ]
        )

        let section = NSCollectionLayoutSection(group: nestedGroup)
        section.contentInsets = .init(top: 0, leading: 12, bottom: 0, trailing: 12)
        addSupplementaryItem(at: section, sectionIndex: index)
        return section
    }
    
    private func configureHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(60)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: HeaderCollectionReusableView.identifier,
            alignment: .top
        )
        return sectionHeader
    }
    
    private func configureFooter() -> NSCollectionLayoutBoundarySupplementaryItem {
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(60)
        )
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: FooterCollectionReusableView.identifier,
            alignment: .bottom
        )
        return sectionFooter
    }
    
    private func addSupplementaryItem(
        at section: NSCollectionLayoutSection,
        sectionIndex: Int
    ) {
        guard let reactor = reactor else { return }
        let sectionObservable = reactor.state.compactMap { $0.sections[safe: sectionIndex] }
        let styleObservable = reactor.state.map {
            $0.styles.count == $0.originStyles.count
        }
        let gridGoodsObservable = reactor.state.map {
            $0.gridGoods.count == $0.originGridGoods.count
        }
        
        Observable.combineLatest(
            sectionObservable,
            styleObservable,
            gridGoodsObservable
        ) { ($0, $1, $2) }
            .subscribe(onNext: { [weak self] display, doneStyleLoad, doneGridGoodsLoad in
                guard let self else { return }
                
                if display.header != nil {
                    let header = self.configureHeader()
                    section.boundarySupplementaryItems.append(header)
                }
                
                if display.footer != nil {
                    switch display.contents?.type {
                    case .style:
                        if !doneStyleLoad {
                            addFooter()
                        }
                    case .grid:
                        if !doneGridGoodsLoad {
                            addFooter()
                        }
                    default:
                        addFooter()
                    }
                }
                
                func addFooter() {
                    let footer = self.configureFooter()
                    section.boundarySupplementaryItems.append(footer)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - DataSource

extension HomeViewController {
    private func makeSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>()
        snapshot.appendSections(HomeSection.allCases)
        dataSource.apply(snapshot)
    }
    
    private func configureCell() {
        dataSource = UICollectionViewDiffableDataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, itemIdentifier in
                switch HomeSection.allCases[indexPath.section] {
                case .banner:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: BannerCollectionViewCell.identifier,
                        for: indexPath
                    ) as? BannerCollectionViewCell,
                          case let HomeItem.ItemType.banner(banner) = itemIdentifier.type
                    else { return UICollectionViewCell() }
                    cell.configure(banner: banner)
                    return cell
                case .grid:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ProductCollectionViewCell.identifier,
                        for: indexPath
                    ) as? ProductCollectionViewCell,
                          case let HomeItem.ItemType.grid(goods) = itemIdentifier.type
                    else { return UICollectionViewCell() }
                    cell.configure(goods: goods)
                    return cell
                case .scroll:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ProductCollectionViewCell.identifier,
                        for: indexPath
                    ) as? ProductCollectionViewCell,
                          case let HomeItem.ItemType.scroll(goods) = itemIdentifier.type
                    else { return UICollectionViewCell() }
                    cell.configure(goods: goods)
                    return cell
                case .style:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: StyleCollectionViewCell.identifier,
                        for: indexPath
                    ) as? StyleCollectionViewCell,
                          case let HomeItem.ItemType.style(style) = itemIdentifier.type
                    else { return UICollectionViewCell() }
                    cell.configure(style: style)
                    return cell
                }
            }
        )
    }
    
    private func configureCollectionViewSupplementaryView() {
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self else { return UICollectionReusableView() }
            
            var displaySection: DisplaySection?
            self.reactor?.state
                .map { $0.sections[safe: indexPath.section] }
                .subscribe { displaySection = $0 }
                .disposed(by: self.disposeBag)
            
            switch kind {
            case CounterReusableView.identifier:
                guard let counterView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: CounterReusableView.identifier,
                    for: indexPath
                ) as? CounterReusableView else {
                    return UICollectionReusableView()
                }
                counterView.configure(reactor: self.reactor)
                return counterView
                
            case HeaderCollectionReusableView.identifier:
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: HeaderCollectionReusableView.identifier,
                    for: indexPath
                ) as? HeaderCollectionReusableView else {
                    return UICollectionReusableView()
                }
                if let header = displaySection?.header {
                    headerView.configure(header: header)
                }
                return headerView
                
            case FooterCollectionReusableView.identifier:
                guard let footerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: FooterCollectionReusableView.identifier,
                    for: indexPath
                ) as? FooterCollectionReusableView else {
                    return UICollectionReusableView()
                }
                footerView.configure(reactor: self.reactor, section: displaySection)
                return footerView

            default:
                return UICollectionReusableView()
            }
        }
    }
}
