//
//  FavoritesRouter.swift
//  TheMovieDB
//
//  Created by user on 25.11.2021.
//

import UIKit

protocol FavoritesRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
}

final class FavoritesRouter: FavoritesRouterProtocol {
    static let tabBarItemImageName = "heart"
    
    static func createModule() -> UIViewController {
        let viewController = FavoritesViewController()
        let presenter = FavoritesPresenter()
        let interactor = FavoritesInteractor()
        
        viewController.presenter = presenter
        presenter.viewController = viewController
        presenter.interactor = interactor
        interactor.presenter = presenter
       
        return viewController
    }
}
