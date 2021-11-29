//
//  SearchCell.swift
//  TheMovieDB
//
//  Created by user on 29.11.2021.
//

import UIKit

final class SearchCell: UITableViewCell {
    
    static let identifier = "UITableViewCell"
    
    private let imageNetworkService: ImageLoadServiceProtocol = ImageLoadService.shared
    
    private let searchImageView: UIImageView = {
        $0.backgroundColor = .init(white: 0.8, alpha: 1)
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 5
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIImageView())
    
    private let stackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fillProportionally
        $0.spacing = 2
        return $0
    }(UIStackView())
    
    private let titleLabel: UILabel = {
        $0.font = .init(.systemFont(ofSize: 18, weight: .black))
        $0.textColor =  .init(white: 0.4, alpha: 1)
        $0.numberOfLines = 2
        $0.textAlignment = .left
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let yearLabel: UILabel = {
        $0.font = .init(.systemFont(ofSize: 14, weight: .semibold))
        $0.textColor =  .init(white: 0.6, alpha: 1)
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(searchImageView)
        NSLayoutConstraint.activate([
            searchImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            searchImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            searchImageView.heightAnchor.constraint(equalToConstant: 120),
            searchImageView.widthAnchor.constraint(equalToConstant: 80),
            searchImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: searchImageView.trailingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(yearLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        yearLabel.text = nil
        searchImageView.image = nil
    }
    
    func configure(with searchMovie: SearchMovie) {
        titleLabel.text = searchMovie.title
        yearLabel.text = String(searchMovie.releaseDate.prefix(4))

        guard let posterPath = searchMovie.posterPath else {
            return
        }
        
        let imageUrlString = "https://image.tmdb.org/t/p/w500\(posterPath)"
        
        imageNetworkService.getImageFrom(imageUrlString) { [weak self] image in
            guard let image = image else { return }
            DispatchQueue.main.async { [weak self] in
                self?.searchImageView.image = image
            }
        }
    }
}
