//
//  Vote.swift
//  TheMovieDB
//
//  Created by user on 08.11.2021.
//

import UIKit

final class VoteBlock: UITableViewCell {
    static let identifier = "Vote"
    
    private let voteTitileLabel: UILabel = {
        $0.font = .init(.systemFont(ofSize: 22, weight: .bold))
        $0.textColor =  .black
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Рейтинг TMDB"
        return $0
    }(UILabel())
    
    private let voteView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .init(white: 0.9, alpha: 1)
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        return $0
    }(UIView())
    
    private let voteLabel: UILabel = {
        $0.font = .init(.systemFont(ofSize: 48, weight: .black))
        $0.textColor = .init(red: 85/255, green: 185/255, blue: 180/255, alpha: 1)
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let voteCountLabel: UILabel = {
        $0.font = .init(.systemFont(ofSize: 18, weight: .light))
        $0.textColor = .init(white: 0.6, alpha: 1)
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let voteStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 0
        return $0
    }(UIStackView())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureVoteTitileLabel()
        configureVoteView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(vote: Double, voteCount: Int) {
        voteLabel.text = "\(vote)"
        voteCountLabel.text = "голосов: \(voteCount)"
    }
    
    private func configureVoteTitileLabel() {
        addSubview(voteTitileLabel)
        
        voteTitileLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        voteTitileLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        let voteTitileLabelLeadingAnchorConstraint = voteTitileLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        voteTitileLabelLeadingAnchorConstraint.priority = UILayoutPriority(999)
        voteTitileLabelLeadingAnchorConstraint.isActive = true
        
        let voteTitileLabelTrailingAnchorConstraint = trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        voteTitileLabelTrailingAnchorConstraint.priority = UILayoutPriority(999)
        voteTitileLabelTrailingAnchorConstraint.isActive = true
    }
    
    private func configureVoteView() {
        addSubview(voteView)
        
        voteView.topAnchor.constraint(equalTo: voteTitileLabel.bottomAnchor, constant: 16).isActive = true
        voteView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        voteView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        let voteViewLabelLeadingAnchorConstraint = voteView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        voteViewLabelLeadingAnchorConstraint.priority = UILayoutPriority(999)
        voteViewLabelLeadingAnchorConstraint.isActive = true
        
        let voteViewLabelTrailingAnchorConstraint = voteView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        voteViewLabelTrailingAnchorConstraint.priority = UILayoutPriority(999)
        voteViewLabelTrailingAnchorConstraint.isActive = true
        
        voteStackView.addArrangedSubview(voteLabel)
        voteStackView.addArrangedSubview(voteCountLabel)
        voteView.addSubview(voteStackView)
        
        NSLayoutConstraint.activate([
            voteStackView.centerXAnchor.constraint(equalTo: voteView.centerXAnchor),
            voteStackView.centerYAnchor.constraint(equalTo: voteView.centerYAnchor)
        ])
    }
}
