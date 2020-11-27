//
//  addFavouriteView.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2020-11-12.
//

import SwiftUI

struct AddFavouriteView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    //Passed Items
    @ObservedObject var activityToSave: ActivityToSave
    var activities: FetchedResults<AddedActivity>
    @Binding var showAddFavourite: Bool
    
    
    var body: some View {
        
        ZStack {
            
            Color(#colorLiteral(red: 0.2082437575, green: 0.2156656086, blue: 0.2157248855, alpha: 1))
                .edgesIgnoringSafeArea(.all)

            //MARK: - List of all favourites
            List {
                Section(header: ListHeader()) {
                    ForEach(activities.filter({ $0.favourite == true }), id: \.self) { favourite in
                        
                        FavouriteRow(favourite: favourite)
                            .listRowBackground(Color(#colorLiteral(red: 0.2082437575, green: 0.2156656086, blue: 0.2157248855, alpha: 1)))
                            .onTapGesture {
                                saveActivity(activity: favourite, notes: "", date: Date())
                                showAddFavourite = false
                            }
                    }
                    .onDelete(perform: deleteFavourite)
                }
            }
            .listStyle(GroupedListStyle())
            .clipped()
            
        }
    }
    
    private func deleteFavourite(at offsets: IndexSet) {
        
        for index in offsets {
            let activity = activities.filter({ $0.favourite == true })[index]
            viewContext.delete(activity)
            saveActivity(activity: activity, notes: activity.notes ?? "", date: activity.timestamp ?? Date())
            
        }
        
        
        
        
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
        
        
        
        
    }
    
    
    
    
    //MARK: - Save Item
    private func saveActivity(activity: AddedActivity, notes: String, date: Date) {
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

    
    
}


struct FavouriteRow: View {
    
    var favourite: AddedActivity
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text(favourite.name ?? "Unknown Activity")
                    .foregroundColor(.white)
                Text(favourite.category?.capitalized ?? "Unknown Category").font(.subheadline).foregroundColor(.gray)
            }
            Spacer()
            Text(String(format: "%.0f minutes", favourite.duration))
                .foregroundColor(.white)
        }
    }
}

struct ListHeader: View {
    
    var body: some View {
        HStack {
            Image(systemName: "bookmark")
            Text("Quick Add Favourited Activities")
        }
    }
}
