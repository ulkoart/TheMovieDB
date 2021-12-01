//
//  StatusBarStyleNavigationController.swift
//  TheMovieDB
//
//  Created by user on 07.11.2021.
//

import UIKit

class StatusBarStyleNavigationController: UINavigationController {
    var isDarkContentBackground = false
    
    func statusBarEnterLightBackground() {
        isDarkContentBackground = false
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func statusBarEnterDarkBackground() {
        isDarkContentBackground = true
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if isDarkContentBackground {
            return .lightContent
        } else {
            return .darkContent
        }
    }
}
