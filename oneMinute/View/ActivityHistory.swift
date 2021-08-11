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
    @State var activityName = "Select Category..."
    @Binding var showActivitySelectorView: Bool
    @State var activityToShow: ActivityToSave
    let categories = ["category1", "category2", "category3", "category4"]
    @State var showingAllActivities = true
    @State var nameIndex = 0
    
   
    
    var body: some View {
        
        let categoryNames = [category1Name, category2Name, category3Name, category4Name]
        
        ZStack {
            //Background
            Color(#colorLiteral(red: 0.2082437575, green: 0.2156656086, blue: 0.2157248855, alpha: 1))
                .edgesIgnoringSafeArea(.all)
        
            //VStack of different areas of Activity History Screen
            VStack {
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
                                    self.activityToShow.category = category
                                    self.activityName = "Select Activity..."
                                    self.showingAllActivities = false
                                    self.nameIndex = index
                                })
                            //Other 3 categories
                            } else {
                                ActivityTypeIcon(activityIconName: category, activityName: categoryNames[index], isSelected: false, font: 24, iconSizeScreenDividedBy: 6)
                                    .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                                        activityToShow.category = category
                                        self.activityName = "Select Activity..."
                                        self.activityToShow.activityName = "Select Activity..."
                                        self.showingAllActivities = false
                                        self.nameIndex = index
                                    })
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
                                    if !showingAllActivities { self.showActivitySelectorView = true }
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
                                    .padding(.leading, 4)
                                    .padding(.vertical, 4)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        activityToShow.activityName = "Select Activity..."
                                        activityToShow.category = "category0"
                                        self.activityName = "Select Category..."
                                        self.showingAllActivities = true
                                    }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.trailing, 4)
              

                    
                    //Title
                    HStack {
                        
                        let titleText : String = {
                            if showingAllActivities {
                                return "All Activities Summary"
                            } else if activityToShow.activityName == "Select Activity..." {
                                return "\(categoryNames[nameIndex]) Summary"
                            } else {
                                return "Activity Summary"
                            }
                        }()

                        
                        
                        Text(titleText)
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(showingAllActivities ? Color("defaultYellow") : Color("\(activityToShow.category)Color"))
                        
                        Spacer()
                    }
                    
                    .padding(.horizontal, 10)
                    
                    
                    let activityAllTime = allData.filter({ showingAllActivities ? $0.timestamp! < Date().addingTimeInterval(999999999) : activityName == "Select Activity..." ? $0.category == activityToShow.category : $0.name == activityToShow.activityName })
                     
            
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
                    
                        HStack {
                            Text("This Month:")
                                .fontWeight(.bold)
                            let activityThisMonth = activityAllTime.filter({$0.timestamp ?? Date() > Date().startOfMonth && $0.timestamp ?? Date() < Date().endOfMonth })
                                                               
                            let activityMinutesThisMonth = activityThisMonth.reduce(0) { $0 + $1.duration }
                            let activitySessionsThisMonth = activityThisMonth.count
                                                               
                            Text("\(Int(activityMinutesThisMonth)) mins (\(activitySessionsThisMonth) sessions x \(Int(dividBy(lhs:Float(activityMinutesThisMonth), rhs:Float(activitySessionsThisMonth)))))")
                            Spacer()
                        }
            
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
                    .padding(.horizontal, 10)
        
                    
                    //List of recent times recorded (days since last recorded, days between recordings, display of each record)
                    HStack {
                        Text("Recently Logged")
                            .foregroundColor(showingAllActivities ? Color("defaultYellow") : Color("\(activityToShow.category)Color"))
                            .font(.system(size: 24, weight: .semibold))
                            .padding(.leading, 8)
                        Spacer()
                    }
                    .padding(.vertical, 0)
                    .padding(.top, 8)
                    
                    
                    
                    //Most recent recorded activity of selected type
                    ScrollView(.vertical) {
                        
                        let sortedActivities = activityAllTime.sorted {
                            $0.timestamp ?? Date() > $1.timestamp ?? Date()
                            
                        }.prefix(20)
                    
                        ForEach(0..<sortedActivities.count, id: \.self) { index in
                        
                            //Days since activity below/since previous activity in list
                            if !sortedActivities.isEmpty {
                                let timeBetweenActivities = Calendar.current.numberOfDaysBetween(from: sortedActivities[index].timestamp ?? Date(), to: (index == 0) ? Date() : sortedActivities[index-1].timestamp ?? Date())
                                //Days since or between activties
                                HStack {
                                    Spacer()
                                    Text((index == 0) ? "· \(timeBetweenActivities) day(s) since ·" : "· \(timeBetweenActivities) day(s) between ·")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14))
                                        .padding(0)
                                    Spacer()
                                }
                            //Logged Activity
                                RecentActivityLog(activity: sortedActivities[index])
                                    .padding(.horizontal, 16)
                            }
                        }
                        .listRowBackground(Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1)))
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    .padding(.top, 0)
                }
                .frame(width: screen.width - 24)
                .background(Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1)))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 16)
                .edgesIgnoringSafeArea(.bottom)
                
                
        
        Spacer()
            }
            .edgesIgnoringSafeArea(.bottom)
            .padding(.top, 12)
        }
        .edgesIgnoringSafeArea(.bottom)
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
