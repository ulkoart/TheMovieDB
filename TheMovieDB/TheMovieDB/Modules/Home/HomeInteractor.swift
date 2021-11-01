//
//  HomeInteractor.swift
//  TheMovieDB
//
//  Created by user on 26.10.2021.
//

import Foundation

protocol HomeInteractorProtocol {
    var presenter: HomePresenterProtocol? { get set }
    
    func retrieveData()
}

final class HomeInteractor: HomeInteractorProtocol {
    weak var presenter: HomePresenterProtocol?
    
    private var service: TMDBNetworkServiceProtocol = TMDBNetworkService.shared
    
    func retrieveData() {
        
        var trends = [Movie]()
        var nowPlaying = [NowPlayingMovie]()
        var tvPopular = [TvPopular]()
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        service.getTrending { trendsFromApi, _ in
            dispatchGroup.leave()
            trends = trendsFromApi
        }
        
        dispatchGroup.enter()
        service.getNowPlaying { nowPlayingFromApi, _ in
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
}
