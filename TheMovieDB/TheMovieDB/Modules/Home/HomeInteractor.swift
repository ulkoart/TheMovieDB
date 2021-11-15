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
}

final class HomeInteractor: HomeInteractorProtocol {
    weak var presenter: HomePresenterProtocol?
    
    private var service: TMDBNetworkServiceProtocol = TMDBNetworkService.shared
    private var nowPlayingPage: Int = 1
    
    func retrieveData() {
    
        var trends = [Trend]()
        var nowPlaying = [NowPlayingMovie]()
        var tvPopular = [TvPopular]()
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        service.getTrending { trendsResponse in
            dispatchGroup.leave()
            
            switch trendsResponse {
            case .success(let data):
                trends = data.results
            case .failure(let error):
                self.presenter?.showErrorMessage(text: error.message)
            }
        }

        dispatchGroup.enter()
        service.getNowPlaying(page: nowPlayingPage) { nowPlayingResponse in
            dispatchGroup.leave()
            switch nowPlayingResponse {
            case .success(let data):
                nowPlaying = data.results
            case .failure(let error):
                self.presenter?.showErrorMessage(text: error.message)
            }
        }
        
        dispatchGroup.enter()
        service.getTvPopular { tvPopularResponse in
            dispatchGroup.leave()
            switch tvPopularResponse {
            case .success(let data):
                tvPopular = data.results
            case .failure(let error):
                self.presenter?.showErrorMessage(text: error.message)
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.presenter?.loadDataSuccess(trends: trends, nowPlaying: nowPlaying, tvPopular: tvPopular)
        }
    }
    
    func retrieveMoreNowPlaying() {
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
}
