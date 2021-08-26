//
//  DetailedDayView.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2020-11-17.
//

import SwiftUI

struct DetailedDayView: View {
    
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
    
    private let categories = ["category1", "category2", "category3", "category4"]
    
    var body: some View {
        
        
        let categoryNames = [category1Name, category2Name, category3Name, category4Name]
        
        let dailyFitnessTotal = dailyData.filter({ Calendar.current.isDate($0.timestamp ?? Date(), inSameDayAs: date) && $0.category == "category1"}).reduce(0) {$0 + $1.duration}
        
        let dailyLearningTotal = dailyData.filter({ Calendar.current.isDate($0.timestamp ?? Date(), inSameDayAs: date) && $0.category == "category2"}).reduce(0) {$0 + $1.duration}
        
        let dailyChoresTotal = dailyData.filter({ Calendar.current.isDate($0.timestamp ?? Date(), inSameDayAs: date) && $0.category == "category3"}).reduce(0) {$0 + $1.duration}
        
        let dailyWorkTotal = dailyData.filter({ Calendar.current.isDate($0.timestamp ?? Date(), inSameDayAs: date) && $0.category == "category4"}).reduce(0) {$0 + $1.duration}
        
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
                        ForEach(Array(zip(categoryNames, categoryNames.indices)), id: \.0) { catagory, index in
                            
                            let dailyCategoryData = dailyData.filter {
                                    Calendar.current.isDate($0.timestamp ?? Date(), inSameDayAs: date) && $0.category == categories[index]
                            }
                            
                            if !dailyCategoryData.isEmpty {
                                
                                HStack {
                                    
                                    Text("\(catagory.capitalized)")
                                        .frame(width: screen.width - 56, alignment: .leading)
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(Color("\(categories[index])Color"))
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
                .background(Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1)))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.bottom, 30)
                
                Spacer()
                
            }
        }
        .frame(width: screen.width, height: screen.height)
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

