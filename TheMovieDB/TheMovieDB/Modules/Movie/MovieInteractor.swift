//
//  MovieInteractor.swift
//  TheMovieDB
//
//  Created by user on 05.11.2021.
//

import Foundation

protocol MovieInteractorProtocol: AnyObject {
    var presenter: MoviePresenterProtocol? { get set }
    func retrieveData(movieId: Int, mediaType: MediaType)
}

final class MovieInteractor: MovieInteractorProtocol {
    weak var presenter: MoviePresenterProtocol?
    private var service: TMDBNetworkServiceProtocol = TMDBNetworkService.shared
    private let dispatchGroup = DispatchGroup()
    private var movieDetail: MovieDetailResponse?
        
    func retrieveData(movieId: Int, mediaType: MediaType) {
        switch mediaType {
        case .movie:
            retrieveMovieData(movieId: movieId)
        case .tvSerial:
            print("tvSerial")
        }
    }
    
    private func retrieveMovieData(movieId: Int) {
        dispatchGroup.enter()
        service.getMovieDetail(movieId: movieId) { self.processGetMovieDetail($0) }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let movieDetail = self?.movieDetail else { return }
            self?.presenter?.loadDataSuccess(movieDetail: movieDetail)
        }
    }
    
    private func processGetMovieDetail(_ response: GetMovieDetailResponse) {
        dispatchGroup.leave()
        
        switch response {
        case .success(let data):
            movieDetail = data
        case .failure(let error):
            print(error)
        }
    }
}
