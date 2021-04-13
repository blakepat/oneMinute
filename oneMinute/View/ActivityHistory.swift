//
//  ActivityHistory.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-03-24.
//

import SwiftUI

struct ActivityHistory: View {
    
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
    @State var activityName = "Select Activity..."
    @Binding var showActivitySelectorView: Bool
    @State var activityToShow: ActivityToSave
    let categories = ["category1", "category2", "category3", "category4"]
    @State var showingAllActivities = true
    
   
    
    var body: some View {
        
        let categoryNames = [category1Name, category2Name, category3Name, category4Name]
        
        ZStack {
        
            //Background
            Color(#colorLiteral(red: 0.2082437575, green: 0.2156656086, blue: 0.2157248855, alpha: 1))
                .edgesIgnoringSafeArea(.all)
        
    
            //VStack of different areas of Activity History Screen
            VStack {
                
                    
            
        
                //MARK: - Summary View but for highest scores (which activity has most minutes) in week/month/year, but once an activity in selected it becomes scores for that activity only
                ActivitySummaryView(useHours: false,
                                    allData: allData,
                                    fetchRequest: fetchRequest,
                                    category1Name: $category1Name,
                                    category2Name: $category2Name,
                                    category3Name: $category3Name,
                                    category4Name: $category4Name)
        
        
        
        
                //MARK: - Activity Summary (total times logged, total minutes, days since last, last dates completed (with notes)
                VStack {
                    
                    //search feature to pick activity, use activitySelectorView
                    //MARK: - Activity Type - (fitness, chores, learning, work)
                    HStack {
                        ForEach(Array(zip(categories, categories.indices)), id: \.0) { category, index in
                            //Current Selected Activity Category
                            if activityToShow.category == category {
                            
                                ActivityTypeIcon(activityIconName: category, activityName: categoryNames[index], isSelected: true, font: 24, iconSizeScreenDividedBy: 6)
                                .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                                    self.showActivitySelectorView = true
                                    activityToShow.category = category
                                })
                                //MARK: - ActivitySelectorView
                                .sheet(isPresented: $showActivitySelectorView, onDismiss: {
                                    self.showActivitySelectorView = false
                                    self.activityName = self.activityToShow.activityName
                                    print(activityToShow.activityName)
                                    self.showingAllActivities = false
                                    
                                })
                                {
                                    ActivitySelectorView(filter: activityToShow.category, showActivitySelector: $showActivitySelectorView, allActivities: activities, categoryNames: categoryNames)
                                        .environmentObject(activityToShow)
                                }
                            //Other 3 categories
                            } else {
                                ActivityTypeIcon(activityIconName: category, activityName: categoryNames[index], isSelected: false, font: 24, iconSizeScreenDividedBy: 6)
                                    .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                                        self.showActivitySelectorView = true
                                        activityToShow.category = category
                                        self.activityName = "Select Activity..."
                                        self.activityToShow.activityName = "Select Activity..."
                                    })
                                    //MARK: - ActivitySelectorView
                                    .sheet(isPresented: $showActivitySelectorView, onDismiss: {
                                        self.showActivitySelectorView = false
                                        self.activityName = self.activityToShow.activityName
                                        self.showingAllActivities = false
                                        print(activityToShow.activityName)
                                        
                                    })
                                    {
                                        ActivitySelectorView(filter: activityToShow.category, showActivitySelector: $showActivitySelectorView, allActivities: activities, categoryNames: categoryNames)
                                            .environmentObject(activityToShow)
                                    }
                                
                            }
                        }
                    }
                    .frame(width: screen.width - 32, height: screen.width / 5, alignment: .center)
                    .padding(.bottom, 4)
                    .padding(.top, 12)
                    
                    //MARK: - activity selector / name display
                    HStack(spacing: 4) {

                        ZStack(alignment: .leading) {
                            
                            Text(self.activityName)
                                .frame(width: screen.width - 54, height: 32, alignment: .leading)
                                .padding(.leading, 4)
                                .padding(.horizontal, 6)
                                .background(Color(.black))
                                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                .foregroundColor(Color("\(activityToShow.category)Color"))
                                .font(.system(size: 22))
                                .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                                    self.showActivitySelectorView = true
                                })
                                //MARK: - ActivitySelectorView
                                .sheet(isPresented: $showActivitySelectorView, onDismiss: {
                                    self.showActivitySelectorView = false
                                    self.activityName = self.activityToShow.activityName
                                    print(activityToShow.activityName)
                                    self.showingAllActivities = false
                                    
                                })
                                {
                                    ActivitySelectorView(filter: activityToShow.category, showActivitySelector: $showActivitySelectorView, allActivities: activities, categoryNames: categoryNames)
                                        .environmentObject(activityToShow)
                                }
                            
                            HStack {
                                Spacer()
                                Text("reset")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 16)
                                    .onTapGesture {
                                        activityToShow.activityName = "Select Activity..."
                                        activityName = "Select Activity..."
                                        self.showingAllActivities = true
                                    }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.trailing, 4)
              
            
                    //Title
                    HStack {
                        Text(showingAllActivities ? "All Activties Summary" : "Activity Summary")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(showingAllActivities ? Color("defaultYellow") : Color("\(activityToShow.category)Color"))
                        
                        Spacer()
                    }
                    
