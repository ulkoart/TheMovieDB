//
//  MovieTest.swift
//  TheMovieDBTests
//
//  Created by user on 08.12.2021.
//

import XCTest
@testable import TheMovieDB

class NetworkServiceMock: TMDBNetworkServiceProtocol {
    func getTrending(page: Int, completion: @escaping (GetTrendingResponse) -> Void) {
        
    }
    
    func getNowPlaying(page: Int, completion: @escaping (GetNowPlayingResponse) -> Void) {
        
    }
    
    func getTvPopular(page: Int, completion: @escaping (GetTvPopularResponse) -> Void) {
        
    }
    
    func searchMovie(query: String, includeAdult: Bool, completion: @escaping (GetSearchMovieResponse) -> Void) {
        
    }
    
    func getMovieDetail(movieId: Int, completion: @escaping (GetMovieDetailResponse) -> Void) {

    }
    
    func getMovieCredits(movieId: Int, completion: @escaping (GetMovieCreditsResponse) -> Void) {
        
    }
    
    func getTvSerialDetail(tvSerialId: Int, completion: @escaping (GetTvSerialDetailResponse) -> Void) {
        
    }
    
    func getTvSerialCredits(tvSerialId: Int, completion: @escaping (GetTvSerialCreditsResponse) -> Void) {
        
    }
    
}

class MovieTest: XCTestCase {
    
    var networkService: TMDBNetworkServiceProtocol?
    var viewController: MovieViewControllerProtocol?
    var router: MovieRouter?

    override func setUpWithError() throws {
        router = MovieRouter()
        viewController = MovieRouter.createModule(with: 1)
        
        let networkServiceMock = NetworkServiceMock()
        viewController?.presenter?.interactor?.networkService = networkServiceMock
    }
    
    func testModuleNotNil() {
        XCTAssertNotNil(viewController, "viewController is nil")
        XCTAssertNotNil(viewController?.presenter, "presenter is nil")
        XCTAssertNotNil(viewController?.presenter?.interactor, "interactor is nil")
        XCTAssertNotNil(router, "router is nil")
    }

    override func tearDownWithError() throws {
       viewController = nil
         router = nil
    }
}
