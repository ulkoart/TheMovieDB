//
//  SearchRouter.swift
//  TheMovieDB
//
//  Created by user on 28.10.2021.
//

import UIKit

protocol SearchRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func presentSettingsScreen(from view: UIViewController)
}

final class SearchRouter: SearchRouterProtocol {
    
    static func createModule() -> UIViewController {
        let viewController = SearchViewController()
        let presenter = SearchPresenter()
        let interactor = SearchInteractor()
        let router = SearchRouter()
        
        viewController.presenter = presenter
        presenter.viewController = viewController
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return viewController
    }
    
    func presentSettingsScreen(from view: UIViewController) {
        let searchSettingsViewController = SearchSettingsRouter.createModule()
        view.present(searchSettingsViewController, animated: true, completion: nil)
    }
}
