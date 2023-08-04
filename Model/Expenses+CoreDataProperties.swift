//
//  Expenses+CoreDataProperties.swift
//  assignment8
//
//  Created by Lakshya Gupta on 4/29/23.
//
//

import Foundation
import CoreData


extension Expenses {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expenses> {
        return NSFetchRequest<Expenses>(entityName: "Expenses")
    }

    @NSManaged public var expense: String?
    @NSManaged public var category: String?
    @NSManaged public var amount: Float

}

extension Expenses : Identifiable {

}
