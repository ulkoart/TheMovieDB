//
//  MDBNetworkService.swift
//  TheMovieDB
//
//  Created by user on 26.10.2021.
//

import Foundation

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
        
        /// возвращает собранный url (опциональный)
        private func makeUrl(path: String, queryItems: [URLQueryItem] = []) -> URL? {
            var components = URLComponents()
            components.scheme = "https"
            components.host = Endpoints.baseUrl
            components.path = "/\(Endpoints.apiVersion)\(path)"
            components.queryItems = queryItems
            
            return components.url
        }
        
        case getTrending(Int)
        case getNowPlaying(Int)
        case getTvPopular(Int)
        case searchMovie(String, Bool)
        case getMovieDetail(Int)
        case getMovieCredits(Int)
        case getTvSerialDetail(Int)
        case getTvSerialCredits(Int)
        
        var url: URL? {
            switch self {
            /// url трендов текущей недели
            case .getTrending(let page):
                let queryItems = [
                    URLQueryItem(name: "page", value: "\(page)")
                ] + Endpoints.defaultQueryItems
                let path = "/trending/all/week"
                return makeUrl(path: path, queryItems: queryItems)
            
            /// url фильмов идущих в кино
            case .getNowPlaying(let page):
                let queryItems = [
                    URLQueryItem(name: "page", value: "\(page)")
                ] + Endpoints.defaultQueryItems
                let path = "/movie/now_playing"
                return makeUrl(path: path, queryItems: queryItems)
            
            /// url популярных сериалов
            case .getTvPopular(let page):
                let path = "/tv/popular"
                let queryItems = [
                    URLQueryItem(name: "page", value: "\(page)")
                ] + Endpoints.defaultQueryItems
                return makeUrl(path: path, queryItems: queryItems)
            
            /// url для поиска фильмов
            case .searchMovie(let query, let includeAdult):
                let path = "/search/movie"
                
                let queryItems = [
                    URLQueryItem(name: "query", value: query),
                    URLQueryItem(name: "include_adult", value: includeAdult ? "true": "false")
                ] + Endpoints.defaultQueryItems
                
                return makeUrl(path: path, queryItems: queryItems)
            
            /// url для деталей фильмов
            case .getMovieDetail(let movieId):
                let path = "/movie/\(movieId)"
                return makeUrl(path: path, queryItems: Endpoints.defaultQueryItems)
            
            /// url для получения актеров и персонала фильма
            case .getMovieCredits(let movieId):
                let path = "/movie/\(movieId)/credits"
                return makeUrl(path: path, queryItems: Endpoints.defaultQueryItems)
            
            /// url для деталей фильмов
            case .getTvSerialDetail(let tvSerialId):
                let path = "/tv/\(tvSerialId)"
                return makeUrl(path: path, queryItems: Endpoints.defaultQueryItems)
            
            /// url для получения актеров и персонала сериала
            case .getTvSerialCredits(let tvSerialId):
                let path = "/tv/\(tvSerialId)/credits"
                return makeUrl(path: path, queryItems: Endpoints.defaultQueryItems)
            }
        }
    }
    
    private func GETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let handler: URLSessionHandler = { data, response, _ in
            
            guard
                let data = data,
                let httpResponse = response as? HTTPURLResponse,
                (200..<300).contains(httpResponse.statusCode)
            else {
                completion(nil, NetworkServiceError.network)
                return
            }
            
            do {
                let decodedObject = try self.decoder.decode(responseType, from: data)
                completion(decodedObject, nil)
            } catch {
                completion(nil, NetworkServiceError.badData)
            }
        }
        let task = session.dataTask(with: url, completionHandler: handler)
        task.resume()
        // DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ) { task.resume() }
    }
}

extension TMDBNetworkService: TMDBNetworkServiceProtocol {
    
