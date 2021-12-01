//
//  HomeTableAdapter.swift
//  TheMovieDB
//
//  Created by user on 29.11.2021.
//

import UIKit

protocol HomeTableAdapterProtocol: AnyObject {
    var trends: [Trend] { get set }
    var nowPlaying: [NowPlayingMovie] { get set }
    var tvPopular: [TvPopular] { get set }
}

protocol CellItemTappedDelegate: AnyObject {
    func cellItemTapped (item: Int, type: MediaType, cellType: CellType)
}

protocol CellLoadMoreDelegate: AnyObject {
    func loadMore(cellType: CellType)
}

class HomeTableAdapter: NSObject, HomeTableAdapterProtocol {
    var trends: [Trend] = .init()
    var nowPlaying: [NowPlayingMovie] = .init()
    var tvPopular: [TvPopular] = .init()
    
    weak var cellItemTappedDelegate: CellItemTappedDelegate?
    weak var cellLoadMoreDelegate: CellLoadMoreDelegate?
}

extension HomeTableAdapter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        // тренды
        case 0:
            return 280
        // сейчас в кино
        case 1:
            return 200
        // популярные сериалы
        case 2:
            return 180
        default:
            fatalError()
        }
    }
}

extension HomeTableAdapter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TrendsCell.identifier, for: indexPath) as? TrendsCell else { fatalError() }
            cell.trends = self.trends
            cell.delegate = self
            cell.loadMoreDelegate = self
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NowPlayingCell.identifier, for: indexPath
            ) as? NowPlayingCell else { fatalError() }
            cell.nowPlaying = self.nowPlaying
            cell.delegate = self
            cell.loadMoreDelegate = self
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TvPopularCell.identifier, for: indexPath
            ) as? TvPopularCell else { fatalError() }
            cell.delegate = self
            cell.loadMoreDelegate = self
            cell.tvPopulars = self.tvPopular
            return cell
        default:
            fatalError()
        }
    }
}

extension HomeTableAdapter: CellDidSelectItemAtDelegate {
    func didSelect(item: Int, mediaType: MediaType, cellType: CellType) {
        cellItemTappedDelegate?.cellItemTapped(item: item, type: mediaType, cellType: cellType)
    }
}

extension HomeTableAdapter: LoadMoreDelegate {
    func loadMore(cellType: CellType) {
        cellLoadMoreDelegate?.loadMore(cellType: cellType)
    }
}
