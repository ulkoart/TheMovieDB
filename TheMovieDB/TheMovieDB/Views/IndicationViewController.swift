//
//  IndicationViewController.swift
//  TheMovieDB
//
//  Created by user on 06.11.2021.
//

import UIKit

protocol IndicationViewControllerProtocol {
    func showLoadView()
    func hideLoadView()
    func showAlert(title: String, message: String)
}

class IndicationViewController: UIViewController {
    private let loadView: LoadView = {
        return $0
    }(LoadView())
    
    private let backView: UIView = {
        $0.backgroundColor = .init(white: 0.9, alpha: 1)
        $0.frame = UIScreen.main.bounds
        return $0
    }(UIView())
}

extension IndicationViewController: IndicationViewControllerProtocol {
    func showLoadView() {
        view.addSubview(backView)
        view.addSubview(loadView)
        loadView.alpha = 1
    }
    
    func hideLoadView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.loadView.alpha = 0
        })
        backView.removeFromSuperview()
        loadView.removeFromSuperview()
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}
