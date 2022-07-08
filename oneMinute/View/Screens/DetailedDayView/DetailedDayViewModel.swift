//
//  DetailedDayViewModel.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-08-31.
//

import SwiftUI
import CoreData

final class DetailedDayViewModel: ObservableObject {
    
//    @Environment(\.managedObjectContext) private var viewContext
    
    
    @Published var itemToDelete = AddedActivity()
    @Published var showCategoryNameEditor = false
    @Published var showActivitySelector: Bool = false
    
    func getCategoryTotalForDate(_ date: Date, category: String, allActivities: [AddedActivity]) -> Float {
        
        allActivities.filter({ Calendar.current.isDate($0.timestamp ?? Date(), inSameDayAs: date) && $0.category == category}).reduce(0) {$0 + $1.duration}
        
    }
 
    func getCategoryActivitiesForDate(_ date: Date, allActivities: [AddedActivity], index: Int) -> [AddedActivity] {
        allActivities.filter { Calendar.current.isDate($0.timestamp ?? Date(), inSameDayAs: date) && $0.category == categories[index] }
    }
    
    func deleteActivity(section: [AddedActivity], offsets: IndexSet, viewContext: NSManagedObjectContext) {
        for index in offsets {
            let activity = section[index]
            viewContext.delete(activity)
        }
        
        do {
            try viewContext.save()
            print("✅ success saving context after deleting")
        }catch{
            print("❌ ERROR saving context after deleting")
            print(error)
        }
    }
}
