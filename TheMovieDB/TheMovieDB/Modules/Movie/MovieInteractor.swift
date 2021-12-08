//
//  MovieInteractor.swift
//  TheMovieDB
//
//  Created by user on 05.11.2021.
//

import Foundation

protocol MovieInteractorProtocol: AnyObject {
    var presenter: MoviePresenterProtocol? { get set }
    var networkService: TMDBNetworkServiceProtocol? { get set }
    
    func retrieveData(movieId: Int)
    func changeFavorite(movieDetail: MovieDetailResponse, movieImageData: Data?)
    func movieIsFavorite(id: Int) -> Bool
}

final class MovieInteractor: MovieInteractorProtocol {
    weak var presenter: MoviePresenterProtocol?
    
    var networkService: TMDBNetworkServiceProtocol? = TMDBNetworkService.shared
    private let persistentService: PersistentService = PersistentService.shared
    
    private let dispatchGroup = DispatchGroup()
    private var movieDetail: MovieDetailResponse?
    private var movieCredits: MovieCreditsResponse?
    
    func retrieveData(movieId: Int) {
        retrieveMovieData(movieId: movieId)
    }
    
    func changeFavorite(movieDetail: MovieDetailResponse, movieImageData: Data?) {
        if movieIsFavorite(id: movieDetail.id) {
            persistentService.removeFromFavorites(id: movieDetail.id)
        } else {
            guard let movieImageData = movieImageData else { return }
            persistentService.addToFavorite(id: movieDetail.id, title: movieDetail.title, movieImageData: movieImageData)
        }
        presenter?.updateFavouritesDone()
    }
    
    func movieIsFavorite(id: Int) -> Bool {
        return persistentService.isFavorite(id: id)
    }
    
    private func retrieveMovieData(movieId: Int) {
        dispatchGroup.enter()
        networkService?.getMovieDetail(movieId: movieId) { self.processGetMovieDetail($0) }
        
        dispatchGroup.enter()
        networkService?.getMovieCredits(movieId: movieId) { self.processGetMovieCredits($0) }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let movieDetail = self?.movieDetail else { return }
            guard let movieCredits = self?.movieCredits else { return }
            self?.presenter?.loadDataSuccess(movieDetail: movieDetail, movieCredits: movieCredits)
        }
    }
    
    private func processGetMovieDetail(_ response: GetMovieDetailResponse) {
        defer { dispatchGroup.leave() }
        switch response {
        case .success(let data):
            movieDetail = data
        case .failure(let error):
            presenter?.loadDataFailure(errorString: error.message)
        }
    }
    
    private func processGetMovieCredits(_ response: GetMovieCreditsResponse) {
        defer { dispatchGroup.leave() }
        switch response {
        case .success(let data):
            movieCredits = data
        case .failure(let error):
            presenter?.loadDataFailure(errorString: error.message)
        }
    }
}
