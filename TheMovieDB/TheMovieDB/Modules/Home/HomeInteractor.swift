//
//  HomeInteractor.swift
//  TheMovieDB
//
//  Created by user on 26.10.2021.
//

import Foundation

protocol HomeInteractorProtocol: AnyObject {
    var presenter: HomePresenterProtocol? { get set }

    func retrieveData()
    
    func retrieveMoreNowPlaying()
    func retrieveMoreTrends()
    func retrieveMoreTvPopular()
}

final class HomeInteractor: HomeInteractorProtocol {
    weak var presenter: HomePresenterProtocol?
    
    private var service: TMDBNetworkServiceProtocol = TMDBNetworkService.shared
    
    private var nowPlayingPage: Int = 1
    private var nowPlayingTotalPages: Int = 1
    
    private var trendsPage: Int = 1
    private var trendsTotalPages: Int = 1
    
    private var tvPopularPage: Int = 1
    private var tvPopularTotalPages: Int = 1
    
    func retrieveData() {
    
        var trends = [Trend]()
        var trendsTotalPages = 0
        
        var nowPlaying = [NowPlayingMovie]()
        var nowPlayingTotalPages = 0
        
        var tvPopular = [TvPopular]()
        var tvPopularTotalPages = 0

        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        service.getTrending(page: trendsPage) { trendsResponse in
            defer { dispatchGroup.leave() }
            switch trendsResponse {
            case .success(let data):
                trendsTotalPages = data.totalPages
                trends = data.results
            case .failure(let error):
                self.presenter?.showErrorMessage(text: error.message)
            }
        }

        dispatchGroup.enter()
        service.getNowPlaying(page: nowPlayingPage) { nowPlayingResponse in
            defer { dispatchGroup.leave() }
            switch nowPlayingResponse {
            case .success(let data):
                nowPlayingTotalPages = data.totalPages
                nowPlaying = data.results
            case .failure(let error):
                self.presenter?.showErrorMessage(text: error.message)
            }
        }
        
        dispatchGroup.enter()
        service.getTvPopular(page: tvPopularPage) { tvPopularResponse in
            defer { dispatchGroup.leave() }
            switch tvPopularResponse {
            case .success(let data):
                tvPopularTotalPages = data.totalPages
                tvPopular = data.results
            case .failure(let error):
                self.presenter?.showErrorMessage(text: error.message)
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.nowPlayingTotalPages = nowPlayingTotalPages
            self?.trendsTotalPages = trendsTotalPages
            self?.tvPopularTotalPages = tvPopularTotalPages
            self?.presenter?.loadDataSuccess(trends: trends, nowPlaying: nowPlaying, tvPopular: tvPopular)
        }
    }
    
    func retrieveMoreNowPlaying() {
        guard nowPlayingPage <= nowPlayingTotalPages else { return }
        nowPlayingPage += 1
        
        service.getNowPlaying(page: nowPlayingPage) { [weak self] nowPlayingResponse in
            switch nowPlayingResponse {
            case .success(let data):
                self?.presenter?.loadMoreNowPlayingSuccess(nowPlaying: data.results)
            case .failure(let error):
                self?.presenter?.showErrorMessage(text: error.message)
            }
        }
    }
    
    func retrieveMoreTrends() {
        guard trendsPage <= trendsTotalPages else { return }
        trendsPage += 1
        
        service.getTrending(page: trendsPage) { [weak self] getTrendingResponse in
            switch getTrendingResponse {
            
            case .success(let data):
                self?.presenter?.loadMoreTrendsSuccess(trends: data.results)
            case .failure(let error):
                self?.presenter?.showErrorMessage(text: error.message)
            }
        }
    }
    
    func retrieveMoreTvPopular() {
        guard tvPopularPage <= tvPopularTotalPages else { return }
        tvPopularPage += 1
        
        service.getTvPopular(page: tvPopularPage) { [weak self] response in
            switch response {
            case .success(let data):
                self?.presenter?.loadMoreTvPopularSuccess(tvPopular: data.results)
            case .failure(let error):
                self?.presenter?.showErrorMessage(text: error.message)
            }
        }
    }
}
