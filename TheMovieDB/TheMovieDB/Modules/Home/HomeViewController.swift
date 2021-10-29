//
//  HomeViewController.swift
//  TheMovieDB
//
//  Created by user on 25.10.2021.
//

import UIKit

protocol HomeViewControllerProtocol: AnyObject {
    var presenter: HomePresenterProtocol? { get set }
    
    var trends: [Movie] { get set }
    var nowPlaying: [NowPlayingMovie] { get set }
    var tvPopular: [TvPopular] { get set }
    
    func showLoadView() -> Void
    func hideLoadView() -> Void
    func reloadRows() -> Void
}

final class HomeViewController: UIViewController {
    
    var presenter: HomePresenterProtocol?
    
    var trends: [Movie] = .init()
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
    } (UITableView())
    
    private let loadView: LoadView = {
        return $0
    } (LoadView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        presenter?.loadData()
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
            cell.movies = self.trends
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NowPlayingCell.identifier, for: indexPath) as? NowPlayingCell else { fatalError() }
            cell.nowPlaying = self.nowPlaying
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TvPopularCell.identifier, for: indexPath) as? TvPopularCell else { fatalError() }
            cell.tvPopulars = self.tvPopular
            return cell
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return view.frame.size.height * 0.38
        case 1:
            return view.frame.size.height * 0.28
        case 2:
            return view.frame.size.height * 0.2
        default:
            fatalError()
        }
    }
}

extension HomeViewController: HomeViewControllerProtocol {
    func showLoadView() {
        tableView.alpha = 0
        view.addSubview(loadView)
        loadView.alpha = 1
    }
    
    func hideLoadView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.loadView.alpha = 0
        })
        tableView.alpha = 1
        loadView.removeFromSuperview()
    }
    
    func reloadRows() {
        let trendsIndexPath = IndexPath(row: 0, section: 0)
        let nowPlayingIndexPath = IndexPath(row: 1, section: 0)
        let tvPopularIndexPath = IndexPath(row: 2, section: 0)
        
        tableView.reloadRows(at: [trendsIndexPath], with: .left)
        tableView.reloadRows(at: [nowPlayingIndexPath], with: .right)
        tableView.reloadRows(at: [tvPopularIndexPath], with: .left)
    }
}
