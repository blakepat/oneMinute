//
//  AddFavouriteViewModel.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-08-31.
//

import SwiftUI
import CoreData


final class AddFavouriteViewModel: ObservableObject {
    
    @Environment(\.managedObjectContext) private var viewContext
        
    //MARK: - Save Item
    func saveActivity(activity: AddedActivity, notes: String, date: Date, viewContext: NSManagedObjectContext) {
        withAnimation {
            
                let newAddedActivity = AddedActivity(context: viewContext)
                newAddedActivity.name = activity.name
                newAddedActivity.category = activity.category
                newAddedActivity.notes = notes
                newAddedActivity.duration = activity.duration
                newAddedActivity.timestamp = date
                newAddedActivity.favourite = false
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    
    func deleteFavourite(at offsets: IndexSet, activities: FetchedResults<AddedActivity>, viewContext: NSManagedObjectContext) -> Void {
        for index in offsets {
            let activity = activities.filter({ $0.favourite == true })[index]
            saveActivity(activity: activity, notes: activity.notes ?? "", date: activity.timestamp ?? Date(), viewContext: viewContext)
            viewContext.delete(activity)
            
        }
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    
}
