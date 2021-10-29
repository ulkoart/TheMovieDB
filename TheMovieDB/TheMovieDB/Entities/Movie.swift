//
//  Movie.swift
//  TheMovieDB
//
//  Created by user on 26.10.2021.
//

import Foundation

enum MediaType: String, Codable {
    case movie = "movie"
    case tv = "tv"
    
    var ruValue: String {
        switch self {
        case .movie:
            return "кино"
        case .tv:
            return "сериал"
        }
    }
}

struct Movie: Decodable {
    let adult: Bool?
    let backdropPath: String
    let genreIDS: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle: String?
    let overview, posterPath: String
    let releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    let mediaType: MediaType
    let firstAirDate, originalName: String?
    let originCountry: [String]?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case popularity
        case mediaType = "media_type"
        case firstAirDate = "first_air_date"
        case originalName = "original_name"
        case originCountry = "origin_country"
        case name
    }
}
