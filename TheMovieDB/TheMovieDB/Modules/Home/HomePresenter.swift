//
//  HomePresenter.swift
//  TheMovieDB
//
//  Created by user on 26.10.2021.
//

import Foundation

protocol HomePresenterProtocol: AnyObject {
    var viewController: HomeViewControllerProtocol? { get set }
    var interactor: HomeInteractorProtocol? { get set }
    func loadData()
    func loadDataSuccess(trends: [Movie], nowPlaying: [NowPlayingMovie], tvPopular: [TvPopular])

}

class HomePresenter: HomePresenterProtocol {
    weak var viewController: HomeViewControllerProtocol?
    var interactor: HomeInteractorProtocol?
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
}
