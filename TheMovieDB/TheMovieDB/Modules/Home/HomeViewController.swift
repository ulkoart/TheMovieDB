//
//  HomeViewController.swift
//  TheMovieDB
//
//  Created by user on 25.10.2021.
//

import UIKit

protocol HomeViewControllerProtocol: AnyObject {
    var presenter: HomePresenterProtocol? { get set }
    var tableAdapter: HomeTableAdapter { get set }
    
    func loadDataDone(trends: [Trend], nowPlaying: [NowPlayingMovie], tvPopular: [TvPopular])
    func reloadRows()
    func reloadNowPlaying()
    func reloadTrends()
    func reloadTvPopular()
}

final class HomeViewController: IndicationViewController {
    
    var presenter: HomePresenterProtocol?
    var tableAdapter = HomeTableAdapter()
    
    private let tableView: UITableView = {
        $0.allowsSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(TrendsCell.self, forCellReuseIdentifier: TrendsCell.identifier)
        $0.register(NowPlayingCell.self, forCellReuseIdentifier: NowPlayingCell.identifier)
        $0.register(TvPopularCell.self, forCellReuseIdentifier: TvPopularCell.identifier)
        return $0
    }(UITableView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        presenter?.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetNavigationBar()
    }
    
    private func resetNavigationBar() {
        guard let navigationController = navigationController as? StatusBarStyleNavigationController else { return }
        navigationController.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController.navigationBar.shadowImage = nil
        navigationController.statusBarEnterLightBackground()
    }
    
    private func configure() {
        view.backgroundColor = .white
        
        tableView.delegate = tableAdapter
        tableView.dataSource = tableAdapter
        
        tableAdapter.cellItemTappedDelegate = self
        tableAdapter.cellLoadMoreDelegate = self
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension HomeViewController: HomeViewControllerProtocol {
    func loadDataDone(trends: [Trend], nowPlaying: [NowPlayingMovie], tvPopular: [TvPopular]) {
        tableAdapter.trends = trends
        tableAdapter.nowPlaying = nowPlaying
        tableAdapter.tvPopular = tvPopular
    }
    
    func reloadRows() {
        let trendsIndexPath = IndexPath(row: 0, section: 0)
        let nowPlayingIndexPath = IndexPath(row: 1, section: 0)
        let tvPopularIndexPath = IndexPath(row: 2, section: 0)
        
        tableView.reloadRows(at: [trendsIndexPath], with: .left)
        tableView.reloadRows(at: [nowPlayingIndexPath], with: .right)
        tableView.reloadRows(at: [tvPopularIndexPath], with: .left)
    }
    
    func reloadTrends() {
        let trendsIndexPath = IndexPath(row: 0, section: 0)
        guard let trendsCell = tableView.cellForRow(at: trendsIndexPath) as? TrendsCell else { return }
        trendsCell.trends = tableAdapter.trends
    }
    
    func reloadNowPlaying() {
        let nowPlayingIndexPath = IndexPath(row: 1, section: 0)
        guard let nowPlayingCell = tableView.cellForRow(at: nowPlayingIndexPath) as? NowPlayingCell else { return }
        nowPlayingCell.nowPlaying = tableAdapter.nowPlaying
    }
    
    func reloadTvPopular() {
        let tvPopularIndexPath = IndexPath(row: 2, section: 0)
        guard let tvPopularCell = tableView.cellForRow(at: tvPopularIndexPath) as? TvPopularCell else { return }
        tvPopularCell.tvPopulars = tableAdapter.tvPopular
    }
}

/// Обработка тапов по ячейкам каруселей
extension HomeViewController: CellItemTappedDelegate {
    func cellItemTapped(item: Int, type: MediaType, cellType: CellType) {
        switch cellType {
        case .trend:
            let trend = tableAdapter.trends[item]
            switch type {
            case .movie:
                presenter?.showMovie(movieId: trend.id)
            case .tvSerial:
                presenter?.showTvSerial(tvSerialId: trend.id)
            }
            
        case .nowPlaying:
            let movie = tableAdapter.nowPlaying[item]
            presenter?.showMovie(movieId: movie.id)
        case .tvPopular:
            let tvSerial = tableAdapter.tvPopular[item]
            presenter?.showTvSerial(tvSerialId: tvSerial.id)
        }
    }
}

extension HomeViewController: CellLoadMoreDelegate {
    func loadMore(cellType: CellType) {
        switch cellType {
        case .trend:
            presenter?.loadMoreTrends()
        case .nowPlaying:
            presenter?.loadMoreNowPlaying()
        case .tvPopular:
            presenter?.loadMoreTvPopular()
        }
        
    }
}
