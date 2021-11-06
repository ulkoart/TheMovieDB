//
//  MovieDetail.swift
//  TheMovieDB
//
//  Created by user on 05.11.2021.
//

import UIKit

final class MovieDetail: UITableViewCell {
    static let identifier = "MovieDetail"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
    }
}
