//
//  AddAcitivityViewModel.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-08-31.
//

import SwiftUI
import CoreData

final class AddActivityViewModel: ObservableObject {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    //Local Items
    @Published var activityName = "Select Category..."
    @Published var viewState = CGSize.zero
    @Published var showingAlert = false
    @Published var showCalendar = false
    @Published var activityFilter = ActivityFilter.all
    
    
    //MARK: - Reset Activity Function
    func resetActivity(_ activityToSave: ActivityToSave) {
        activityToSave.activityName = "Select Category"
        activityToSave.category = "category0"
        activityToSave.hours = 0
        activityToSave.minutes = 0
        activityToSave.notes = ""
    }
    
    
    //MARK: - Save Item
    func saveActivity(activity: ActivityToSave, date: Date, favourite: Bool, viewContext: NSManagedObjectContext) {
        withAnimation {
            
                let newAddedActivity = AddedActivity(context: viewContext)
                newAddedActivity.name = activity.activityName
                newAddedActivity.category = activity.category
                newAddedActivity.notes = activity.notes
                newAddedActivity.duration = activity.minutes + (activity.hours * 60)
                newAddedActivity.timestamp = date
                newAddedActivity.favourite = favourite
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
    
    
    //MARK: - Delete Activity
    func deleteActivity(itemToDelete: AddedActivity, viewContext: NSManagedObjectContext) {
        
        viewContext.delete(itemToDelete)
                    do {
                        try viewContext.save()
                    }catch{
                        print(error)
                    }
    }
    
    
    
    

    
    
}
    

