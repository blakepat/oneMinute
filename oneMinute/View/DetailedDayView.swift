//
//  DetailedDayView.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2020-11-17.
//

import SwiftUI

struct DetailedDayView: View {
    
    var dailyData: FetchedResults<AddedActivity>
    @Binding var showEditScreen: Bool
    @State var showActivitySelector: Bool = false
    @ObservedObject var activityToSave: ActivityToSave
    @State var activityViewState = CGSize.zero
    @Binding var useHours: Bool
    @Binding var date: Date
    @State var itemToDelete = AddedActivity()
    
    
    let catagories = ["fitness", "learning", "chores", "work"]
    
    let dateFormatter: DateFormatter = {
        var df = DateFormatter()
        df.dateFormat = "EEEE, MMM, d, yyyy"
        return df
    }()
    

    var body: some View {
        
        let dailyFitnessTotal = dailyData.filter({ Calendar.current.isDate($0.timestamp ?? Date(), inSameDayAs: date) && $0.category == "fitness"}).reduce(0) {$0 + $1.duration}
        
        let dailyLearningTotal = dailyData.filter({ Calendar.current.isDate($0.timestamp ?? Date(), inSameDayAs: date) && $0.category == "learning"}).reduce(0) {$0 + $1.duration}
        
        let dailyChoresTotal = dailyData.filter({ Calendar.current.isDate($0.timestamp ?? Date(), inSameDayAs: date) && $0.category == "chores"}).reduce(0) {$0 + $1.duration}
        
        let dailyWorkTotal = dailyData.filter({ Calendar.current.isDate($0.timestamp ?? Date(), inSameDayAs: date) && $0.category == "work"}).reduce(0) {$0 + $1.duration}
        
        ZStack{
            
            //Background Color
            Color.black
            VStack(alignment: .leading) {
                
                //MARK: - Pull down tap
                    HStack {
                        
                        Spacer()
                        Color("charcoalColor")
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                            .frame(width: 50, height: 8, alignment: .center)
                            .padding(.top, 8)
                            .padding(.bottom, 0)
                            
                        Spacer()
                    }
                
                //Date
                Text("\(date, formatter: dateFormatter)")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
                    .padding()
                
                //Summary of day similar to summary of week on main screen
                DaySummaryView(
                    useHours: useHours,
                    sumOfWeeklyFitnessMinutes: dailyFitnessTotal,
                    sumOfWeeklyLearningMinutes: dailyLearningTotal,
                    sumOfWeeklyChoresMinutes: dailyChoresTotal,
                    sumOfWeeklyWorkMinutes: dailyWorkTotal
                )
                
                
                //List of All completed Activities sorted by catagory
                ScrollView(.vertical) {
                    VStack {
                        ForEach(catagories, id: \.self) { catagory in
                            
                            Text("\(catagory.capitalized)")
                                .frame(width: screen.width, alignment: .leading)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color("\(catagory)Color"))
                                .padding(.leading, 8)
                                .padding(.top, 4)
                                
                            
                            ForEach(dailyData.filter({ Calendar.current.isDate($0.timestamp ?? Date(), inSameDayAs: date) && $0.category == catagory}), id: \.self) { data in
                                
                                DetailedDayCatagorySectionItem(data: data, showEditScreen: $showEditScreen, activityToEdit: activityToSave, itemToDelete: $itemToDelete)
                                    .frame(width: screen.width - 28, alignment: .leading)
                                    .background(Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1)))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                            }
                            .frame(width: screen.width, alignment: .leading)
                            
                            Divider().background(Color.white).frame(height: 2)
                        }
                    }
                }
                .frame(width: screen.width, alignment: .leading)
                .padding(.bottom, 30)
                Spacer()
            }
        }
        .frame(width: screen.width)
        
        
        //MARK: - Add activity view
        AddActivityView(showActivitySelector: $showActivitySelector, activityToSave: activityToSave, showAddActivity: $showEditScreen, isEditScreen: true, selectedDate: $date, itemToDelete: $itemToDelete)
            .environmentObject(activityToSave)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .frame(width: screen.width, height: screen.height - 60, alignment: .leading)
            .offset(x: 0, y: showEditScreen ? 30 : screen.height)
            .offset(y: activityViewState.height)
            .animation(.easeInOut)
            .gesture(
                DragGesture()
                    .onChanged({ (value) in
                        
                        if self.activityViewState.height > -1 {
                            self.activityViewState = value.translation
                        }
                    })
                    .onEnded({ (value) in
                        if self.activityViewState.height > 100 {
                            self.showEditScreen = false
                            self.showActivitySelector = false
                            
                            resetActivity(activityToSave)
                            
                        }
                        self.activityViewState = .zero
                    })
            )
        
        
    }
    
    //MARK: - Reset Activity Function
    private func resetActivity(_ : ActivityToSave) {
        activityToSave.activityName = "Select Activity"
        activityToSave.category = "fitness"
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
    
        var body: some View {
            
            HStack {
                VStack(alignment: .leading) {
                    
                    Text("\(data.name ?? "Unknown Activity")")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color("\(data.category ?? "fitness")Color"))
                        .padding(.vertical, 1)
                        .padding(.top, 4)
                    Text("Duration: \(data.duration, specifier: "%.0f") minutes")
                        .font(.system(size: 16))
                        .foregroundColor(Color("\(data.category ?? "fitness")Color"))
                        .padding(.vertical, 1)
                    Text("Notes: \(data.notes ?? "")")
                        .font(.system(size: 16))
                        .foregroundColor(Color("\(data.category ?? "fitness")Color"))
                        .padding(.vertical, 1)
                        .padding(.bottom, 4)
                    
                }
                .padding(.horizontal)
                
                
                Spacer()
                
                Text("Edit")
                    .frame(width: 70, height: 40, alignment: .center)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .background(Color(.black))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding()
                    .onTapGesture {
                        
                        itemToDelete = data as AddedActivity
                        
                        activityToEdit.activityName = data.name ?? "Unknown Activity"
                        activityToEdit.category = data.category ?? "fitness"
                        activityToEdit.hours = data.duration / 60
                        activityToEdit.minutes = data.duration.truncatingRemainder(dividingBy: 60)
                        activityToEdit.notes = data.notes ?? ""
                        
                        self.showEditScreen.toggle()
                    }
            }
        }
}


