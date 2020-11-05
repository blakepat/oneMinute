////
////  Type.swift
////  oneMinute
////
////  Created by Blake Patenaude on 2020-11-04.
////
//
//import Foundation
//import CoreData
//
//
//public class ActivityCategory: NSManagedObject, Identifiable {
//
//    @NSManaged public var categoryName: String
//    @NSManaged public var activities: NSSet?
//
////    public var wrappedCategoryName: String {
////        categoryName ?? "Unknown Activity"
////    }
//
//    public var activitiesArray: [Activity] {
//        let set = activities as? Set<Activity> ?? []
//        return set.sorted {
//            $0.name < $1.name
//        }
//    }
//
//}
////
//
//extension ActivityCategory {
//
//    static func getSubCategoryItems() -> NSFetchRequest<ActivityCategory> {
//
//        let request: NSFetchRequest<ActivityCategory> = ActivityCategory.fetchRequest() as! NSFetchRequest<ActivityCategory>
//        
//        let sortDescriptor = NSSortDescriptor(key: "categoryName", ascending: true)
//
//        request.sortDescriptors = [sortDescriptor]
//
//        return request
//
//    }
//
//
//}
