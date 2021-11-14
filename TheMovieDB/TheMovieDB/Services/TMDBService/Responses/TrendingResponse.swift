//
//  TrendingResponse.swift
//  TheMovieDB
//
//  Created by user on 26.10.2021.
//

import Foundation

/// Ответ с трендами, возвращаемый API
struct TrendingResponse: Decodable {
    let page: String
    let results: [Trend]
}