//MARK: - Summary View
struct DaySummaryView: View {
    
    var useHours: Bool
    var sumOfWeeklyFitnessMinutes: Float
    var sumOfWeeklyLearningMinutes: Float
    var sumOfWeeklyChoresMinutes: Float
    var sumOfWeeklyWorkMinutes: Float
    
    
    var body: some View {
        
        let totalSum : Float = { sumOfWeeklyWorkMinutes + sumOfWeeklyChoresMinutes + sumOfWeeklyFitnessMinutes + sumOfWeeklyLearningMinutes }()
        
        VStack {
            HStack {
                HStack {
                    Text("Total Daily Minutes: \(totalSum, specifier: "%.0f") (\(totalSum / 60, specifier: "%.1f") hours) ")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color("defaultYellow"))
                    Text("")
                        .font(.system(size: 20))
                }
            }
            .padding(.all, 6)
            .foregroundColor(.white)
            
            ZStack {
                VStack(alignment: .center) {
                    HStack(alignment: .top) {
                        Text("Fitness \(useHours ? "Hours" : "Minutes"): \(sumOfWeeklyFitnessMinutes, specifier: "%.0f") ")
                            .padding(.horizontal, 10)
                            .foregroundColor(Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)))
                        
                        Text("Learning \(useHours ? "Hours" : "Minutes"): \(sumOfWeeklyLearningMinutes, specifier: "%.0f")  ")
                            .padding(.horizontal, 10)
                            .foregroundColor(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
                    }
                    .padding(.vertical, 6)
                    
                    HStack(alignment: .top) {
                        Text("Chores \(useHours ? "Hours" : "Minutes"): \(sumOfWeeklyChoresMinutes, specifier: "%.0f")  ")
                            .padding(.horizontal, 10)
                            .foregroundColor(Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)))
                        Text("Work \(useHours ? "Hours" : "Minutes"): \(sumOfWeeklyWorkMinutes, specifier: "%.0f") ")
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
