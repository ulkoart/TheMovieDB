//
//  MovieDetail.swift
//  TheMovieDB
//
//  Created by user on 05.11.2021.
//

import UIKit

final class MovieDetail: UITableViewCell {
    static let identifier = "MovieDetail"
    
    private let overviewLabel: UILabel = {
        $0.font = .init(.systemFont(ofSize: 16, weight: .regular))
        $0.textColor = .init(white: 0.2, alpha: 1)
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        return $0
    }(UILabel())

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureOverviewLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureOverviewLabel() {
        addSubview(overviewLabel)
        overviewLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        overviewLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        let overviewLabelLeadingAnchorConstraint = overviewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        overviewLabelLeadingAnchorConstraint.priority = UILayoutPriority(999)
        overviewLabelLeadingAnchorConstraint.isActive = true
        
        let overviewLabelTrailingAnchorConstraint = overviewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        overviewLabelTrailingAnchorConstraint.priority = UILayoutPriority(999)
        overviewLabelTrailingAnchorConstraint.isActive = true
    }
    
    func configure(overview: String) {
        overviewLabel.text = overview
    }
}
