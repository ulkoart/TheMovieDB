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
            return "Computer says no"
        case .badData:
            return "Json says no"
        case .network:
            return "Network says no"
        }
    }

}
