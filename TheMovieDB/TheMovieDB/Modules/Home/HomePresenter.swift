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
    
    func loadMoreTrends()
    func loadMoreTrendsSuccess(trends: [Trend])
    
    func loadMoreTvPopular()
    func loadMoreTvPopularSuccess(tvPopular: [TvPopular])
    
    func showMovie(movieId: Int)
    func showTvSerial(tvSerialId: Int)
    func showErrorMessage(text: String)
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
    /// Открыть детальный экрна с фильмом
    func showMovie(movieId: Int) {
        guard let viewController = viewController else { return }
        router?.presentMovieScreen(from: viewController, for: movieId)
    }
    
    /// Открыть детальный экрна с сериалом
    func showTvSerial(tvSerialId: Int) {
        guard let viewController = viewController else { return }
        router?.presentTvSerial(from: viewController, for: tvSerialId)
    }
    
    func loadMoreNowPlaying() {
        interactor?.retrieveMoreNowPlaying()
    }
    
    func loadMoreNowPlayingSuccess(nowPlaying: [NowPlayingMovie]) {
        viewController?.nowPlaying.append(contentsOf: nowPlaying)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.reloadNowPlaying()
        }
    }
    
    func loadMoreTrends() {
        interactor?.retrieveMoreTrends()
    }
    
    func loadMoreTrendsSuccess(trends: [Trend]) {
        viewController?.trends.append(contentsOf: trends)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.reloadTrends()
        }
    }
    
    func showErrorMessage(text: String) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.showAlert(title: "Ой-Ой", message: text, completion: nil)
        }
    }
    
    func loadMoreTvPopular() {
        interactor?.retrieveMoreTvPopular()
    }
    
    func loadMoreTvPopularSuccess(tvPopular: [TvPopular]) {
        viewController?.tvPopular.append(contentsOf: tvPopular)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.reloadTvPopular()
        }
    }
}
