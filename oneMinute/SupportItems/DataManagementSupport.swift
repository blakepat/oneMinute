//
//  DataManagementSupport.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-08-26.
//

import SwiftUI
import CoreData


//MARK: - Reset Activity Function
func resetActivity(activityToSave: ActivityToSave) {
    activityToSave.activityName = "Select Category"
    activityToSave.category = "category0"
    activityToSave.hours = 0
    activityToSave.minutes = 0
    activityToSave.notes = ""
}

////MARK: - Delete Activity
//func deleteActivity(viewContext: NSManagedObjectContext, itemToDelete: AddedActivity) {
//
//    viewContext.delete(itemToDelete)
//                do {
//                    try viewContext.save()
//                }catch{
//                    print(error)
//                }
//
//}
//
//func saveActivity(activity: ActivityToSave, date: Date, favourite: Bool, viewContext: NSManagedObjectContext) {
//    withAnimation {
//
//        let newAddedActivity = AddedActivity(context: viewContext)
//            newAddedActivity.name = activity.activityName
//            newAddedActivity.category = activity.category
//            newAddedActivity.notes = activity.notes
//            newAddedActivity.duration = activity.minutes + (activity.hours * 60)
//            newAddedActivity.timestamp = date
//            newAddedActivity.favourite = favourite
//        do {
//            try viewContext.save()
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//    }
//}
