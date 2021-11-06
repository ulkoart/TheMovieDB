//
//  ImageNetworkService.swift
//  TheMovieDB
//
//  Created by user on 27.10.2021.
//

import UIKit

protocol ImageLoadServiceProtocol {
    typealias GetImageFromCompletion = (UIImage?) -> Void
    
    /// получить картинку по УРЛу (картинка? прилетает в замыкание)
    func getImageFrom(_ urlString: String, completion: @escaping GetImageFromCompletion)
}

final class ImageLoadService: ImageLoadServiceProtocol {
    
    static var shared: ImageLoadServiceProtocol = {
        let instance = ImageLoadService()
        return instance
    }()
    
    private let imageCacheService: ImageCacheServiceProtocol = ImageCacheService.shared
    
    private init() {}

    private func downloadImage(urlString: String, completion: @escaping GetImageFromCompletion) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let handler: URLSessionHandler = { [weak self] data, _, _ in
            guard
                let data = data,
                let image = UIImage(data: data)
            else {
                completion(nil)
                return
            }
            self?.imageCacheService.setCashedImage(image: image, url: urlString)
            completion(image)
        }
    
        URLSession.shared.dataTask(with: url, completionHandler: handler).resume()
    }
    
    func getImageFrom(_ urlString: String, completion: @escaping GetImageFromCompletion) {
        guard let cashedImage = imageCacheService.getCashedImage(url: urlString) else {
            downloadImage(urlString: urlString, completion: completion)
            return
        }
        completion(cashedImage)
    }
}
