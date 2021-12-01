//
//  FavoritesRouter.swift
//  TheMovieDB
//
//  Created by user on 25.11.2021.
//

import UIKit

protocol FavoritesRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func presentMovieScreen(from view: UIViewController, for movieId: Int)
}

final class FavoritesRouter: FavoritesRouterProtocol {
    static let tabBarItemImageName = "heart"
    
    static func createModule() -> UIViewController {
        let viewController = FavoritesViewController()
        let presenter = FavoritesPresenter()
        let interactor = FavoritesInteractor()
        let router = FavoritesRouter()
        
        viewController.presenter = presenter
        presenter.viewController = viewController
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
       
        return viewController
    }
    
    func presentMovieScreen(from view: UIViewController, for movieId: Int) {
        let movieViewController = MovieRouter.createModule(with: movieId)
        view.navigationController?.pushViewController(movieViewController, animated: true)
    }
}
