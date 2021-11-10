//
//  Casts.swift
//  TheMovieDB
//
//  Created by user on 10.11.2021.
//

import UIKit

final class CastsCell: UITableViewCell {
    
    static let identifier = "CastsCell"
    
    var casts: [Cast] = .init() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let titileLabel: UILabel = {
        $0.font = .init(.systemFont(ofSize: 22, weight: .bold))
        $0.textColor =  .black
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Актеры"
        return $0
    }(UILabel())
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(CastsItem.self, forCellWithReuseIdentifier: CastsItem.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsHorizontalScrollIndicator = false
        collection.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
        configureTitileLabel()
        configureCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        contentView.heightAnchor.constraint(equalToConstant: 190 + 16).isActive = true
    }
    
    private func configureTitileLabel() {
        addSubview(titileLabel)
        
        titileLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titileLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        let titileLabelLeadingAnchorConstraint = titileLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        titileLabelLeadingAnchorConstraint.priority = UILayoutPriority(999)
        titileLabelLeadingAnchorConstraint.isActive = true
        
        let titileLabelTrailingAnchorConstraint = trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        titileLabelTrailingAnchorConstraint.priority = UILayoutPriority(999)
        titileLabelTrailingAnchorConstraint.isActive = true
    }
    
    private func configureCollectionView() {
        addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titileLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
            // collectionView.heightAnchor.constraint(equalToConstant: 140)
        ])
    }
}

extension CastsCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return casts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CastsItem.identifier, for: indexPath
        ) as? CastsItem else { fatalError() }
        let cast = casts[indexPath.item]
        cell.configure(with: cast)
        return cell
    }
}

extension CastsCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.25, height: collectionView.frame.height)
    }
}
