//
//  NowPlayingCell.swift
//  TheMovieDB
//
//  Created by user on 27.10.2021.
//

import UIKit

protocol NowPlayingCellLoadMoreDelegate: AnyObject {
    func loadMoreNowPlaying()
}

class NowPlayingCell: UITableViewCell {
    
    static let identifier = "NowPlayingCell"
    
    /// делегат для подругзки новых страниц
    var loadMoreDelegat: NowPlayingCellLoadMoreDelegate?
    
    var nowPlaying: [NowPlayingMovie] = .init() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let titileLabel: UILabel = {
        $0.font = .init(.systemFont(ofSize: 24, weight: .bold))
        $0.textColor =  .black
        $0.numberOfLines = 1
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Сейчас в кино"
        return $0
    }(UILabel())
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(NowPlayingItem.self, forCellWithReuseIdentifier: NowPlayingItem.identifier)
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
            collectionView.topAnchor.constraint(equalTo: titileLabel.bottomAnchor, constant: 4),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension NowPlayingCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        nowPlaying.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NowPlayingItem.identifier, for: indexPath
        ) as? NowPlayingItem else { fatalError() }
        let nowPlayingMovie = nowPlaying[indexPath.item]
        cell.configure(with: nowPlayingMovie)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.row == nowPlaying.count - 3 else { return }
        loadMoreDelegat?.loadMoreNowPlaying()
    }
}

extension NowPlayingCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/4, height: collectionView.frame.height * 0.9)
    }
}
