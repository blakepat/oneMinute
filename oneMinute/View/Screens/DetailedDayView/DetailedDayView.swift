//
//  DetailedDayView.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2020-11-17.
//

import SwiftUI

struct DetailedDayView: View {
    
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
        df.dateFormat = "EEEE, MMM, d, yyyy"
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
        
        let dailyFitnessTotal = viewModel.getCategoryTotalForDate(date, category: category1, allActivities: dailyData)
        let dailyLearningTotal = viewModel.getCategoryTotalForDate(date, category: category2, allActivities: dailyData)
        let dailyChoresTotal = viewModel.getCategoryTotalForDate(date, category: category3, allActivities: dailyData)
        let dailyWorkTotal = viewModel.getCategoryTotalForDate(date, category: category4, allActivities: dailyData)
        
        ZStack{
            
            //Background Color
            Color(#colorLiteral(red: 0.2082437575, green: 0.2156656086, blue: 0.2157248855, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            VStack {
                
                //MARK: - Pull down tap
                    HStack {
                        
                        Spacer()
                        Color.black
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .frame(width: 50, height: 8, alignment: .center)
                            .padding(.top, 8)
                            .padding(.bottom, 0)
                            
                        Spacer()
                    }
                
                //Date
                Text("\(date, formatter: dateFormatter)")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(4)
                
                //Summary of day similar to summary of week on main screen
                DaySummaryView(
                    sumOfWeeklyFitnessMinutes: dailyFitnessTotal,
                    sumOfWeeklyLearningMinutes: dailyLearningTotal,
                    sumOfWeeklyChoresMinutes: dailyChoresTotal,
                    sumOfWeeklyWorkMinutes: dailyWorkTotal,
                    category1Name: $category1Name,
                    category2Name: $category2Name,
                    category3Name: $category3Name,
                    category4Name: $category4Name,
                    isHours: $isHours
                )
                
                
                //List of All completed Activities sorted by catagory
                ScrollView(.vertical) {
                    VStack {
                        ForEach(Array(zip(categoryNames, categoryNames.indices)), id: \.0) { category, index in
                            
                            let dailyCategoryData = viewModel.getCategoryActivitiesForDate(date, allActivities: dailyData, index: index)
                            
                            if !dailyCategoryData.isEmpty {
                                HStack {
                                    Text("\(category.capitalized)")
                                        .frame(width: screen.width - 56, alignment: .leading)
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(categoryColors[index])
                                        .padding(.leading, 16)
                                        .padding(.top, 4)
                                        
                                     Spacer()
                                }
                            }
                            ForEach(dailyCategoryData, id: \.self) { data in
                                
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
                                    date: $date,
                                    activeSheet: $activeSheet
                                )
                                    .frame(width: screen.width - 56, alignment: .leading)
                                    .background(Color.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))

                                    .padding(.vertical, 2)
                            }
                            .frame(width: screen.width - 56, alignment: .leading)
                        }
                    }
                }
                .frame(width: screen.width - 32, alignment: .leading)
                .background(Color.minutesBackgroundBlack)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.bottom, 30)
                
                Spacer()
                
            }
        }
        .frame(width: screen.width, height: screen.height)
    }    
}

