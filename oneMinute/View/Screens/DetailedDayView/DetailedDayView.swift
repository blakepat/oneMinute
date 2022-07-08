//
//  DetailedDayView.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2020-11-17.
//

import SwiftUI

struct DetailedDayView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var viewContext
    
    @StateObject private var viewModel = DetailedDayViewModel()
    @StateObject private var coreDataManager = CoreDataManager()
    @ObservedObject var activityToSave: ActivityToSave
    
    var dailyData: [AddedActivity]
    @Binding var showEditScreen: Bool
    @Binding var date: Date
    
    
    private let dateFormatter: DateFormatter = {
        var df = DateFormatter()
        df.dateFormat = "EEE, MMM d, yyyy"
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
                                        itemToDelete: $viewModel.itemToDelete,
                                        showActivitySelector: $viewModel.showActivitySelector,
                                        activityToSave: activityToSave,
                                        showCategoryNameEditor: $viewModel.showCategoryNameEditor,
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
                                    viewModel.itemToDelete = data as AddedActivity
                                    
                                    activityToSave.activityName = data.name ?? "Unknown Activity"
                                    activityToSave.category = data.category ?? "category0"
                                    activityToSave.hours = (data.duration / 60).rounded(.down)
                                    activityToSave.minutes = data.duration.truncatingRemainder(dividingBy: 60)
                                    activityToSave.notes = data.notes ?? ""
                                    
                                    self.showEditScreen.toggle()
                                }
                                .sheet(isPresented: $showEditScreen, onDismiss: {
                                    self.showEditScreen = false
                                    viewModel.showActivitySelector = false
                                    resetActivity(activityToSave: activityToSave)
                                }) {
                                    //MARK: - Add activity view
                                    AddActivityView(showActivitySelector: $viewModel.showActivitySelector,
                                                    showAddActivity: $showEditScreen,
                                                    selectedDate: $date,
                                                    itemToDelete: $viewModel.itemToDelete,
                                                    showingNameEditor: $viewModel.showCategoryNameEditor,
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
                            .onDelete { index in
                                viewModel.deleteActivity(section: dailyCategoryData, offsets: index, viewContext: viewContext)
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
