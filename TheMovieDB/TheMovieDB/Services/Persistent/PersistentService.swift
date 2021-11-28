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
        saveContext()
    }
    
    func addToFavorite(id: Int, title: String, movieImageData: Data) {
        let context = coreDataStack.viewContext
        let favorite = Favorite(context: context)
        favorite.id = Int64(id)
        favorite.title = title
        favorite.image = movieImageData
        saveContext()
    }
    
    func resetFavorites(complition: () -> Void) {
        let context = coreDataStack.viewContext
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: Favorite.fetchRequest())
        deleteRequest.resultType = .resultTypeCount
        _ = try? context.execute(deleteRequest)
        context.reset()
        complition()
    }
    
    private func saveContext () {
        let context = coreDataStack.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
