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
    
    func loadData(movieId: Int, mediaType: MediaType)
    func loadDataSuccess(movieDetail: MovieDetailResponse)
}

final class MoviePresenter: MoviePresenterProtocol {
    weak var viewController: (MovieViewControllerProtocol & IndicationViewControllerProtocol)?
    var interactor: MovieInteractorProtocol?
    var router: MovieRouterProtocol?
    
    func loadData(movieId: Int, mediaType: MediaType) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.showLoadView()
        }
        interactor?.retrieveMovieData(movieId: movieId, mediaType: mediaType)
    }
    
    func loadDataSuccess(movieDetail: MovieDetailResponse) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.hideLoadView()
            self?.viewController?.movieDetail = movieDetail
        }
    }
}
