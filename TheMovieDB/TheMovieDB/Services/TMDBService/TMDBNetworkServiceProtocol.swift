//
//  TMDBNetworkServiceProtocol.swift
//  TheMovieDB
//
//  Created by user on 06.11.2021.
//

import Foundation

typealias URLSessionHandler = (Data?, URLResponse?, Error?) -> Void
typealias GetTrendingResponse = ([Trend], Error?) -> Void
typealias GetNowPlayingResponse = ([NowPlayingMovie], Error?) -> Void
typealias GetTvPopularResponse = ([TvPopular], Error?) -> Void
typealias GetSearchMovieResponse = ([SearchMovie], Error?) -> Void

/// С использованием Result
typealias GetMovieDetailResponse = Result<MovieDetailResponse, NetworkServiceError>
typealias GetMovieCreditsResponse = Result<MovieCreditsResponse, NetworkServiceError>

protocol TMDBNetworkServiceProtocol {
    
    /// Получение списка стендов
    /// - Parameter completion: ([Movie], Error?) -> Void
    func getTrending(completion: @escaping GetTrendingResponse)
    
    /// Получение списка фильмов идущих в кино в данный момент
    /// - Parameter completion: ([NowPlayingMovie], Error?) -> Void
    func getNowPlaying(page: Int, completion: @escaping GetNowPlayingResponse)
    
    /// Получение списка популярных сериалов
    /// - Parameter completion: ([TvPopular], Error?) -> Void
    func getTvPopular(completion: @escaping GetTvPopularResponse)
    
    /// Получение списка фильмов по поисковому запросу
    /// - Parameters:
    ///   - query: поисковой запрос
    ///   - completion: ([SearchMovie], Error?) -> Void
    func searchMovie(query: String, completion: @escaping GetSearchMovieResponse)
    
    /// Получение детальной информации о фильме
    /// - Parameters:
    ///   - movieId: ID фильма
    ///   - completion: Result<MovieDetailResponse, NetworkServiceError>
    func getMovieDetail(movieId: Int, completion: @escaping (GetMovieDetailResponse) -> Void)
    
    /// Получение списка актеров фильма
    /// - Parameters:
    ///   - movieId: ID фильма
    ///   - completion: Result<MovieCreditsResponse, NetworkServiceError>
    func getMovieCredits(movieId: Int, completion: @escaping (GetMovieCreditsResponse) -> Void)
}
