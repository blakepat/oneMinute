//
//  DetailedDayView.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2020-11-17.
//

import SwiftUI

struct DetailedDayView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = DetailedDayViewModel()
    
    var dailyData: [AddedActivity]
    
    @Binding var showEditScreen: Bool
    @State var showActivitySelector: Bool = false
    @ObservedObject var activityToSave: ActivityToSave
    @Binding var date: Date
    @State private var itemToDelete = AddedActivity()
    @State private var showCategoryNameEditor = false
    
    private let dateFormatter: DateFormatter = {
        var df = DateFormatter()
        df.dateFormat = "EEEE, MMM d, yyyy"
        return df
    }()
    
    //MARK: - Category Names
    @Binding var category1Name: String
    @Binding var category2Name: String
    @Binding var category3Name: String
    @Binding var category4Name: String
    @Binding var isHours: Bool
    
    @Binding var activeSheet: ActiveSheet?
    
    var body: some View {
        let categoryNames = [category1Name, category2Name, category3Name, category4Name]
        
        NavigationView {
            
                List {
                    ForEach(Array(zip(categoryNames, categoryNames.indices)), id: \.0) { category, index in
                        let dailyCategoryData = viewModel.getCategoryActivitiesForDate(date, allActivities: dailyData, index: index)
                        
                        Section(header: Text("\(category) - \(Int(dailyCategoryData.reduce(0) {$0 + $1.duration})) \(isHours ? "Hours" : "Minutes")").font(.headline)
                            ) {
                           
                            ForEach(dailyCategoryData, id: \.self) { data in
                                
                                HStack {
                                    DetailedDayCategorySectionItem(
                                        data: data,
                                        showEditScreen: $showEditScreen,
                                        activityToEdit: activityToSave,
                                        itemToDelete: $itemToDelete,
                                        showActivitySelector: $showActivitySelector,
                                        activityToSave: activityToSave,
                                        showCategoryNameEditor: $showCategoryNameEditor,
                                        category1Name: $category1Name,
                                        category2Name: $category2Name,
                                        category3Name: $category3Name,
                                        category4Name: $category4Name,
                                        isHours: $isHours,
                                        date: date,
                                        activeSheet: $activeSheet
                                    )
                                    
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    itemToDelete = data as AddedActivity
                                    
                                    activityToSave.activityName = data.name ?? "Unknown Activity"
                                    activityToSave.category = data.category ?? "category0"
                                    activityToSave.hours = (data.duration / 60).rounded(.down)
                                    activityToSave.minutes = data.duration.truncatingRemainder(dividingBy: 60)
                                    activityToSave.notes = data.notes ?? ""
                                    
                                    self.showEditScreen.toggle()
                                }
                                .sheet(isPresented: $showEditScreen, onDismiss: {
                                    self.showEditScreen = false
                                    self.showActivitySelector = false
                                    resetActivity(activityToSave: activityToSave)
                                }) {
                                    //MARK: - Add activity view
                                    AddActivityView(showActivitySelector: $showActivitySelector,
                                                    showAddActivity: $showEditScreen,
                                                    selectedDate: $date,
                                                    itemToDelete: $itemToDelete,
                                                    showingNameEditor: $showCategoryNameEditor,
                                                    activityToSave: activityToSave,
                                                    isEditScreen: true,
                                                    categorySelected: true,
                                                    category1Name: $category1Name,
                                                    category2Name: $category2Name,
                                                    category3Name: $category3Name,
                                                    category4Name: $category4Name,
                                                    activeSheet: $activeSheet)
                                }
                            }
                        }
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationTitle("\(date, formatter: dateFormatter)")
                .toolbar {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Dismiss")
                    }
                }
        }
    }    
}