    func getTrending(page: Int, completion: @escaping (GetTrendingResponse) -> Void) {
        guard let url = Endpoints.getTrending(page).url else { return }
        GETRequest(url: url, responseType: TrendingResponse.self) { trendingResponse, error in
            if let error = error {
                completion(.failure(error as? NetworkServiceError ?? .unknown))
            } else {
                guard let trendingResponse = trendingResponse else { fatalError() }
                completion(.success(trendingResponse))
            }
        }
    }
    
    func getNowPlaying(page: Int, completion: @escaping (GetNowPlayingResponse) -> Void) {
        guard let url = Endpoints.getNowPlaying(page).url else { return }
        GETRequest(url: url, responseType: NowPlayingResponse.self) { nowPlayingResponse, _ in
            guard let nowPlayingResponse = nowPlayingResponse else { fatalError() }
            completion(.success(nowPlayingResponse))
        }
    }
    
    func getTvPopular(page: Int, completion: @escaping (GetTvPopularResponse) -> Void) {
        guard let url = Endpoints.getTvPopular(page).url else { return }
        GETRequest(url: url, responseType: TvPopularResponse.self) { tvPopularResponse, _ in
            guard let tvPopularResponse = tvPopularResponse else { fatalError() }
            completion(.success(tvPopularResponse))
        }
    }
    
    func searchMovie(query: String, includeAdult: Bool, completion: @escaping (GetSearchMovieResponse) -> Void) {
        guard let url = Endpoints.searchMovie(query, includeAdult).url else { return }
        GETRequest(url: url, responseType: SearchMovieResponse.self) { searchMovieResponse, error in
            guard let searchMovieResponse = searchMovieResponse else {
                completion(.failure(error as? NetworkServiceError ?? .unknown))
                return
            }
            completion(.success(searchMovieResponse))
        }
    }
    
    func getMovieDetail(movieId: Int, completion: @escaping (GetMovieDetailResponse) -> Void) {
        guard let url = Endpoints.getMovieDetail(movieId).url else { return }
        GETRequest(url: url, responseType: MovieDetailResponse.self.self) { getMovieDetailResponse, error in
            if let error = error {
                completion(.failure(error as? NetworkServiceError ?? .unknown))
            } else {
                guard let getMovieDetailResponse = getMovieDetailResponse else {
                    completion(.failure(.unknown))
                    return
                }
                completion(.success(getMovieDetailResponse))
            }
        }
    }
    
    func getMovieCredits(movieId: Int, completion: @escaping (GetMovieCreditsResponse) -> Void) {
        guard let url = Endpoints.getMovieCredits(movieId).url else { return }
        GETRequest(url: url, responseType: MovieCreditsResponse.self.self) { getMovieCreditsResponse, _ in
            guard let getMovieCreditsResponse = getMovieCreditsResponse else {
                completion(.failure(.unknown))
                return
            }
            completion(.success(getMovieCreditsResponse))
        }
    }
    
    func getTvSerialDetail(tvSerialId: Int, completion: @escaping (GetTvSerialDetailResponse) -> Void) {
        guard let url = Endpoints.getTvSerialDetail(tvSerialId).url else { return }
        GETRequest(url: url, responseType: TvSerialDetailResponse.self) { getTvSerialDetailResponse, error in
            if let error = error {
                completion(.failure(error as? NetworkServiceError ?? .unknown))
            } else {
                guard let getTvSerialDetailResponse = getTvSerialDetailResponse else {
                    completion(.failure(.unknown))
                    return
                }
                completion(.success(getTvSerialDetailResponse))
            }
        }
    }
    
    func getTvSerialCredits(tvSerialId: Int, completion: @escaping (GetTvSerialCreditsResponse) -> Void) {
        guard let url = Endpoints.getTvSerialCredits(tvSerialId).url else { return }
        GETRequest(url: url, responseType: TvSerialCreditsResponse.self.self) { getMovieCreditsResponse, error in
            guard let getMovieCreditsResponse = getMovieCreditsResponse else {
                completion(.failure(error as? NetworkServiceError ?? .unknown))
                return
            }
            completion(.success(getMovieCreditsResponse))
        }
    }
}