                    .padding(.horizontal, 10)
                    
                    
                    let activityAllTime = allData.filter({ showingAllActivities ? $0.timestamp! < Date().addingTimeInterval(999999999) : $0.name == activityToShow.activityName })
                     
            
                    //Minutes in time period
                    VStack(spacing: 0) {
                        HStack {
                            Text("This Week:")
                                .fontWeight(.bold)
                            let activityThisWeek = activityAllTime.filter({$0.timestamp ?? Date() > Date().startOfWeek() && $0.timestamp ?? Date() < Date().startOfWeek().addingTimeInterval(7*24*60*60)})
                                                              
                            let activityMinutesThisWeek = activityThisWeek.reduce(0) { $0 + $1.duration }
                            let activitySessionsThisWeek = activityThisWeek.count
                                                                        
                                                                    
                            Text("\(Int(activityMinutesThisWeek)) mins (\(activitySessionsThisWeek) sessions x \(Int(dividBy(lhs:Float(activityMinutesThisWeek), rhs:Float(activitySessionsThisWeek)))))")
                            Spacer()
                        }
                        Divider()
                            .foregroundColor(.white)
                        
                        HStack {
                            Text("This Month:")
                                .fontWeight(.bold)
                            let activityThisMonth = activityAllTime.filter({$0.timestamp ?? Date() > Date().startOfMonth && $0.timestamp ?? Date() < Date().endOfMonth })
                                                               
                            let activityMinutesThisMonth = activityThisMonth.reduce(0) { $0 + $1.duration }
                            let activitySessionsThisMonth = activityThisMonth.count
                                                               
                            Text("\(Int(activityMinutesThisMonth)) mins (\(activitySessionsThisMonth) sessions x \(Int(dividBy(lhs:Float(activityMinutesThisMonth), rhs:Float(activitySessionsThisMonth)))))")
                            Spacer()
                        }
                        Divider()
                            .foregroundColor(.white)
                        
                        HStack {
                            Text("All-Time:")
                                .fontWeight(.bold)
                            let activityMinutesAllTime = activityAllTime.reduce(0) { $0 + $1.duration }
                            let activitySessionsAllTime = activityAllTime.count
                            Text("\(Int(activityMinutesAllTime)) mins (\(activitySessionsAllTime) sessions x \(Int(dividBy(lhs:Float(activityMinutesAllTime), rhs:Float(activitySessionsAllTime)))))")
                            Spacer()
                        }
                    }
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(.bottom, 8)
                    .padding(.horizontal, 10)
        
                    
                    //List of recent times recorded (days since last recorded, days between recordings, display of each record)
                    HStack {
                        Text("Recently Logged")
                            .foregroundColor(showingAllActivities ? Color("defaultYellow") : Color("\(activityToShow.category)Color"))
                            .font(.system(size: 24, weight: .semibold))
                            .padding(.leading, 8)
                        Spacer()
                    }
                    .padding(.bottom, 0)
                    
                    //Most recent recorded activity of selected type
                    List {
                        
                        let activityTimeSeperator = Date()
                        
                        ForEach(activityAllTime.sorted { $0.timestamp ?? Date() > $1.timestamp ?? Date() }.prefix(8)) { activity in
                        
                            //Days since activity below/since previous activity in list

                            let timeBetweenActivities = Calendar.current.numberOfDaysBetween(from: activity.timestamp ?? Date(), to: activityTimeSeperator)
                            
                            Text("\(timeBetweenActivities) days since logged")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                            
//                            activityTimeSeperator = activity.timestamp ?? Date()
                            
                            //Logged Activity
                            RecentActivityLog(activity: activity)
                        }
                        .listRowBackground(Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1)))
                    }
                    .padding(.top, 0)
                }
                .frame(width: screen.width - 24)
                .background(Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1)))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 16)
                
                
        
        Spacer()
            }
            .padding(.top, 12)
        }
    }
}








