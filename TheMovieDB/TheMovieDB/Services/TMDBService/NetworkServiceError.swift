//
//  NetworkServiceError.swift
//  TheMovieDB
//
//  Created by user on 06.11.2021.
//

enum NetworkServiceError: Error {
    case unknown
    case network
    case badData

    var message: String {
        switch self {
        case .unknown:
            return "unknown error"
        case .badData:
            return "Json says no"
        case .network:
            return "Computer says no"
        }
    }

}
