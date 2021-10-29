//
//  SearchInteractor.swift
//  TheMovieDB
//
//  Created by user on 28.10.2021.
//

import Foundation

protocol SearchInteractorProtocol {
    var presenter: SearchPresenterProtocol? { get set }
    
    func retrieveSearchMovie(query: String)
}

final class SearchInteractor: SearchInteractorProtocol {
    var presenter: SearchPresenterProtocol?
    
    private var service: TMDBNetworkServiceProtocol = TMDBNetworkService.shared
    
    func retrieveSearchMovie(query: String) {
        service.searchMovie(query: query) { [weak self] movies, error in
            self?.presenter?.searchMovieSuccess(movies: movies)
        }
    }
}
