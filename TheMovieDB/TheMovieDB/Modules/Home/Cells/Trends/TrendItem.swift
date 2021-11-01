//
//  TrendItemCell.swift
//  TheMovieDB
//
//  Created by user on 25.10.2021.
//

import UIKit

final class TrendItem: UICollectionViewCell {
    
    static let identifier = "TrendItem"
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
    
    private let titileLabel: UILabel = {
        $0.font = .init(.systemFont(ofSize: 28, weight: .semibold))
        $0.textColor =  .white
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let voteAverageLabel: UILabel = {
        $0.font = .init(.systemFont(ofSize: 15, weight: .bold))
        $0.textColor =  .white
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .lightGray
        $0.textAlignment = .center
        $0.layer.cornerRadius = cornerRadius
        $0.layer.masksToBounds = true
        return $0
    }(UILabel())
    
    private let mediaTypeLabel: UILabel = {
        $0.font = .init(.systemFont(ofSize: 15, weight: .bold))
        $0.textColor =  .white
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .lightGray
        $0.textAlignment = .center
        $0.layer.cornerRadius = cornerRadius
        $0.layer.masksToBounds = true
        return $0
    }(UILabel())
    
    private let gradientView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = cornerRadius
        return $0
    }(UIView())
    
    private let gradientLayer: CAGradientLayer = {
        $0.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        $0.startPoint = CGPoint(x: 0, y: 0)
        $0.endPoint = CGPoint(x: 0, y: 1)
        return $0
    }(CAGradientLayer())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = TrendItem.cornerRadius
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 2, height: 2)
        
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
        
        addSubview(gradientView)
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(equalTo: leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: bottomAnchor),
            gradientView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/2)
        ])
        
        addSubview(titileLabel)
        NSLayoutConstraint.activate([
            titileLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            titileLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titileLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
        addSubview(voteAverageLabel)
        NSLayoutConstraint.activate([
            voteAverageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            voteAverageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            voteAverageLabel.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        addSubview(mediaTypeLabel)
        NSLayoutConstraint.activate([
            mediaTypeLabel.leadingAnchor.constraint(equalTo: voteAverageLabel.trailingAnchor, constant: 4),
            mediaTypeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            mediaTypeLabel.widthAnchor.constraint(equalToConstant: 64),
            mediaTypeLabel.heightAnchor.constraint(equalTo: voteAverageLabel.heightAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = gradientView.bounds
    }
    
    func configure(with movie: Movie) {
        titileLabel.text = movie.name ?? movie.title
        voteAverageLabel.text = "\(movie.voteAverage)"
        
        if movie.voteAverage >= 8.0 {
            voteAverageLabel.backgroundColor = .systemGreen
        } else {
            voteAverageLabel.backgroundColor = .lightGray
        }
        
        mediaTypeLabel.text = movie.mediaType.ruValue
        
        let imageUrlString = "https://image.tmdb.org/t/p/w500\(movie.backdropPath)"
        
        imageNetworkService.getImageFrom(imageUrlString) { [weak self] image in
            guard let image = image else { return }
            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = image
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
