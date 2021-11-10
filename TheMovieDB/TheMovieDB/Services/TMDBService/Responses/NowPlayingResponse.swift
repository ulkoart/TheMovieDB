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
}
