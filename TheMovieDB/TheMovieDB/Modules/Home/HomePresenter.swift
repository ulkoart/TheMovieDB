//
//  HomePresenter.swift
//  TheMovieDB
//
//  Created by user on 26.10.2021.
//

import UIKit

typealias HomeViewIndicationProtocol = HomeViewControllerProtocol & IndicationViewControllerProtocol

protocol HomePresenterProtocol: AnyObject {
    var viewController: HomeViewIndicationProtocol? { get set }
    var interactor: HomeInteractorProtocol? { get set }
    var router: HomeRouterProtocol? { get set }
    func loadData()
    func loadDataSuccess(trends: [Trend], nowPlaying: [NowPlayingMovie], tvPopular: [TvPopular])
    func loadMoreNowPlaying()
    func loadMoreNowPlayingSuccess(nowPlaying: [NowPlayingMovie])
    func showMovie(movieId: Int)
}

final class HomePresenter: HomePresenterProtocol {
    weak var viewController: HomeViewIndicationProtocol?
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
    func loadDataSuccess(trends: [Trend], nowPlaying: [NowPlayingMovie], tvPopular: [TvPopular]) {
        viewController?.trends = trends
        viewController?.nowPlaying = nowPlaying
        viewController?.tvPopular = tvPopular
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.reloadRows()
            self?.viewController?.hideLoadView()
        }
    }
    
    func showMovie(movieId: Int) {
        guard let viewController = viewController else { return }
        router?.presentMovieScreen(from: viewController, for: movieId)
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
