//
//  SearchRouter.swift
//  TheMovieDB
//
//  Created by user on 28.10.2021.
//

import UIKit

protocol SearchRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
}

final class SearchRouter: SearchRouterProtocol {
    
    static func createModule() -> UIViewController {
        let viewController = SearchViewController()
        let presenter = SearchPresenter()
        let interactor = SearchInteractor()
        
        viewController.presenter = presenter
        presenter.viewController = viewController
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return viewController
    }
}
