//
//  NowPlayingResponse.swift
//  TheMovieDB
//
//  Created by user on 27.10.2021.
//

import Foundation

/// Ответ с фильмами в кино, возвращаемый API
struct NowPlayingResponse: Decodable {
    let page: Int
    let results: [NowPlayingMovie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
