//
//  HomeRouter.swift
//  TheMovieDB
//
//  Created by user on 25.10.2021.
//

import UIKit

protocol HomeRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func presentMovieScreen(from view: HomeViewControllerProtocol, for movieId: Int)
    func presentTvSerial(from view: HomeViewControllerProtocol, for tvSerialId: Int)
}

final class HomeRouter: HomeRouterProtocol {
    static func createModule() -> UIViewController {
        let viewController = HomeViewController()
        let presenter = HomePresenter()
        let interactor = HomeInteractor()
        let router = HomeRouter()
        
        viewController.presenter = presenter
        presenter.viewController = viewController
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return viewController
    }
    
    func presentMovieScreen(from view: HomeViewControllerProtocol, for movieId: Int) {
        let movieViewController = MovieRouter.createModule(with: movieId)
        guard let view = view as? UIViewController else { fatalError("Invalid View Protocol type") }
        view.navigationController?.pushViewController(movieViewController, animated: true)
    }
    
    func presentTvSerial(from view: HomeViewControllerProtocol, for tvSerialId: Int) {
        let tvSerialViewController = TvSerialRouter.createModule(with: tvSerialId)
        guard let view = view as? UIViewController else { fatalError("Invalid View Protocol type") }
        view.navigationController?.pushViewController(tvSerialViewController, animated: true)
    }
}
