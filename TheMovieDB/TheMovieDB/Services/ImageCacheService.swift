//
//  ImageCacheService.swift
//  TheMovieDB
//
//  Created by user on 27.10.2021.
//

import UIKit

protocol ImageCacheServiceProtocol {
    func getCashedImage(url: String) -> UIImage?
    func setCashedImage(image: UIImage, url: String) -> Void
}

class ImageCacheService: ImageCacheServiceProtocol {
    private let imageCache = NSCache<NSString, UIImage>()
    
    static var shared: ImageCacheService = {
        let instance = ImageCacheService()
        return instance
    }()
    
    private init() {}
    
    func getCashedImage(url: String) -> UIImage? {
        return imageCache.object(forKey: url as NSString)
    }
    
    func setCashedImage(image: UIImage, url: String) -> Void {
        self.imageCache.setObject(image, forKey: url as NSString)
    }
}
