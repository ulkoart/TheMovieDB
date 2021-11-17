//
//  TrendingResponse.swift
//  TheMovieDB
//
//  Created by user on 26.10.2021.
//

import Foundation

/// Ответ с трендами, возвращаемый API
struct TrendingResponse: Decodable {
    let page: Int
    let results: [Trend]
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
    }
}
