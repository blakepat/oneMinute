//
//  DetailedDayCategorySectionItem.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-08-26.
//

import SwiftUI

struct DetailedDayCategorySectionItem: View {
    
    var data: FetchedResults<AddedActivity>.Element
    @Binding var showEditScreen: Bool
    @ObservedObject var activityToEdit: ActivityToSave
    @Binding var itemToDelete: AddedActivity
    @Binding var showActivitySelector: Bool
    @ObservedObject var activityToSave: ActivityToSave
    @Binding var showCategoryNameEditor: Bool
    @Binding var category1Name: String
    @Binding var category2Name: String
    @Binding var category3Name: String
    @Binding var category4Name: String
    @Binding var isHours: Bool
    @Binding var date: Date
    @Binding var activeSheet: ActiveSheet?

        var body: some View {
            
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("\(data.name ?? "Unknown Activity")")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color("\(data.category ?? "category1")Color"))
                        .padding(.top, 4)
                    Text("\(timeUnitName(isHours: isHours)): \(timeConverter(time: data.duration, timeUnitIsHours: isHours), specifier: decimalsToShow(isHours: isHours))")
                        .font(.system(size: 16))
                        .foregroundColor(Color("\(data.category ?? "category1")Color"))
                    Text("Notes: \(data.notes ?? "")")
                        .font(.system(size: 16))
                        .foregroundColor(Color("\(data.category ?? "category1")Color"))
                        .padding(.bottom, 4)
                    
                }
                .padding(.horizontal)
                
                Spacer()
                
                Text("Edit")
                    .frame(width: 70, height: 40, alignment: .center)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .background(Color(#colorLiteral(red: 0.2082437575, green: 0.2156656086, blue: 0.2157248855, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                    .onTapGesture {
                        
                        
                        
                        itemToDelete = data as AddedActivity
                        
                        activityToEdit.activityName = data.name ?? "Unknown Activity"
                        activityToEdit.category = data.category ?? "category0"
                        activityToEdit.hours = (data.duration / 60).rounded(.down)
                        activityToEdit.minutes = data.duration.truncatingRemainder(dividingBy: 60)
                        activityToEdit.notes = data.notes ?? ""
                        
                        self.showEditScreen.toggle()
                    }
                    .sheet(isPresented: $showEditScreen, onDismiss: {
                        self.showEditScreen = false
                        self.showActivitySelector = false
                        resetActivity(activityToSave)
                    }) {
                        //MARK: - Add activity view
                        AddActivityView(showActivitySelector: $showActivitySelector,
                                        showAddActivity: $showEditScreen,
                                        selectedDate: $date,
                                        itemToDelete: $itemToDelete,
                                        showingNameEditor: $showCategoryNameEditor,
                                        activityToSave: activityToEdit,
                                        isEditScreen: true,
                                        categorySelected: true,
                                        category1Name: $category1Name,
                                        category2Name: $category2Name,
                                        category3Name: $category3Name,
                                        category4Name: $category4Name,
                                        activeSheet: $activeSheet)
//                        .environmentObject(activityToEdit)
                    }
            }
        }
    
    //MARK: - Reset Activity Function
    private func resetActivity(_ : ActivityToSave) {
        activityToSave.activityName = "Select Category..."
        activityToSave.category = "category0"
        activityToSave.hours = 0
        activityToSave.minutes = 0
        activityToSave.notes = ""
    }
    
}
