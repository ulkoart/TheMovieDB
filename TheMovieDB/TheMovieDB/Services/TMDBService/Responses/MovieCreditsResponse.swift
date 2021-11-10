//
//  MovieCreditsResponse.swift
//  TheMovieDB
//
//  Created by user on 08.11.2021.
//

import Foundation

// MARK: - Welcome
struct MovieCreditsResponse: Codable {
    let id: Int
    let cast, crew: [Cast]
}

enum Department: String, Codable {
    case acting = "Acting"
    case art = "Art"
    case camera = "Camera"
    case costumeMakeUp = "Costume & Make-Up"
    case crew = "Crew"
    case directing = "Directing"
    case editing = "Editing"
    case lighting = "Lighting"
    case production = "Production"
    case sound = "Sound"
    case visualEffects = "Visual Effects"
    case writing = "Writing"
}
