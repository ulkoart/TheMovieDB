//
//  SearchInteractor.swift
//  TheMovieDB
//
//  Created by user on 28.10.2021.
//

import Foundation

protocol SearchInteractorProtocol: AnyObject {
    var presenter: SearchPresenterProtocol? { get set }
    
    func retrieveSearchMovie(query: String)
}

final class SearchInteractor: SearchInteractorProtocol {
    weak var presenter: SearchPresenterProtocol?
    
    private var service: TMDBNetworkServiceProtocol = TMDBNetworkService.shared
    
    func retrieveSearchMovie(query: String) {
        service.searchMovie(query: query) { [weak self] response in
            switch response {
            case .success(let data):
                self?.presenter?.searchMovieSuccess(movies: data.results)
            case .failure(let error):
                print(error)
            }
        }
    }
}
