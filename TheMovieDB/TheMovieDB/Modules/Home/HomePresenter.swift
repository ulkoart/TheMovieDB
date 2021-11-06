//
//  HomePresenter.swift
//  TheMovieDB
//
//  Created by user on 26.10.2021.
//

import UIKit

// typealias HomeViewIndicationProtocol = HomeViewControllerProtocol & IndicationViewControllerProtocol

protocol HomePresenterProtocol: AnyObject {
    var viewController: (HomeViewControllerProtocol & IndicationViewControllerProtocol)? { get set }
    var interactor: HomeInteractorProtocol? { get set }
    var router: HomeRouterProtocol? { get set }
    func loadData()
    func loadDataSuccess(trends: [Movie], nowPlaying: [NowPlayingMovie], tvPopular: [TvPopular])
    func loadMoreNowPlaying()
    func loadMoreNowPlayingSuccess(nowPlaying: [NowPlayingMovie])
    func showMovie(movie: Movie)
}

final class HomePresenter: HomePresenterProtocol {
    weak var viewController: (HomeViewControllerProtocol & IndicationViewControllerProtocol)?
    var interactor: HomeInteractorProtocol?
    var router: HomeRouterProtocol?
    /// Запросы на загрузку данных для экрана
    func loadData() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.showLoadView()
        }
        interactor?.retrieveData()
    }
    /// Загрузка данных прошла успешно
    func loadDataSuccess(trends: [Movie], nowPlaying: [NowPlayingMovie], tvPopular: [TvPopular]) {
        viewController?.trends = trends
        viewController?.nowPlaying = nowPlaying
        viewController?.tvPopular = tvPopular
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.reloadRows()
            self?.viewController?.hideLoadView()
        }
    }
    
    func showMovie(movie: Movie) {
        guard let viewController = viewController else { return }
        router?.presentMovieScreen(from: viewController, for: movie)
    }
    
    func loadMoreNowPlaying() {
        interactor?.retrieveMoreNowPlaying()
    }
    
    func loadMoreNowPlayingSuccess(nowPlaying: [NowPlayingMovie]) {
        viewController?.nowPlaying.append(contentsOf: nowPlaying)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.addNowPlaying()
        }
    }
}
