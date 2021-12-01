//
//  TMDBNetworkServiceProtocol.swift
//  TheMovieDB
//
//  Created by user on 06.11.2021.
//

import Foundation

typealias URLSessionHandler = (Data?, URLResponse?, Error?) -> Void

typealias GetTrendingResponse = Result<TrendingResponse, NetworkServiceError>
typealias GetNowPlayingResponse = Result<NowPlayingResponse, NetworkServiceError>
typealias GetTvPopularResponse = Result<TvPopularResponse, NetworkServiceError>
typealias GetSearchMovieResponse = Result<SearchMovieResponse, NetworkServiceError>
typealias GetMovieDetailResponse = Result<MovieDetailResponse, NetworkServiceError>
typealias GetMovieCreditsResponse = Result<MovieCreditsResponse, NetworkServiceError>
typealias GetTvSerialDetailResponse = Result<TvSerialDetailResponse, NetworkServiceError>
typealias GetTvSerialCreditsResponse = Result<TvSerialCreditsResponse, NetworkServiceError>

protocol TMDBNetworkServiceProtocol {
    
    /// Получение списка стендов
    /// - Parameter page: номер страницы
    /// - Parameter completion: ([Movie], Error?) -> Void
    func getTrending(page: Int, completion: @escaping (GetTrendingResponse) -> Void)
    
    /// Получение списка фильмов идущих в кино в данный момент
    /// - Parameter page: номер страницы
    /// - Parameter completion: ([NowPlayingMovie], Error?) -> Void
    func getNowPlaying(page: Int, completion: @escaping (GetNowPlayingResponse) -> Void)
    
    /// Получение списка популярных сериалов
    /// - Parameter page: номер страницы
    /// - Parameter completion: ([TvPopular], Error?) -> Void
    func getTvPopular(page: Int, completion: @escaping (GetTvPopularResponse) -> Void)
    
    /// Получение списка фильмов по поисковому запросу
    /// - Parameters:
    ///   - query: поисковой запрос
    ///   - completion: ([SearchMovie], Error?) -> Void
    func searchMovie(query: String, completion: @escaping (GetSearchMovieResponse) -> Void)
    
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
    
    /// Получение детальной информации о сериале
    /// - Parameters:
    ///   - movieId: ID сериала
    ///   - completion: Result<TvSerialDetailResponse, NetworkServiceError>
    func getTvSerialDetail(tvSerialId: Int, completion: @escaping (GetTvSerialDetailResponse) -> Void)
    
    /// Получение списка актеров сериала
    /// - Parameters:
    ///   - movieId: ID сериала
    ///   - completion: Result<TvSerialCreditsResponse, NetworkServiceError>
    func getTvSerialCredits(tvSerialId: Int, completion: @escaping (GetTvSerialCreditsResponse) -> Void)
}
