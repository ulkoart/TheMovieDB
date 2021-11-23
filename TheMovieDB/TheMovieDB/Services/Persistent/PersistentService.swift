//
//  PersistentService.swift
//  TheMovieDB
//
//  Created by user on 22.11.2021.
//

import Foundation
import CoreData

final class PersistentService {
    static let shared = PersistentService()
    private init() {}

    lazy var coreDataStack = CoreDataStack(modelName: "TheMovieDB")
    
    func isFavorite(id: Int) -> Bool {
        let context = coreDataStack.viewContext
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        let predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.predicate = predicate
        let results = try? context.fetch(fetchRequest)
        if let results = results {
            return !results.isEmpty
        }
        return false
    }
    
    func removeFromFavorites(id: Int) {
        let context = coreDataStack.viewContext
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        fetchRequest.fetchLimit = 1
        let predicate = NSPredicate(format: "id == %d", Int64(id))
        fetchRequest.predicate = predicate
        let results = try? context.fetch(fetchRequest)
        guard let favorite = results?.first else { return}
        context.delete(favorite)
        try? context.save()
        return
    }
    
    func addToFavorite(id: Int, title: String) {
        if isFavorite(id: id) {
            return
        } else {
            let context = coreDataStack.viewContext
            let favorite = Favorite(context: context)
            favorite.id = Int64(id)
            favorite.title = title
            try? context.save()
        }
    }
}
