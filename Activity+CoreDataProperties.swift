//
//  Activity+CoreDataProperties.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2020-11-05.
//
//

import Foundation
import CoreData


extension Activity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var name: String
    @NSManaged public var category: String

}

extension Activity : Identifiable {

}
