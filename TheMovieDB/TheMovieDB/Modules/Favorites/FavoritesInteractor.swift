//
//  FavoritesInteractor.swift
//  TheMovieDB
//
//  Created by user on 25.11.2021.
//

import Foundation

protocol FavoritesInteractorProtocol: AnyObject {
    var presenter: FavoritesPresenterProtocol? { get set }
    func revomeFromFavorites(id: Int)
    func revomeAllFavorites()
}

final class FavoritesInteractor: FavoritesInteractorProtocol {
    weak var presenter: FavoritesPresenterProtocol?
    private let persistentService: PersistentService = PersistentService.shared
    
    func revomeFromFavorites(id: Int) {
        persistentService.removeFromFavorites(id: id)
    }
    
    func revomeAllFavorites() {
        persistentService.resetFavorites {
            presenter?.deleteAllFavoriteSuccess()
        }
    }
}
