//
//  SearchSettingsRouter.swift
//  TheMovieDB
//
//  Created by user on 01.12.2021.
//

import UIKit

protocol SearchSettingsRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
}

final class SearchSettingsRouter: SearchSettingsRouterProtocol {
    
    static func createModule() -> UIViewController {
        let viewController = SearchSettingsViewController()
        let presenter = SearchSettingsPresenter()
        let interactor = SearchSettingsInteractor()
        
        presenter.viewController = viewController
        presenter.interactor = interactor
        interactor.presenter = presenter
        viewController.presenter = presenter
        
        let nav = UINavigationController()
        nav.viewControllers = [viewController]
        nav.navigationBar.prefersLargeTitles = true
        return nav
    }
    
    func presentSettingsScreen(from view: UIViewController) {
//        let searchSettingsViewController = SearchSettingsViewController()
//        view.present(searchSettingsViewController, animated: true, completion: nil)
    }
}
