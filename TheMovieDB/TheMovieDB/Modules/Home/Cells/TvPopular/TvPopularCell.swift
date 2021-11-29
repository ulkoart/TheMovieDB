//
//  TvPopularCell.swift
//  TheMovieDB
//
//  Created by user on 28.10.2021.
//

import UIKit

final class TvPopularCell: UITableViewCell {
    
    static let identifier = "TvPopularCell"
    
    /// делегат обрабатывающий нажатия на ячейку
    weak var delegate: CellDidSelectItemAtDelegate?
    
    /// делегат для подругзки новых страниц
    weak var loadMoreDelegate: LoadMoreDelegate?
    
    var tvPopulars: [TvPopular] = .init() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let titileLabel: UILabel = {
        $0.font = .init(.systemFont(ofSize: 24, weight: .bold))
        $0.textColor =  .black
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Популярные сериалы"
        return $0
    }(UILabel())
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TvPopularItem.self, forCellWithReuseIdentifier: TvPopularItem.identifier)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsHorizontalScrollIndicator = false
        collection.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        contentView.addSubview(titileLabel)
        NSLayoutConstraint.activate([
            titileLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
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
}

extension TvPopularCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tvPopulars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TvPopularItem.identifier, for: indexPath
        ) as? TvPopularItem else { fatalError() }
        let tvPopular = tvPopulars[indexPath.item]
        cell.configure(with: tvPopular)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.row == tvPopulars.count - 3 else { return }
        loadMoreDelegate?.loadMore(cellType: .tvPopular)
    }
}

extension TvPopularCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelect(item: indexPath.item, mediaType: .tvSerial, cellType: .tvPopular)
    }
}

extension TvPopularCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2, height: collectionView.frame.height)
    }
}
