//
//  ActivityCategory+CoreDataProperties.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2020-11-05.
//
//

import Foundation
import CoreData


extension ActivityCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ActivityCategory> {
        return NSFetchRequest<ActivityCategory>(entityName: "ActivityCategory")
    }

    @NSManaged public var categoryName: String
    @NSManaged public var activity: NSSet?

}

// MARK: Generated accessors for activity
extension ActivityCategory {

    @objc(addActivityObject:)
    @NSManaged public func addToActivity(_ value: Activity)

    @objc(removeActivityObject:)
    @NSManaged public func removeFromActivity(_ value: Activity)

    @objc(addActivity:)
    @NSManaged public func addToActivity(_ values: NSSet)

    @objc(removeActivity:)
    @NSManaged public func removeFromActivity(_ values: NSSet)

}

extension ActivityCategory : Identifiable {

}
