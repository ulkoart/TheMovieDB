//
//  MDBNetworkService.swift
//  TheMovieDB
//
//  Created by user on 26.10.2021.
//

import Foundation

typealias URLSessionHandler = (Data?, URLResponse?, Error?) -> Void
typealias GetTrendingResponse = ([Movie], Error?) -> Void
typealias GetNowPlayingResponse = ([NowPlayingMovie], Error?) -> Void
typealias GetTvPopularResponse = ([TvPopular], Error?) -> Void
typealias GetSearchMovieResponse = ([SearchMovie], Error?) -> Void

protocol TMDBNetworkServiceProtocol {
    
    /// Получение списка стендов
    /// - Parameter completion: ([Movie], Error?) -> Void
    func getTrending(completion: @escaping GetTrendingResponse)
    
    /// Получение списка фильмов идущих в кино в данный момент
    /// - Parameter completion: ([NowPlayingMovie], Error?) -> Void
    func getNowPlaying(completion: @escaping GetNowPlayingResponse)
    
    /// Получение списка популярных сериалов
    /// - Parameter completion: ([TvPopular], Error?) -> Void
    func getTvPopular(completion: @escaping GetTvPopularResponse)
    
    /// Получение списка фильмов по поисковому запросу
    /// - Parameters:
    ///   - query: поисковой запрос
    ///   - completion: ([SearchMovie], Error?) -> Void
    func searchMovie(query: String, completion: @escaping GetSearchMovieResponse)
}

final class TMDBNetworkService {
    
    static let shared: TMDBNetworkServiceProtocol = TMDBNetworkService()
    private init() {}
    
    /// кастом сессия зачем
    private let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    /// декодер без стратегий вся фигня через CodingKeys разруливается
    private let decoder: JSONDecoder = JSONDecoder()
    
    /// Список эндпоинтов API
    private enum Endpoints {
        static let apiKey: String = "38a73d59546aa378980a88b645f487fc"
        static let baseUrl: String = "api.themoviedb.org"
        static let apiVersion: Int = 3
        static let defaultQueryItems = [
            URLQueryItem(name: "api_key", value: Endpoints.apiKey),
            URLQueryItem(name: "language", value: "ru-RU")
        ]
        
        private func makeUrl(path: String, queryItems: [URLQueryItem] = []) -> URL? {
            var components = URLComponents()
            components.scheme = "https"
            components.host = Endpoints.baseUrl
            components.path = "/\(Endpoints.apiVersion)\(path)"
            components.queryItems = queryItems
            
            return components.url
        }
        
        case getTrending
        case getNowPlaying
        case getTvPopular
        case searchMovie(String)
        
        var url: URL? {
            switch self {
            
            case .getTrending:
                let path = "/trending/all/week"
                return makeUrl(path: path, queryItems: Endpoints.defaultQueryItems)
            
            case .getNowPlaying:
                let path = "/movie/now_playing"
                return makeUrl(path: path, queryItems: Endpoints.defaultQueryItems)
            
            case .getTvPopular:
                let path = "/tv/popular"
                return makeUrl(path: path, queryItems: Endpoints.defaultQueryItems)
            
            case .searchMovie(let query):
                let path = "/search/movie"
                
                let queryItems = [
                    URLQueryItem(name: "query", value: query)
                ] + Endpoints.defaultQueryItems
                    
                return makeUrl(path: path, queryItems: queryItems)
            }
            
        }
    }
    
    private func GETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let handler: URLSessionHandler = { data, _, _ in
            guard let data = data else { fatalError() }
            
            do {
                let decodedObject = try self.decoder.decode(responseType, from: data)
                completion(decodedObject, nil)
            } catch {
                fatalError()
            }
        }
        let task = session.dataTask(with: url, completionHandler: handler)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1 ) {
            task.resume()
        }
    }
}

extension TMDBNetworkService: TMDBNetworkServiceProtocol {
    func getTrending(completion: @escaping GetTrendingResponse) {
        guard let url = Endpoints.getTrending.url else { return }
        
        GETRequest(url: url, responseType: TrendingResponse.self) { trendingResponse, _ in
            guard let trendingResponse = trendingResponse else { fatalError() }
            completion(trendingResponse.results, nil)
        }
    }
    
    func getNowPlaying(completion: @escaping GetNowPlayingResponse) {
        guard let url = Endpoints.getNowPlaying.url else { return }
        
        GETRequest(url: url, responseType: NowPlayingResponse.self) { nowPlayingResponse, _ in
            guard let nowPlayingResponse = nowPlayingResponse else { fatalError() }
            completion(nowPlayingResponse.results, nil)
        }
    }
    
    func getTvPopular(completion: @escaping GetTvPopularResponse) {
        guard let url = Endpoints.getTvPopular.url else { return }
        
        GETRequest(url: url, responseType: TvPopularResponse.self) { tvPopularResponse, _ in
            guard let tvPopularResponse = tvPopularResponse else { fatalError() }
            completion(tvPopularResponse.results, nil)
        }
    }
    
    func searchMovie(query: String, completion: @escaping GetSearchMovieResponse) {
        guard let url = Endpoints.searchMovie(query).url else { return }
        
        GETRequest(url: url, responseType: SearchMovieResponse.self) { searchMovieResponse, _ in
            guard let searchMovieResponse = searchMovieResponse else { fatalError() }
            completion(searchMovieResponse.results, nil)
        }
    }
}
