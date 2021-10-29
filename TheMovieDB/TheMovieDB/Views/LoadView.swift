//
//  LoadView.swift
//  TheMovieDB
//
//  Created by user on 26.10.2021.
//

import UIKit

class LoadView: UIView {
    
    override func layoutSubviews() {
        guard let superview = superview else { return }
        
        backgroundColor = .init(white: 0.6, alpha: 1)
        layer.cornerRadius = 8.0
        translatesAutoresizingMaskIntoConstraints = false
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.startAnimating()
        activityIndicator.color = .init(white: 1, alpha: 1)
        activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        
        addSubview(activityIndicator)
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -6).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        let loadMsg = UILabel()
        loadMsg.textColor = .init(white: 1, alpha: 1)
        loadMsg.translatesAutoresizingMaskIntoConstraints = false
        loadMsg.font = .init(.systemFont(ofSize: 14, weight: .semibold))
        loadMsg.text = "Загрузка..."
        
        addSubview(loadMsg)
        loadMsg.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadMsg.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 100),
            widthAnchor.constraint(equalToConstant: 100),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor),
            centerXAnchor.constraint(equalTo: superview.centerXAnchor)
        ])

    }
}


