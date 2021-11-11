//
//  MovieInfo.swift
//  TheMovieDB
//
//  Created by user on 11.11.2021.
//

import UIKit

final class MovieInfo: UITableViewCell {
    static let identifier = "MovieInfo"
    
    private let titleLabel: UILabel = {
        $0.font = .init(.systemFont(ofSize: 24, weight: .black))
        $0.textColor =  .black
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let voteLabel: UILabel = {
        $0.font = .init(.systemFont(ofSize: 14, weight: .semibold))
        $0.textColor =  .init(white: 0.4, alpha: 1)
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let yearGenresLabel: UILabel = {
        $0.font = .init(.systemFont(ofSize: 14, weight: .regular))
        $0.textColor =  .init(white: 0.6, alpha: 1)
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let stackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .fill
        $0.spacing = 2
        return $0
    }(UIStackView())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(voteLabel)
        stackView.addArrangedSubview(yearGenresLabel)
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(title: String, voteAverage: Double, releaseDate: String, genres: [Genre]) {
        titleLabel.text = title
        voteLabel.text = "\(voteAverage) TMDB"
        
        var releaseDateString = "дата релиза не известна"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-dd-mm"
        let releaseDate = dateFormatter.date(from: releaseDate)
        dateFormatter.dateFormat = "YYYY"
        
        if let releaseDate = releaseDate {
            releaseDateString = dateFormatter.string(from: releaseDate)
        }
        
        let genresString = genres.map { $0.name }.joined(separator: ", ")
        
        yearGenresLabel.text = "\(releaseDateString), \(genresString)"
    }
}
