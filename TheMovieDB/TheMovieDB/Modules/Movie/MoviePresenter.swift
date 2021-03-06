//
//  MoviePresenter.swift
//  TheMovieDB
//
//  Created by user on 05.11.2021.
//

import Foundation

protocol MoviePresenterProtocol: AnyObject {
    var viewController: (MovieViewControllerProtocol & IndicationViewControllerProtocol)? { get set }
    var interactor: MovieInteractorProtocol? { get set }
    var router: MovieRouterProtocol? { get set }
    
    func loadData(movieId: Int)
    func loadDataSuccess(movieDetail: MovieDetailResponse, movieCredits: MovieCreditsResponse)
    func loadDataFailure(errorString: String)
    func changeFavoriteStatus(movieDetail: MovieDetailResponse, movieImageData: Data?)
    func movieIsFavorite(id: Int) -> Bool
    func updateFavouritesDone()
}

final class MoviePresenter: MoviePresenterProtocol {
    weak var viewController: (MovieViewControllerProtocol & IndicationViewControllerProtocol)?
    var interactor: MovieInteractorProtocol?
    var router: MovieRouterProtocol?
    
    func loadData(movieId: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.showLoadView()
        }
        interactor?.retrieveData(movieId: movieId)
    }
    
    func loadDataSuccess(movieDetail: MovieDetailResponse, movieCredits: MovieCreditsResponse) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.hideLoadView()
            self?.viewController?.configureData(movieDetail: movieDetail, movieCredits: movieCredits)
            self?.viewController?.reloadData()
        }
    }
    
    func loadDataFailure(errorString: String) {
        self.viewController?.dataFailure(text: errorString)
    }
    
    func changeFavoriteStatus(movieDetail: MovieDetailResponse, movieImageData: Data?) {
        interactor?.changeFavorite(movieDetail: movieDetail, movieImageData: movieImageData)
    }
    
    func movieIsFavorite(id: Int) -> Bool {
        guard let interactor = interactor else { return false }
        return interactor.movieIsFavorite(id: id)
    }
    
    func updateFavouritesDone() {
        viewController?.switchFavouritesIcon()
    }
}
