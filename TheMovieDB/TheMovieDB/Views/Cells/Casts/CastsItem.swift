//
//  CastsItem.swift
//  TheMovieDB
//
//  Created by user on 10.11.2021.
//

import UIKit

final class CastsItem: UICollectionViewCell {
    
    static let identifier = "CastsItem"
    static let cornerRadius: CGFloat = 5
    
    private let imageNetworkService: ImageLoadServiceProtocol = ImageLoadService.shared
    
    private let imageView: UIImageView = {
        $0.backgroundColor = .init(white: 0.9, alpha: 1)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = cornerRadius
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private let nameLabel: UILabel = {
        $0.font = .init(.systemFont(ofSize: 12, weight: .bold))
        $0.textColor = .init(white: 0.6, alpha: 1)
        $0.numberOfLines = 2
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with cast: Cast) {
        nameLabel.text = cast.name
        
        if let profilePath = cast.profilePath {
            loadProfilePath(profilePath)
        } else {
            imageView.image = UIImage(named: "avatar_placeholder")
        }
    }
    
    private func loadProfilePath(_ profilePath: String) {
        let imageUrlString = "https://image.tmdb.org/t/p/w500\(profilePath)"
        
        imageNetworkService.getImageFrom(imageUrlString) { [weak self] image in
            guard let image = image else { return }
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = image
            }
        }
    }
}
