//
//  StatsView.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-07-28.
//

import SwiftUI

struct StatsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    //Fetch listed activities
    @FetchRequest(entity: Activity.entity(), sortDescriptors: [])
    var activities: FetchedResults<Activity>
    
    //data
    var allData: FetchedResults<AddedActivity>
    var fetchRequest = FetchRequest<Activity>(entity: Activity.entity(), sortDescriptors: [])
    //Category Names
    @Binding var category1Name: String
    @Binding var category2Name: String
    @Binding var category3Name: String
    @Binding var category4Name: String
    
    //local variables
    @State var activityName = "Select Category..."
    @Binding var showActivitySelectorView: Bool
    @State var activityToShow: ActivityToSave
    let categories = ["category1", "category2", "category3", "category4"]
    @State var showingAllActivities = true
    @State var nameIndex = 0
    @State var timeFrame = TimeFrame.week
    
    
    
    var body: some View {
        
        ZStack {
            
            //Background
            Color(#colorLiteral(red: 0.2082437575, green: 0.2156656086, blue: 0.2157248855, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center) {
               
                //MARK: - Summary View but for highest scores (which activity has most minutes) in week/month/year, but once an activity in selected it becomes scores for that activity only
                ActivitySummaryView(useHours: false,
                                    allData: allData,
                                    fetchRequest: fetchRequest,
                                    category1Name: $category1Name,
                                    category2Name: $category2Name,
                                    category3Name: $category3Name,
                                    category4Name: $category4Name,
                                    timeFrameChanger: $timeFrame)
                    .padding(.top)
                
                
                //MARK: - Pie Chart View
                
                if eachCategoryTotalDuration(timeFrame: timeFrame, results: allData).reduce(0) { $0 + $1 } > 0 {
                    
                    PieChartView(values: eachCategoryTotalDuration(timeFrame: timeFrame, results: allData),
                                 colors: [Color("category1Color"), Color("category2Color"), Color("category3Color"), Color("category4Color")],
                                 names: [category1Name, category2Name, category3Name, category4Name],
                                 backgroundColor: Color("charcoalColor"),
                                 innerRadiusFraction: 0.6)
                        .padding(.horizontal, 16)
                        .frame(width: 360, height: 300)
                        
                } else {
                    
                    Text("No data to show for \nthis timeframe.")
                        .foregroundColor(.white)
                        .font(.title)
                        .multilineTextAlignment(.center)
                    
                }
                    
                //List of top activities
                
                List {
                    
                    ForEach(mostActivityLoggedDuring(timeFrame: timeFrame, results: allData), id: \.0) { topItem in
                        
                        Print(mostActivityLoggedDuring(timeFrame: timeFrame, results: allData).count)
                        
                        Text("\(topItem.0) \(String(format: "%0.f", topItem.1))")
                            .foregroundColor(.white)
                            .listRowBackground(Color("charcoalColor"))
                        
                    }
                }
                
                
                
                //Most productive day - maybe add this feature in version 2.0?
                
                
                

                //Add Other Stats here
                
                
                
                
                
                Spacer()
        
            }
        }
    }
    
    //Get totals for each category and put in Array
    func eachCategoryTotalDuration(timeFrame: TimeFrame, results: FetchedResults<AddedActivity>) -> [Double] {
    
        var totals = [Double]()
        
        for category in categories {
            if timeFrame == TimeFrame.week {
                totals.append(Double(results.filter({$0.category == category && $0.timestamp ?? Date() > Date().startOfWeek() && $0.timestamp ?? Date() < Date().startOfWeek().addingTimeInterval(7*24*60*60)}).reduce(0) { $0 + $1.duration }))
            } else if timeFrame == TimeFrame.month {
                
                totals.append(Double(results.filter({$0.category == category && $0.timestamp ?? Date() > Date().startOfMonth && $0.timestamp ?? Date() < Date().endOfMonth }).reduce(0) { $0 + $1.duration }))
                
            } else if timeFrame == TimeFrame.allTime {
                totals.append(Double(results.filter({$0.category == category}).reduce(0) { $0 + $1.duration }))
            } else {
                totals.append(Double(results.filter({$0.category == category}).reduce(0) { $0 + $1.duration }))
            }
        }
        
        return totals
        

        
    }
    
    
    //Cycle through all actvitiesAdded and get which ones are done the most based on timeFrame provided
    func mostActivityLoggedDuring(timeFrame: TimeFrame, results: FetchedResults<AddedActivity>) -> [(String, Float)] {
        
        if timeFrame == TimeFrame.week {
            
            var topActivtiesArray = [(String, Float)]()
            
            //Cycle through all activity types
            for activity in fetchRequest.wrappedValue {

                //Get the total duration for each that activity type
                let activityTotalAmount = results.filter({$0.timestamp ?? Date() > Date().startOfWeek() && $0.timestamp ?? Date() < Date().endOfWeek && $0.name == activity.name }).reduce(0) { $0 + $1.duration}
                
                //CHANGE IT TO CHECK IF IT IS LOWER THAN 5th item in array
                if activityTotalAmount > topActivtiesArray.min(by: { $0.1 < $1.1 })?.1 ?? 0 || topActivtiesArray.count < 5 && activityTotalAmount != 0 {
                    
                    if topActivtiesArray.count < 5 {
                        topActivtiesArray.append((activity.name, activityTotalAmount))
                    } else {
                        topActivtiesArray.sort(by: { $0.1 > $1.1 })
                        topActivtiesArray.removeLast()
                        topActivtiesArray.append((activity.name, activityTotalAmount))
                    }

                }
            }
            return topActivtiesArray.sorted(by: {$0.1 > $1.1})
        //Activity with Most this Month
        } else if timeFrame == TimeFrame.month {
            
            var topActivtiesArray = [(String, Float)]()
            
                //Cycle through all activity types
                for activity in fetchRequest.wrappedValue {

                    //Get the total duration for each that activity type
                    let activityTotalAmount = results.filter({$0.timestamp ?? Date() > Date().startOfMonth && $0.timestamp ?? Date() < Date().endOfMonth && $0.name == activity.name }).reduce(0) { $0 + $1.duration }
          
                    
                    if activityTotalAmount > topActivtiesArray.min(by: { $0.1 < $1.1 })?.1 ?? 0 || topActivtiesArray.count < 5 && activityTotalAmount != 0 {
                        
                        if topActivtiesArray.count < 5 {
                            topActivtiesArray.append((activity.name, activityTotalAmount))
                        } else {
                            topActivtiesArray.sort(by: { $0.1 > $1.1 })
                            topActivtiesArray.removeLast()
                            topActivtiesArray.append((activity.name, activityTotalAmount))
                        }
   
                    }
                }
            return topActivtiesArray.sorted(by: {$0.1 > $1.1})
        //Activity  with most ALL TIME
        } else if timeFrame == TimeFrame.allTime {
            
            var topActivtiesArray = [(String, Float)]()
            //Cycle through all activity types
            for activity in fetchRequest.wrappedValue {

                //Get the total duration for each that activity type
                let activityTotalAmount = results.filter({$0.name == activity.name }).reduce(0) { $0 + $1.duration }
                
                if activityTotalAmount > topActivtiesArray.min(by: { $0.1 < $1.1 })?.1 ?? 0 || topActivtiesArray.count < 5 && activityTotalAmount != 0 {
                    
                    if topActivtiesArray.count < 5 {
                        topActivtiesArray.append((activity.name, activityTotalAmount))
                    } else {
                        topActivtiesArray.sort(by: { $0.1 > $1.1 })
                        topActivtiesArray.removeLast()
                        topActivtiesArray.append((activity.name, activityTotalAmount))
                    }

                }
            }
            return topActivtiesArray.sorted(by: {$0.1 > $1.1})
            
        } else {
            return [("Unknown", Float(0.0))]
        }
        
    }
    
    
}
//
//struct StatsView_Previews: PreviewProvider {
//    static var previews: some View {
//        StatsView()
//    }
//}