//MARK: - Summary View
struct ActivitySummaryView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var useHours: Bool
    var allData: FetchedResults<AddedActivity>
    @State var timeFrameChanger = TimeFrame.month
    @State var totalSummary = ""
    var fetchRequest: FetchRequest<Activity>
    
    //Category Names
    @Binding var category1Name: String
    @Binding var category2Name: String
    @Binding var category3Name: String
    @Binding var category4Name: String
    
    var body: some View {
        
        let kingActivity: (String, String) = mostActivityLoggedDuring(timeFrame: timeFrameChanger, results: allData)
        
        
        VStack {
            HStack {
                HStack {
                    Text("Top \(timeFrameStringGetter(timeFrameChanger).capitalized) Activity: \(kingActivity.0), \(kingActivity.1)")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color("defaultYellow"))
                    Text("")
                        .font(.system(size: 20))
                }
            }
            .padding(.all, 6)
            .foregroundColor(.white)
            
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
    
    //Cycle through all actvitiesAdded and get which ones are done the most based on timeFrame provided
    func mostActivityLoggedDuring(timeFrame: TimeFrame, results: FetchedResults<AddedActivity>) -> (String, String) {
        
        if timeFrame == TimeFrame.week {
            
            var largestActivityAmountSoFar = 0
            var activityWithMost = "Unknown"
            
            //Cycle through all activity types
            for activity in fetchRequest.wrappedValue {

                //Get the total duration for each that activity type
                let activityTotalAmount = Int(results.filter({$0.timestamp ?? Date() > Date().startOfWeek() && $0.timestamp ?? Date() < Date().endOfWeek && $0.name == activity.name }).reduce(0) { $0 + $1.duration })
                
                if activityTotalAmount > largestActivityAmountSoFar {
                    largestActivityAmountSoFar = activityTotalAmount
                    activityWithMost = activity.name
                }
            }
            return (activityWithMost, String(largestActivityAmountSoFar))
        //Activity with Most this Month
        } else if timeFrame == TimeFrame.month {
                var largestActivityAmountSoFar = 0
                var activityWithMost = "Unknown"
                //Cycle through all activity types
                for activity in fetchRequest.wrappedValue {

                    //Get the total duration for each that activity type
                    let activityTotalAmount = Int(results.filter({$0.timestamp ?? Date() > Date().startOfMonth && $0.timestamp ?? Date() < Date().endOfMonth && $0.name == activity.name }).reduce(0) { $0 + $1.duration })
                    
                    if activityTotalAmount > largestActivityAmountSoFar {
                        largestActivityAmountSoFar = activityTotalAmount
                        activityWithMost = activity.name
                    }
                }
                return (activityWithMost, String(largestActivityAmountSoFar))
        //Activity  with most ALL TIME
        } else if timeFrame == TimeFrame.allTime {
            var largestActivityAmountSoFar = 0
            var activityWithMost = "Unknown"
            //Cycle through all activity types
            for activity in fetchRequest.wrappedValue {

                //Get the total duration for each that activity type
                let activityTotalAmount = Int(results.filter({$0.name == activity.name }).reduce(0) { $0 + $1.duration })
                
                if activityTotalAmount > largestActivityAmountSoFar {
                    largestActivityAmountSoFar = activityTotalAmount
                    activityWithMost = activity.name
                }
            }
            return (activityWithMost, String(largestActivityAmountSoFar))
            
        } else {
            return ("Unknown", "0")
        }
        
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

struct RecentActivityLog: View {
    
    var activity: AddedActivity
    
    var body: some View {
        
        VStack {
            
            //Activity Name (only shown if listing all activities
            HStack {
                Text("\(activity.name ?? "Unknown Activity")")
                    .fontWeight(.bold)
                
                Spacer()
            }
            
            //Activity date
            HStack {
                Text(activity.timestamp?.getFormattedDate(format: "EEEE, MMMM, d, yyyy, h:mma") ?? "Unknown Date")
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            //Activity Length
            HStack {
                Text("Minutes: \(Int(activity.duration))")
                
                Spacer()
            }
            
            //Activity Notes
            HStack {
                Text("Notes: \(activity.notes ?? "none")")
                
                Spacer()
            }
        }
        .padding(4)
        .foregroundColor(.white)
        .background(Color(#colorLiteral(red: 0.2082437575, green: 0.2156656086, blue: 0.2157248855, alpha: 1)))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        
    }
}
