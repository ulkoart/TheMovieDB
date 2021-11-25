//
//  MainTabBarController.swift
//  TheMovieDB
//
//  Created by user on 25.10.2021.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            createController(viewController: HomeRouter.createModule(), title: "Киношечка 🎬", imageName: "house"),
            createController(viewController: SearchRouter.createModule(), title: "Поиск 🔎", imageName: "magnifyingglass"),
            createController(viewController: FavoritesRouter.createModule(), title: "Избранное ❤️", imageName: FavoritesRouter.tabBarItemImageName)
        ]
    }
    
    private func createController<Controller: UIViewController>(viewController: Controller, title: String, imageName: String) -> StatusBarStyleNavigationController {
        let navigationController = StatusBarStyleNavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.title = title
        navigationController.tabBarItem.title = nil
        navigationController.tabBarItem.image = UIImage(systemName: imageName)
        return navigationController
    }
}
