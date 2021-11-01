//
//  SearchPresenter.swift
//  TheMovieDB
//
//  Created by user on 28.10.2021.
//

import Foundation

protocol SearchPresenterProtocol: AnyObject {
    var viewController: SearchViewControllerProtocol? { get set }
    var interactor: SearchInteractorProtocol? { get set }
    
    func searchMovie(name query: String)
    func searchMovieSuccess(movies: [SearchMovie]) 
}

class SearchPresenter: SearchPresenterProtocol {
    var viewController: SearchViewControllerProtocol?
    var interactor: SearchInteractorProtocol?
    
    func searchMovie(name query: String) {
        interactor?.retrieveSearchMovie(query: query)
    }
    
    func searchMovieSuccess(movies: [SearchMovie]) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.searchResults = movies
        }
    }
}
