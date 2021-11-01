//
//  MovieRouter.swift
//  TheMovieDB
//
//  Created by user on 01.11.2021.
//

import UIKit

protocol MovieRouterProtocol: AnyObject {
    static func createModule(with movie: Movie) -> UIViewController
}

final class MovieRouter: MovieRouterProtocol {
    
    static func createModule(with movie: Movie) -> UIViewController {
        let viewController = MovieViewController(movie: movie)
        
        return viewController
    }
}
