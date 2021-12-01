//
//  Favorite+CoreDataProperties.swift
//  TheMovieDB
//
//  Created by user on 26.11.2021.
//
//

import Foundation
import CoreData

extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var image: Data?

}

extension Favorite: Identifiable {

}
