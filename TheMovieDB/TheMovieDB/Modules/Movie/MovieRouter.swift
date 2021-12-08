//
//  MovieRouter.swift
//  TheMovieDB
//
//  Created by user on 01.11.2021.
//

import UIKit

protocol MovieRouterProtocol: AnyObject {
    static func createModule(with movieId: Int) -> MovieViewController
}

final class MovieRouter: MovieRouterProtocol {
    
    static func createModule(with movieId: Int) -> MovieViewController {
        let viewController = MovieViewController(movieId: movieId)
        let presenter = MoviePresenter()
        let interactor = MovieInteractor()
        let router = MovieRouter()
        
        viewController.presenter = presenter
        presenter.viewController = viewController
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return viewController
    }
}
