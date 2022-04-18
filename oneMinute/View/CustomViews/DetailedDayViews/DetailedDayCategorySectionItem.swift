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
    @State var date: Date
    @Binding var activeSheet: ActiveSheet?

        var body: some View {
            
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("\(data.name ?? "Unknown Activity")")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color("\(data.category ?? "category1")Color"))
                        .padding(.top, 4)
                    
                    HStack {
                        Text("\(timeUnitName(isHours: isHours).capitalized):")
                            .bold()
                            .foregroundColor(.white)
                        
                        Text("\(timeConverter(time: data.duration, timeUnitIsHours: isHours), specifier: decimalsToShow(isHours: isHours))")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                    }
                    
                    if data.notes != nil && data.notes != "" {
                        HStack {
                            Text("Notes:")
                                .bold()
                                .foregroundColor(.white)
                            
                            Text("\(data.notes!)")
                                .font(.system(size: 16))
                                .foregroundColor(Color.white)
                                .padding(.bottom, 4)
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
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
