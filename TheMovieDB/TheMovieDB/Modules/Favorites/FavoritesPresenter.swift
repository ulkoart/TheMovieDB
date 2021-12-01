//
//  FavoritesPresenter.swift
//  TheMovieDB
//
//  Created by user on 25.11.2021.
//

import UIKit

protocol FavoritesPresenterProtocol: AnyObject {
    var viewController: FavoritesViewControllerProtocol? { get set }
    var interactor: FavoritesInteractorProtocol? { get set }
    var router: FavoritesRouterProtocol? { get set }
    
    func deleteFavorite(id: Int)
    func deleteAllFavorite()
    func deleteAllFavoriteSuccess()
    func presentMovieScreen(from view: UIViewController, for movieId: Int)
}

class FavoritesPresenter: FavoritesPresenterProtocol {
    weak var viewController: FavoritesViewControllerProtocol?
    var interactor: FavoritesInteractorProtocol?
    var router: FavoritesRouterProtocol?
    
    func deleteFavorite(id: Int) {
        interactor?.revomeFromFavorites(id: id)
    }
    
    func deleteAllFavorite() {
        interactor?.revomeAllFavorites()
    }
    
    func deleteAllFavoriteSuccess() {
        viewController?.reloadData()
    }
    
    func presentMovieScreen(from view: UIViewController, for movieId: Int) {
        router?.presentMovieScreen(from: view, for: movieId)
    }
    
}
