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
    
    private let defaults = UserDefaults.standard
    private var service: TMDBNetworkServiceProtocol = TMDBNetworkService.shared
    
    func retrieveSearchMovie(query: String) {
        let includeAdult = defaults.bool(forKey: SearchSettingsInteractor.adultFillterValue)
        service.searchMovie(query: query, includeAdult: includeAdult) { [weak self] response in
            switch response {
            case .success(let data):
                self?.presenter?.searchMovieSuccess(movies: data.results)
            case .failure(let error):
                _ = error // что бы линтрер успокоился
                self?.presenter?.searchMovieFailure()
            }
        }
    }
}
