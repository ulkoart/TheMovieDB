//
//  CoreDataStack.swift
//  TheMovieDB
//
//  Created by user on 22.11.2021.
//

import Foundation
import CoreData

final class CoreDataStack {
    
    private let container: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext { container.viewContext }
    let backgroundContext: NSManagedObjectContext
    
    init(modelName: String) {
        self.container = NSPersistentContainer(name: modelName)
        backgroundContext = self.container.newBackgroundContext()
        
//         viewContext.automaticallyMergesChangesFromParent = true
//         backgroundContext.automaticallyMergesChangesFromParent = true
//
//         backgroundContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
//         viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }
    
    func load() {
        container.loadPersistentStores { _, error in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
