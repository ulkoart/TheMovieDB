//
//  MovieInteractor.swift
//  TheMovieDB
//
//  Created by user on 05.11.2021.
//

import Foundation

protocol MovieInteractorProtocol {
    var presenter: MoviePresenterProtocol? { get set }
    func retrieveMovieData(movieId: Int, mediaType: MediaType)
    
}

final class MovieInteractor: MovieInteractorProtocol {
    var presenter: MoviePresenterProtocol?
    private var service: TMDBNetworkServiceProtocol = TMDBNetworkService.shared
        
    func retrieveMovieData(movieId: Int, mediaType: MediaType) {
        switch mediaType {
        case .movie:
            service.getMovieDetail(movieId: movieId) { self.processGetMovieDetail($0) }
        case .tvSerial:
            print(2)
        }
    }
    
    private func processGetMovieDetail(_ response: GetMovieDetailResponse) {
        switch response {
        case .success(let data):
            presenter?.loadDataSuccess(movieDetail: data)
        case .failure(let error):
            print(error)
        }
    }
}
