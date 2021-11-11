//
//  CrewsItem.swift
//  TheMovieDB
//
//  Created by user on 10.11.2021.
//

import UIKit

final class CrewsItem: UICollectionViewCell {
    
    static let identifier = "CrewsItem"
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
    
    private let departmentLabel: UILabel = {
        $0.font = .init(.systemFont(ofSize: 12, weight: .regular))
        $0.textColor = .init(white: 0.7, alpha: 1)
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textAlignment = .left
        return $0
    }(UILabel())
    
    private let infoStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .fillProportionally
        $0.spacing = 0
        return $0
    }(UIStackView())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        infoStackView.addArrangedSubview(nameLabel)
        infoStackView.addArrangedSubview(departmentLabel)
        addSubview(infoStackView)
        
        NSLayoutConstraint.activate([
            infoStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            infoStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        departmentLabel.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with cast: Cast) {
        nameLabel.text = cast.name
        if let department = cast.department {
            departmentLabel.text = "\(department.rawValue)"
        }
        
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
