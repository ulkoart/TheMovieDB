//
//  FavoritesPresenter.swift
//  TheMovieDB
//
//  Created by user on 25.11.2021.
//

import Foundation

protocol FavoritesPresenterProtocol: AnyObject {
    var viewController: FavoritesViewControllerProtocol? { get set }
    var interactor: FavoritesInteractorProtocol? { get set }
    
    func deleteFavorite(id: Int)
}

class FavoritesPresenter: FavoritesPresenterProtocol {
    weak var viewController: FavoritesViewControllerProtocol?
    var interactor: FavoritesInteractorProtocol?
    
    func deleteFavorite(id: Int) {
        interactor?.revomeFromFavorites(id: id)
    }
    
}
