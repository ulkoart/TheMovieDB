//
//  CellDidSelectItemAtDelegate.swift
//  TheMovieDB
//
//  Created by user on 29.11.2021.
//

import Foundation

protocol CellDidSelectItemAtDelegate: AnyObject {
    func didSelect(item: Int, mediaType: MediaType, cellType: CellType)
}
