//
//  SearchPresenter.swift
//  TheMovieDB
//
//  Created by user on 28.10.2021.
//

import Foundation
import UIKit

protocol SearchPresenterProtocol: AnyObject {
    var viewController: SearchViewControllerProtocol? { get set }
    var interactor: SearchInteractorProtocol? { get set }
    var router: SearchRouterProtocol? { get set }
    
    func searchMovie(name query: String)
    func searchMovieSuccess(movies: [SearchMovie])
    func searchMovieFailure()
    
    func presentSettingsScreen(view: UIViewController)
}

class SearchPresenter: SearchPresenterProtocol {
    weak var viewController: SearchViewControllerProtocol?
    var interactor: SearchInteractorProtocol?
    var router: SearchRouterProtocol?
    
    func searchMovie(name query: String) {
        interactor?.retrieveSearchMovie(query: query)
    }
    
    func searchMovieSuccess(movies: [SearchMovie]) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.searchResults = movies
        }
    }
    
    func searchMovieFailure() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.searchResults = []
            self?.viewController?.placeholderLabel.text = "к сожалению по вашему запросу ничего не найдено :-("
        }
    }
    
    func presentSettingsScreen(view: UIViewController) {
        guard let router = router else { return }
        router.presentSettingsScreen(from: view)
    }
}
