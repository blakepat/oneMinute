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
    
    @Published var isShowingSaveAlert = false
    @Published var alertItem: AlertItem?
    @Published var notes = ""
    @Published var favouriteToSave: AddedActivity?
    
        
    //MARK: - Save Item
    func saveActivity(viewContext: NSManagedObjectContext) {
        withAnimation {
            if let favouriteToSave = favouriteToSave {
                let newAddedActivity = AddedActivity(context: viewContext)
                newAddedActivity.name = favouriteToSave.name
                newAddedActivity.category = favouriteToSave.category
                newAddedActivity.notes = notes
                newAddedActivity.duration = favouriteToSave.duration
                newAddedActivity.timestamp = Date()
                newAddedActivity.favourite = false
            }
                
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
//            saveActivity(activity: activity, date: activity.timestamp ?? Date(), viewContext: viewContext)
            viewContext.delete(activity)
            
        }
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    
    func addNotesAlertView(activity: AddedActivity) {
//        let alert = UIAlertController(title: "Notes:", message: "add notes and add record this activity", preferredStyle: .alert)
//        alert.addTextField { (nameForm) in
//            nameForm.placeholder = "notes..."
//            nameForm.autocorrectionType = .no
//        }
//
//        let save = UIAlertAction(title: "Save", style: .default) { [self] save in
//            saveActivity(activity: activity, notes: alert.textFields![0].text!, date: Date(), viewContext: viewContext)
//        }
//
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
//            self.isShowingSaveAlert = false
//        }
//
//        alert.addAction(save)
//        alert.addAction(cancel)
//
//        rootController().present(alert, animated: true, completion: nil)
        
        favouriteToSave = activity
        isShowingSaveAlert = true
//        }
        
        
    }
    
    func rootController()->UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else{
            return .init()
        }
        return root
    }
    
}