//MARK: - Summary View
struct ActivitySummaryView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var useHours: Bool
    var allData: FetchedResults<AddedActivity>
    @State var totalSummary = ""
    var fetchRequest: FetchRequest<Activity>
    
    //Category Names
    @Binding var category1Name: String
    @Binding var category2Name: String
    @Binding var category3Name: String
    @Binding var category4Name: String
    
    @Binding var timeFrameChanger: TimeFrame
    
    var body: some View {
        
//        let kingActivity: (String, String) = mostActivityLoggedDuring(timeFrame: timeFrameChanger, results: allData)
        
        
        VStack {
            
            
            Text("Productivity Stats")
                .font(.title)
                .foregroundColor(Color("defaultYellow"))
                .padding(.vertical, 4)
            
            
//            HStack {
//                VStack(alignment: .center) {
//                    Text("Top \(timeFrameStringGetter(timeFrameChanger).capitalized) Activity:")
//                        .font(.system(size: 18, weight: .semibold))
//                        .foregroundColor(Color("defaultYellow"))
//                    Text("\(kingActivity.0) - \(kingActivity.1)mins")
//                        .font(.system(size: 18, weight: .semibold))
//                        .foregroundColor(Color("defaultYellow"))
//                }
//            }
//            .padding(.all, 6)
//            .foregroundColor(.white)
            
            ZStack {
                VStack(alignment: .center) {
                    
                    //Top 2 Categories
                    HStack(alignment: .top) {
                        Text("\(category1Name.capitalized): \(categorySummary(timeFrame: timeFrameChanger, results: allData, category: categoryStringGetter(Category.category1)))")
                            .padding(.horizontal, 10)
                            .foregroundColor(Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)))
                        
                        Text("\(category2Name.capitalized): \(categorySummary(timeFrame: timeFrameChanger, results: allData, category: categoryStringGetter(Category.category2)))")
                            .padding(.horizontal, 10)
                            .foregroundColor(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
                    }
                    .font(.system(size: 16, weight: .semibold))

                    //Bottom 2 categories
                    HStack(alignment: .top) {
                        Text("\(category3Name.capitalized): \(categorySummary(timeFrame: timeFrameChanger, results: allData, category: categoryStringGetter(Category.category3)))")
                            .padding(.horizontal, 10)
                            .foregroundColor(Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)))
                        Text("\(category4Name.capitalized): \(categorySummary(timeFrame: timeFrameChanger, results: allData, category: categoryStringGetter(Category.category4)))")
                            .padding(.horizontal, 10)
                            .foregroundColor(Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)))
                    }
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .font(.system(size: 16, weight: .semibold))
                    
                    
                    //Summary changer
                    HStack {
                        
                        Text("Weekly")
                            .foregroundColor(timeFrameChanger == TimeFrame.week ? .white : .gray)
                            .onTapGesture {
                                self.timeFrameChanger = TimeFrame.week
                            }
                            
                        Divider()
                        
                        Text("Monthly")
                            .foregroundColor(timeFrameChanger == TimeFrame.month ? .white : .gray)
                            .onTapGesture {
                                self.timeFrameChanger = TimeFrame.month
                            }
                        
                        Divider()
                        
                        Text("All-Time")
                            .foregroundColor(timeFrameChanger == .allTime ? .white : .gray)
                            .onTapGesture {
                                self.timeFrameChanger = TimeFrame.allTime
                            }
                    }
                    .padding(.top, 4)
                    
                    
                    
                    
                }
                .font(.system(size: 14))
                .foregroundColor(.white)
                .padding(.bottom)
            }
        }
        .frame(width: screen.size.width * 0.94, height: screen.size.height * 0.20)
        .background(Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1)))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .padding(.horizontal)
    }
    

    
    func categorySummary(timeFrame: TimeFrame, results: FetchedResults<AddedActivity>, category: String) -> String {
        
        if timeFrame == TimeFrame.week {
            return String(Int(results.filter({$0.category == category && $0.timestamp ?? Date() > Date().startOfWeek() && $0.timestamp ?? Date() < Date().startOfWeek().addingTimeInterval(7*24*60*60)}).reduce(0) { $0 + $1.duration }))
        } else if timeFrame == TimeFrame.month {
            return String(Int(results.filter({$0.category == category && $0.timestamp ?? Date() > Date().startOfMonth && $0.timestamp ?? Date() < Date().endOfMonth }).reduce(0) { $0 + $1.duration }))
        } else if timeFrame == TimeFrame.allTime {
            return String(Int(results.filter({$0.category == category}).reduce(0) { $0 + $1.duration }))
        } else {
            return String(Int(results.filter({$0.category == category}).reduce(0) { $0 + $1.duration }))
        }
        
    }
    
    
    
}
