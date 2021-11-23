//
//  SearchMovieResponse.swift
//  TheMovieDB
//
//  Created by user on 28.10.2021.
//

import Foundation

struct SearchMovieResponse: Codable {
    let page: Int
    let results: [SearchMovie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
