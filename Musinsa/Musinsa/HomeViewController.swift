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
        reactor.state.map { $0.sections }
            .asDriver(onErrorJustReturn: [])
            .distinctUntilChanged()
            .drive { [weak self] sections in
                guard let self else { return }
                
                var snapshot = self.dataSource.snapshot()
                sections.forEach { section in
                    guard let type = section.contents?.type else { return }
                    switch type {
                    case .banner:
                        guard let banners = section.contents?.items as? [Banner] else { return }
                        let bannerItems = banners.map { HomeItem(type: .banner($0)) }
                        snapshot.appendItems(bannerItems, toSection: .banner)
                        
                    case .scroll:
                        guard let goods = section.contents?.items as? [Goods] else { return }
                        let goodsItems = goods.map { HomeItem(type: .scroll($0)) }
                        snapshot.appendItems(goodsItems, toSection: .scroll)
                        
                    case .grid:
                        guard let goods = section.contents?.items as? [Goods] else { return }
                        let goodsItems = goods.map { HomeItem(type: .grid($0)) }
                        snapshot.appendItems(goodsItems, toSection: .grid)
                        
                    case .style:
                        guard let styles = section.contents?.items as? [Style] else { return }
                        let styleItems = styles.map { HomeItem(type: .style($0)) }
                        snapshot.appendItems(styleItems, toSection: .style)
                    }
                }
                
                self.dataSource.apply(snapshot)
            }.disposed(by: disposeBag)
    }
}

// MARK: - Layout

extension HomeViewController {
    private func generateCollectionViewLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [unowned self] sectionIndex, _ in
            switch HomeSection.allCases[sectionIndex] {
            case .banner:
                return self.bannerSectionLayout()
            case .grid:
                return self.gridSectionLayout()
            case .scroll:
                return self.scrollSectionLayout()
            case .style:
                return self.styleSectionLayout()
            }
        }
    }
    
    private func bannerSectionLayout() -> NSCollectionLayoutSection {
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
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, contentOffset, _ in
            guard let self,
                  let currentIndexPath = visibleItems.last?.indexPath,
                  let cell = self.collectionView.cellForItem(
                      at: currentIndexPath
                  ) as? BannerCollectionViewCell
            else { return }
            cell.parallaxOffsetX(from: contentOffset)
        }
        return section
    }
    
    private func gridSectionLayout() -> NSCollectionLayoutSection {
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
        return section
    }
    
    private func scrollSectionLayout() -> NSCollectionLayoutSection {
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
        return section
    }

    private func styleSectionLayout() -> NSCollectionLayoutSection {
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
        return section
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
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            switch kind {
            case HeaderCollectionReusableView.identifier:
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: HeaderCollectionReusableView.identifier,
                    for: indexPath
                ) as? HeaderCollectionReusableView else {
                    return UICollectionReusableView()
                }
                // TODO: - header에 데이터 전달 필요
                return header
            case FooterCollectionReusableView.identifier:
                guard let footer = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: FooterCollectionReusableView.identifier,
                    for: indexPath
                ) as? FooterCollectionReusableView else {
                    return UICollectionReusableView()
                }
                // TODO: - footer에 데이터 전달 필요
                return footer
            default:
                return UICollectionReusableView()
            }
        }
    }
}
