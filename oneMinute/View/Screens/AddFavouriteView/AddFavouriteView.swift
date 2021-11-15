//
//  addFavouriteView.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2020-11-12.
//

import SwiftUI

struct AddFavouriteView: View {
    
    @StateObject private var viewModel = AddFavouriteViewModel()
    
    @Environment(\.managedObjectContext) private var viewContext
    
    //Passed Items
    @ObservedObject var activityToSave: ActivityToSave
    var activities: FetchedResults<AddedActivity>
    @Binding var showAddFavourite: Bool
    
    //Custom Category Names
    @Binding var category1Name: String
    @Binding var category2Name: String
    @Binding var category3Name: String
    @Binding var category4Name: String
    
    @Binding var activeSheet: ActiveSheet?
    
    var body: some View {
        
        let categoryNames = [category1Name, category2Name, category3Name, category4Name]
        
        ZStack {
            
            Color.minutesBackgroundBlack
                .edgesIgnoringSafeArea(.all)

            //MARK: - List of all favourites
            List {
                Section(header: ListHeader()) {
                            ForEach(activities.filter({ $0.favourite == true }), id: \.self) { favourite in
                                HStack {
                                    FavouriteRow(favourite: favourite, categoryName: categoryNames[categories.firstIndex(of: favourite.category ?? "") ?? 0])
                                }
                                .frame(height: 30)
                                .contentShape(Rectangle())
                                .listRowBackground(Color.minutesBackgroundBlack)
                                .onTapGesture {
                                    self.showAddFavourite = false
                                    self.activeSheet = nil
                                    viewModel.saveActivity(activity: favourite, notes: "", date: Date(), viewContext: viewContext)
                                }
                            }
                            .onDelete{ viewModel.deleteFavourite(at: $0, activities: activities, viewContext: viewContext) }
                }
            }
            .listStyle(GroupedListStyle())
        }
    }
}


struct FavouriteRow: View {
    
    var favourite: AddedActivity
    var categoryName: String
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text(favourite.name ?? "Unknown Activity")
                    .foregroundColor(.white)
                Text(categoryName).font(.subheadline).foregroundColor(.gray)
            }
            .frame(height: 30)
            .contentShape(Rectangle())
            Spacer()
            Text(String(format: "%.0f minutes", favourite.duration))
                .foregroundColor(.white)
        }
        .frame(height: 30)
        .contentShape(Rectangle())
    }
}

struct ListHeader: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack {
            Image(systemName: "bookmark")
                
            Text("Quick Add Favourites")
                .font(.title3)
            
            Spacer()
            
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Dismiss")
            }
        }
    }
}
