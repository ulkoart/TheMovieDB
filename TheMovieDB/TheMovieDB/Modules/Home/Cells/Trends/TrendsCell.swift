//
//  TrendsCell.swift
//  TheMovieDB
//
//  Created by user on 25.10.2021.
//

import UIKit

final class TrendsCell: UITableViewCell {
    
    static let identifier = "TrendsCell"
    
    var movies: [Movie] = .init() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let titileLabel: UILabel = {
        $0.font = .init(.systemFont(ofSize: 24, weight: .bold))
        $0.textColor =  .black
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Тренды этой недели"
        return $0
    }(UILabel())
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TrendItem.self, forCellWithReuseIdentifier: TrendItem.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    private func configure() {
        contentView.addSubview(titileLabel)
        NSLayoutConstraint.activate([
            titileLabel.topAnchor.constraint(equalTo: topAnchor),
            titileLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titileLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titileLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        contentView.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titileLabel.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TrendsCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TrendItem.identifier, for: indexPath
        ) as? TrendItem else { fatalError() }
        let movie = movies[indexPath.item]
        cell.configure(with: movie)
        return cell
    }
}

extension TrendsCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.size.width - 16, height: frame.size.height - titileLabel.frame.size.height - 8 - 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    }
}
