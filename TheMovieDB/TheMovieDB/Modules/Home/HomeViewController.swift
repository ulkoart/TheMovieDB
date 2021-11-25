//
//  HomeViewController.swift
//  TheMovieDB
//
//  Created by user on 25.10.2021.
//

import UIKit

protocol HomeViewControllerProtocol: AnyObject {
    var presenter: HomePresenterProtocol? { get set }
    var trends: [Trend] { get set }
    var nowPlaying: [NowPlayingMovie] { get set }
    var tvPopular: [TvPopular] { get set }
    
    func reloadRows()
    func reloadNowPlaying()
    func reloadTrends()
    func reloadTvPopular()
}

final class HomeViewController: IndicationViewController {
    
    var presenter: HomePresenterProtocol?
    
    var trends: [Trend] = .init()
    var nowPlaying: [NowPlayingMovie] = .init()
    var tvPopular: [TvPopular] = .init()
    
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
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
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

extension HomeViewController: HomeViewControllerProtocol {
    
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
        trendsCell.trends = self.trends
    }
    
    func reloadNowPlaying() {
        let nowPlayingIndexPath = IndexPath(row: 1, section: 0)
        guard let nowPlayingCell = tableView.cellForRow(at: nowPlayingIndexPath) as? NowPlayingCell else { return }
        nowPlayingCell.nowPlaying = self.nowPlaying
    }
    
    func reloadTvPopular() {
        let tvPopularIndexPath = IndexPath(row: 2, section: 0)
        guard let tvPopularCell = tableView.cellForRow(at: tvPopularIndexPath) as? TvPopularCell else { return }
        tvPopularCell.tvPopulars = self.tvPopular
    }
}

extension HomeViewController: TrendsCellDidSelectItemAtDelegate {
    func trendDidSelect(with trend: Trend) {
        switch trend.mediaType {
        case .movie:
            presenter?.showMovie(movieId: trend.id)
        case .tvSerial:
            presenter?.showTvSerial(tvSerialId: trend.id)
        }
    }
}

extension HomeViewController: NowPlayingCellLoadMoreDelegate {
    func loadMoreNowPlaying() {
        presenter?.loadMoreNowPlaying()
    }
}

extension HomeViewController: TrendsCellLoadMoreDelegate {
    func loadMoreTrends() {
        presenter?.loadMoreTrends()
    }
}

extension HomeViewController: NowPlayingCellDidSelectItemAtDelegate {
    func nowPlayingDidSelect(with nowPlayingMovie: NowPlayingMovie) {
        presenter?.showMovie(movieId: nowPlayingMovie.id)
    }
}

extension HomeViewController: TvPopularCellDidSelectItemAtDelegate {
    func tvPopularCellDidSelect(with tvPopular: TvPopular) {
        presenter?.showTvSerial(tvSerialId: tvPopular.id)
    }
}

extension HomeViewController: TvPopularLoadMoreDelegate {
    func loadMoreTvPopular() {
        presenter?.loadMoreTvPopular()
    }
}
