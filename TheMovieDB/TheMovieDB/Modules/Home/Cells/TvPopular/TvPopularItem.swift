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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = TrendItem.cornerRadius
        
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor)
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
