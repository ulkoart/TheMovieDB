//
//  NetworkServiceError.swift
//  TheMovieDB
//
//  Created by user on 06.11.2021.
//

enum NetworkServiceError: Error {
    case unknown

    var message: String {
        switch self {
        case .unknown:
            return "unknown error"
        }
    }

}
