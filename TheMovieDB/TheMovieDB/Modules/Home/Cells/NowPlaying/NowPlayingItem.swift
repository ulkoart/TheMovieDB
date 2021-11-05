//
//  NowPlayingItem.swift
//  TheMovieDB
//
//  Created by user on 27.10.2021.
//

import UIKit

final class NowPlayingItem: UICollectionViewCell {
    
    static let identifier = "NowPlayingItem"
    static let cornerRadius: CGFloat = 5
    
    private let imageNetworkService: ImageNetworkServiceProtocol = ImageNetworkService.shared
    
    private let imageView: UIImageView = {
        if let image = UIImage(named: "backdrop_placeholder") {
            $0.image = image
        }
        
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
        
        // ToDo добавить лэйбл с названием фильма
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with nowPlayingMovie: NowPlayingMovie) {
        let imageUrlString = "https://image.tmdb.org/t/p/w500\(nowPlayingMovie.posterPath)"
        
        imageNetworkService.getImageFrom(imageUrlString) { [weak self] image in
            guard let image = image else { return }
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = image
            }
        }
    }
}
