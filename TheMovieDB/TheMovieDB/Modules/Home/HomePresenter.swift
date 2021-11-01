//
//  HomePresenter.swift
//  TheMovieDB
//
//  Created by user on 26.10.2021.
//

import UIKit

protocol HomePresenterProtocol: AnyObject {
    var viewController: HomeViewControllerProtocol? { get set }
    var interactor: HomeInteractorProtocol? { get set }
    var router: HomeRouterProtocol? { get set }
    func loadData()
    func loadDataSuccess(trends: [Movie], nowPlaying: [NowPlayingMovie], tvPopular: [TvPopular])
    func showMovie(movie: Movie)
    
}

class HomePresenter: HomePresenterProtocol {
    weak var viewController: HomeViewControllerProtocol?
    var interactor: HomeInteractorProtocol?
    var router: HomeRouterProtocol?
    /// Запросы на загрузку данных для экрана
    func loadData() {
        viewController?.showLoadView()
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
}
