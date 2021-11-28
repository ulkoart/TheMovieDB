//
//  FavoritesCell.swift
//  TheMovieDB
//
//  Created by user on 26.11.2021.
//

import UIKit

class FavoritesCell: UITableViewCell {
    
    static let identifier = "UITableViewCell"
    
    private let favoritesImageView: UIImageView = {
        $0.backgroundColor = .init(white: 0.8, alpha: 1)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 5
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private let titleLabel: UILabel = {
        $0.font = .init(.systemFont(ofSize: 18, weight: .black))
        $0.textColor =  .black
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(favoritesImageView)
        NSLayoutConstraint.activate([
            favoritesImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            favoritesImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            favoritesImageView.heightAnchor.constraint(equalToConstant: 120),
            favoritesImageView.widthAnchor.constraint(equalToConstant: 80),
            favoritesImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: favoritesImageView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with favorite: Favorite) {
        guard
            let imageData = favorite.image,
            let image: UIImage = .init(data: imageData) else { return }
        favoritesImageView.image = image
        titleLabel.text = favorite.title
    }
}
