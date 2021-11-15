//
//  TvSerialCreditsResponse.swift
//  TheMovieDB
//
//  Created by user on 15.11.2021.
//

import Foundation

struct TvSerialCreditsResponse: Codable {
    let cast, crew: [Cast]
    let id: Int
}
