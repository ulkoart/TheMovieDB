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
        service.getTrending { trendsFromApi, _ in
            dispatchGroup.leave()
            trends = trendsFromApi
        }

        dispatchGroup.enter()
        service.getNowPlaying(page: nowPlayingPage) { nowPlayingFromApi, _ in
            dispatchGroup.leave()
            nowPlaying = nowPlayingFromApi
        }
        
        dispatchGroup.enter()
        service.getTvPopular { tvPopularFromApi, _ in
            dispatchGroup.leave()
            tvPopular = tvPopularFromApi
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.presenter?.loadDataSuccess(trends: trends, nowPlaying: nowPlaying, tvPopular: tvPopular)
        }
    }
    
    func retrieveMoreNowPlaying() {
        nowPlayingPage += 1
        service.getNowPlaying(page: nowPlayingPage) { [weak self] nowPlayingFromApi, _ in
            self?.presenter?.loadMoreNowPlayingSuccess(nowPlaying: nowPlayingFromApi)
        }
    }
}
