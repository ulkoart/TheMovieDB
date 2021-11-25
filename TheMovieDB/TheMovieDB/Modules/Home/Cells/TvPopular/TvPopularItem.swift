//
//  TvPopularItem.swift
//  TheMovieDB
//
//  Created by user on 28.10.2021.
//

import UIKit

final class TvPopularItem: UICollectionViewCell {
    
    static let identifier = "TvPopularItem"
    static let cornerRadius: CGFloat = 5
    
    private let imageNetworkService: ImageLoadServiceProtocol = ImageLoadService.shared
    
    private let imageView: UIImageView = {
        $0.backgroundColor = .init(white: 0.8, alpha: 1)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = cornerRadius
        $0.contentMode = .scaleToFill
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private let titleLabel: UILabel = {
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
            imageView.heightAnchor.constraint(equalToConstant: 110)
        ])
        
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
    func configure(with tvPopular: TvPopular) {
        
        titleLabel.text = tvPopular.name
        
        if let backdropPath = tvPopular.backdropPath {
            let imageUrlString = "https://image.tmdb.org/t/p/w500\(backdropPath)"
            imageNetworkService.getImageFrom(imageUrlString) { [weak self] image in
                guard let image = image else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.imageView.image = image
                }
            }
        } else {
            let image = UIImage(named: "backdrop_placeholder")
            self.imageView.image = image
        }
    }
}
