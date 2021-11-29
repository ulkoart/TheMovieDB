//
//  LoadMoreDelegate.swift
//  TheMovieDB
//
//  Created by user on 29.11.2021.
//

import Foundation

protocol LoadMoreDelegate: AnyObject {
    func loadMore(cellType: CellType)
}
