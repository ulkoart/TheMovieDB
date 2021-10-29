//
//  HomeRouter.swift
//  TheMovieDB
//
//  Created by user on 25.10.2021.
//

import UIKit

protocol HomeRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
}

final class HomeRouter { }

extension HomeRouter: HomeRouterProtocol {
    
    static func createModule() -> UIViewController {
        let viewController = HomeViewController()
        let presenter = HomePresenter()
        let interactor = HomeInteractor()
        
        viewController.presenter = presenter
        presenter.viewController = viewController
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return viewController
    }
}
