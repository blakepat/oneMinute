//
//  ActivitySelectorView.swift
//  oneWeek
//
//  Created by Blake Patenaude on 2020-11-03.
//

import SwiftUI
import CoreData

struct ActivitySelectorView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    var allActivities: FetchedResults<Activity>
    var fetchRequest: FetchRequest<Activity>
    
    //Passed variables
    @Binding var showActivitySelector: Bool
    @ObservedObject var activityToSave: ActivityToSave
    var categoryNames: [String]
    @Binding var activityFilter: ActivityFilter
    
    //local variables
    @State private var showingAlert = false
    @State private var alertInput = ""
    @State private var editActive = false
    @State private var searchText = ""
    @State private var activityToEdit = ""
    
    
 
    var body: some View {
    
        ZStack {
            //backgroundColor
            Color.getCategoryColor(activityToSave.category)

            VStack {
                //Title Bar
                TitleBar(showingAlert: $showingAlert, editActive: $editActive, categoryName: categoryNames[(Int(String(activityToSave.category.last!)) ?? 1) - 1])
                
                //List
                List {
                    SearchBar(text: $searchText)
                    
                    ForEach(fetchRequest.wrappedValue.filter({ searchText.isEmpty ? true : $0.name.contains(searchText) }), id: \.self) { activity in
                        HStack {
                            if editActive {
                                Image(systemName: "arrow.turn.down.right")
                            }

                            Text(activity.name)
                                
                            Spacer()
                        }
                        .frame(height: 30)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if editActive {
                                self.activityToEdit = activity.name
                                self.showingAlert.toggle()
                                self.alertInput = activity.name
                            } else {
                                self.showActivitySelector = false
                                self.activityToSave.activityName = activity.name
                                self.activityFilter = .activityName
                            }
                        }
                    }
                    .onDelete(perform: deleteActivity)
                }
            }
            
            
            BlurView(style: .systemUltraThinMaterial)
                .offset(y: self.showingAlert ? 0 : screen.height)
                .edgesIgnoringSafeArea(.all)
            
            TextFieldAlert(isShowing: $showingAlert, text: $alertInput, activityToEdit: activityToEdit, editActive: editActive, category: activityToSave.category)
                .offset(x: 60, y: self.showingAlert ? 0 : screen.height)
                .animation(.easeInOut)

        }
    }
    
    func deleteActivity(at offsets: IndexSet) {
        for index in offsets {
            let activity = fetchRequest.wrappedValue[index]
            viewContext.delete(activity)
        }
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
        
    init(filter: String, showActivitySelector: Binding<Bool>, activityToSave: ActivityToSave, allActivities: FetchedResults<Activity>, categoryNames: [String], activityFilter: Binding<ActivityFilter>) {
        
        fetchRequest = FetchRequest<Activity>(entity: Activity.entity(), sortDescriptors: [], predicate: NSPredicate(format: "category CONTAINS %@", filter))
        
        self._showActivitySelector = showActivitySelector
        self.activityToSave = activityToSave
        self.allActivities = allActivities
        self.categoryNames = categoryNames
        self._activityFilter = activityFilter
    }
}
    

//MARK: - Title Bar
struct TitleBar: View {
    
    @Binding var showingAlert: Bool
    @Binding var editActive: Bool
    
    var categoryName: String
    
    
    var body: some View {
        
            HStack {
                //back button
                Text("Edit")
                    .padding(3)
                    .background(editActive ? Color.secondary : .clear)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(6)
                    .font(.system(size: 22))
                    .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                        self.editActive.toggle()
                    })
                
                Spacer()
                
                Text("\(categoryName)")
                    .font(.system(size: 24, weight: .semibold))
                
                Spacer()
                
                //add activity button
                Image(systemName: "plus")
                    .padding()
                    .font(.system(size: 22))
                    .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                        self.showingAlert = true
                    })
            }
        }
    
}
