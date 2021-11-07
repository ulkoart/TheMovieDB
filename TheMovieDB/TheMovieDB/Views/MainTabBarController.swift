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
            createController(viewController: HomeRouter.createModule(), title: "Киношечка 🎬", imageName: "home"),
            createController(viewController: SearchRouter.createModule(), title: "Поиск 🔎", imageName: "search")
        ]
    }
    
    private func createController(viewController: UIViewController, title: String, imageName: String) -> UIViewController {
        let navigationController = StatusBarStyleNavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.title = title
        navigationController.tabBarItem.title = nil
        navigationController.tabBarItem.image = UIImage(named: "\(imageName)")
        return navigationController
    }
}
