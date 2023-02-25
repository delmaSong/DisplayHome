//
//  HomeViewController.swift
//  Musinsa
//
//  Created by Delma Song on 2023/02/22.
//

import UIKit
import RxSwift
import SnapKit

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
        case banner([Banner])
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

final class HomeViewController: BaseViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<HomeSection, HomeItem>
    
    private var dataSource: DataSource!
    private let disposeBag = DisposeBag()
    
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
            widthDimension: .fractionalWidth(0.28),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(110)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 3
        )

        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func gridSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.28),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(110)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 3
        )

        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func scrollSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.28),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(110)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 3
        )

        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    private func styleSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.28),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(110)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 3
        )

        let section = NSCollectionLayoutSection(group: group)
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
                          case let HomeItem.ItemType.banner(banners) = itemIdentifier.type
                    else { return UICollectionViewCell() }
                    cell.configure(banners: banners)
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
