//
//  DetailedDayView.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2020-11-17.
//

import SwiftUI

struct DetailedDayView: View {
    
//    var dailyData: FetchedResults<AddedActivity>
    var dailyData: [AddedActivity]
    
    @Binding var showEditScreen: Bool
    @State var showActivitySelector: Bool = false
    @ObservedObject var activityToSave: ActivityToSave
    @State var activityViewState = CGSize.zero
    @Binding var date: Date
    @State var itemToDelete = AddedActivity()
    @State var showCategoryNameEditor = false
    
    
    let dateFormatter: DateFormatter = {
        var df = DateFormatter()
        df.dateFormat = "EEEE, MMM, d, yyyy"
        return df
    }()
    
    //MARK: - Category Names
    @Binding var category1Name: String
    @Binding var category2Name: String
    @Binding var category3Name: String
    @Binding var category4Name: String
    
    let categories = ["category1", "category2", "category3", "category4"]
    
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
                    category4Name: $category4Name
                )
                
                
                //List of All completed Activities sorted by catagory
                ScrollView(.vertical) {
                    VStack {
                        ForEach(Array(zip(categoryNames, categoryNames.indices)), id: \.0) { catagory, index in
                            
                            let dailyCategoryData = dailyData.filter {
                                    Calendar.current.isDate($0.timestamp ?? Date(), inSameDayAs: date) && $0.category == categories[index]
                            }
                            
                            HStack {
                                Text(dailyCategoryData.isEmpty ? "\(catagory.capitalized) - no activities logged" : "\(catagory.capitalized)")
                                    .frame(width: screen.width - 56, alignment: .leading)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color("\(categories[index])Color"))
                                    .padding(.leading, 16)
                                    .padding(.top, 4)
                                
                                Spacer()
                            }
                            ForEach(dailyCategoryData, id: \.self) { data in
                                
                                DetailedDayCatagorySectionItem(
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
                                    date: $date
                                )
//                                data: data,
//                                showEditScreen: $showEditScreen,
//                                activityToEdit: activityToSave,
//                                itemToDelete: $itemToDelete
                                
                                    .frame(width: screen.width - 56, alignment: .leading)
                                    .background(Color.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
//                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 2)
                            }
                            .frame(width: screen.width - 56, alignment: .leading)
                            
//                            Divider().background(Color.white).frame(height: 2)
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
        activityToSave.activityName = "Select Activity"
        activityToSave.category = "category1"
        activityToSave.hours = 0
        activityToSave.minutes = 0
        activityToSave.notes = ""
    }
    
}


//MARK: - DetailedDayCatagorySectionItem
struct DetailedDayCatagorySectionItem: View {
    
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
    @Binding var date: Date
    
    
    

    
        var body: some View {
            
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("\(data.name ?? "Unknown Activity")")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color("\(data.category ?? "category1")Color"))
//                        .padding(.vertical, 1)
                        .padding(.top, 4)
                    Text("Minutes: \(data.duration, specifier: "%.0f")")
                        .font(.system(size: 16))
                        .foregroundColor(Color("\(data.category ?? "category1")Color"))
//                        .padding(.vertical, 1)
                    Text("Notes: \(data.notes ?? "")")
                        .font(.system(size: 16))
                        .foregroundColor(Color("\(data.category ?? "category1")Color"))
//                        .padding(.vertical, 1)
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
                        activityToEdit.category = data.category ?? "category1"
                        activityToEdit.hours = data.duration / 60
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
                        AddActivityView(
                            showActivitySelector: $showActivitySelector,
                            activityToSave: activityToSave,
                            showAddActivity: $showEditScreen,
                            isEditScreen: true,
                            selectedDate: $date,
                            itemToDelete: $itemToDelete,
                            showingNameEditor: $showCategoryNameEditor,
                            category1Name: $category1Name,
                            category2Name: $category2Name,
                            category3Name: $category3Name,
                            category4Name: $category4Name
                        )
                        .environmentObject(activityToSave)
                    }
            }
        }
    
    //MARK: - Reset Activity Function
    private func resetActivity(_ : ActivityToSave) {
        activityToSave.activityName = "Select Activity"
        activityToSave.category = "category1"
        activityToSave.hours = 0
        activityToSave.minutes = 0
        activityToSave.notes = ""
    }
    
}


//MARK: - Summary View
struct DaySummaryView: View {
    
    var sumOfWeeklyFitnessMinutes: Float
    var sumOfWeeklyLearningMinutes: Float
    var sumOfWeeklyChoresMinutes: Float
    var sumOfWeeklyWorkMinutes: Float
    
    @Binding var category1Name: String
    @Binding var category2Name: String
    @Binding var category3Name: String
    @Binding var category4Name: String
    
    var body: some View {
        
        let totalSum : Float = { sumOfWeeklyWorkMinutes + sumOfWeeklyChoresMinutes + sumOfWeeklyFitnessMinutes + sumOfWeeklyLearningMinutes }()
        
        VStack(alignment: .center) {
            HStack {
                VStack {
                    Text("Total Daily Minutes: \(totalSum, specifier: "%.0f")")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color("defaultYellow"))
                    
                    Text("(\(totalSum / 60, specifier: "%.1f") hours) ")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color("defaultYellow"))
                }
            }
            .padding(.all, 6)
            .foregroundColor(.white)
            
            ZStack {
                VStack(alignment: .center) {
                    HStack(alignment: .top) {
                        Text("\(category1Name.capitalized): \(sumOfWeeklyFitnessMinutes, specifier: "%.0f") ")
                            .padding(.horizontal, 10)
                            .foregroundColor(Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)))
                        
                        Text("\(category2Name.capitalized): \(sumOfWeeklyLearningMinutes, specifier: "%.0f")  ")
                            .padding(.horizontal, 10)
                            .foregroundColor(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
                    }
                    .padding(.vertical, 6)
                    
                    HStack(alignment: .top) {
                        Text("\(category3Name.capitalized): \(sumOfWeeklyChoresMinutes, specifier: "%.0f")  ")
                            .padding(.horizontal, 10)
                            .foregroundColor(Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)))
                        Text("\(category4Name.capitalized): \(sumOfWeeklyWorkMinutes, specifier: "%.0f") ")
                            .padding(.horizontal, 10)
                            .foregroundColor(Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)))
                    }
                    .padding(.all, 6)
                    
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(.bottom)
            }
            .frame(maxWidth: .infinity)
        }
        .background(Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1)))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .padding(.horizontal)
    }
}
