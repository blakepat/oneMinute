//
//  StatsView.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-07-28.
//

import SwiftUI

struct StatsView: View {
    
    @StateObject private var viewModel = StatsViewModel()
    @Environment(\.presentationMode)  var presentationMode
    
    init (allData: FetchedResults<AddedActivity>, category1Name: Binding<String>, category2Name: Binding<String>, category3Name: Binding<String>, category4Name: Binding<String>, isHours: Binding<Bool>, date: Binding<Date>, showActivitySelectorView: Binding<Bool>, activityToShow: ObservedObject<ActivityToSave>) {
        
        self.allData = allData
        self._category1Name = category1Name
        self._category2Name = category2Name
        self._category3Name = category3Name
        self._category4Name = category4Name
        self._isHours = isHours
        self._date = date
        self._showActivitySelectorView = showActivitySelectorView
        self._activityToShow = activityToShow
        
        
        UITableView.appearance().backgroundColor = UIColor(Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1)))
        UITableView.appearance().separatorColor = .clear
    }
    
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
    @Binding var isHours: Bool
    @Binding var date: Date
    @Binding var showActivitySelectorView: Bool
    @ObservedObject var activityToShow: ActivityToSave
    
    //local variables
    @State private var activityName = "Select Category..."
//    let categories = ["category1", "category2", "category3", "category4"]
    @State private var showingAllActivities = true
    @State private var nameIndex = 0
    @State private var timeFrame = TimeFrame.week
    @State private var activeIndex = -1
    
    var body: some View {
        
        let categoryNames = [category1Name, category2Name, category3Name, category4Name]
        
        NavigationView {
            ZStack {
                
                //Background
                Color.minutesBackgroundBlack
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
                                        isHours: $isHours,
                                        date: date,
                                        timeFrameChanger: $timeFrame)
                        .padding(.top)
                    
                    
                    //MARK: - Date title
                    VStack(spacing: 0) {
                        
                        DateTitleView(timeFrame: timeFrame, date: date)
                            .padding(.vertical, 2)
                        
                        let activitiesThisTimeFrame = viewModel.getActivitiesForThis(timeFrame: timeFrame, activeIndex: activeIndex, data: allData, date: date).count
                        
                        
                        Text("\(activitiesThisTimeFrame) \(activeIndex != -1 ? categoryNames[activeIndex] + " " : "") \(activitiesThisTimeFrame == 1 ? "Session" : "Sessions") Completed")
                            .foregroundColor(.gray)
                        
                        //MARK: - Pie Chart View
                        
                        if viewModel.eachCategoryTotalDuration(timeFrame: timeFrame, results: allData, date: date).reduce(0) { $0 + $1 } > 0 {
                            
                            PieChartView(values: viewModel.eachCategoryTotalDuration(timeFrame: timeFrame, results: allData, date: date),
                                         colors: [Color("category1Color"), Color("category2Color"), Color("category3Color"), Color("category4Color")],
                                         names: [category1Name, category2Name, category3Name, category4Name],
                                         isHours: $isHours,
                                         backgroundColor: Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1)),
                                         innerRadiusFraction: 0.6,
                                         activeIndex: $activeIndex)
                                .padding(.horizontal, 16)
                                .frame(width: 360, height: 280)
                        
                                List {
                                    
                                    //List of top activities
                                    Text("Top Activities:")
                                        .fontWeight(.bold)
                                        .font(.title2)
                                        .foregroundColor(.white)
                                        .listRowBackground(Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1)))
                                    
                                    ForEach(Array(zip(viewModel.mostActivityLoggedDuring(timeFrame: timeFrame, results: allData, activityNames: fetchRequest, activeIndex: activeIndex, date: date).indices, viewModel.mostActivityLoggedDuring(timeFrame: timeFrame, results: allData, activityNames: fetchRequest, activeIndex: activeIndex, date: date))), id: \.0) { index, topItem in
                                        
                                        Text("\(index + 1): \(topItem.0)").bold() + Text(" - \(String(format: decimalsToShow(isHours: isHours), timeConverter(time: topItem.1, timeUnitIsHours: isHours))) \(timeUnitName(isHours: isHours))")
                                        
                                    }
                                    .foregroundColor(.white)
                                    .listRowBackground(Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1)))
                                    .padding(.vertical, 0)
                            
                                }
//                                .background(Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1)))
                                .environment(\.defaultMinListRowHeight, 10)
                                
                                    
                            } else {
                                
                                Text("No data to show for \nthis timeframe.")
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                                    .padding(.top)
                                
                            }
                                
                        Spacer()
                        
                    }
                    .frame(width: screen.size.width * 0.94)
                    .background(Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1)))
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .padding(.horizontal)
                    
                    
                    //Most productive day - maybe add this feature in version 2.0?
                                

                    //Add Other Stats here
                    
            
                }

            }
            .navigationTitle("Productivity Stats")
            .navigationBarTitleDisplayMode(.inline)
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
    @Binding var isHours: Bool
    var date: Date
    
    @Binding var timeFrameChanger: TimeFrame
    
    var body: some View {

            VStack {
                
                
                Text("Productive Time Breakdown")
                    .font(.title2)
                    .foregroundColor(Color.minutesYellow)
                    .padding(.vertical, 4)
                    .padding(.bottom, 4)
                
                
                ZStack {
                    VStack(alignment: .center) {
                        
                        //Top 2 Categories
                        HStack(alignment: .top) {
                            Text("\(category1Name.capitalized): \(timeConverter(time: categorySummary(timeFrame: timeFrameChanger, results: allData, category: categoryStringGetter(Category.category1)), timeUnitIsHours: isHours), specifier: decimalsToShow(isHours: isHours))")
                                .padding(.horizontal, 10)
                                .foregroundColor(Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)))
                            
                            Text("\(category2Name.capitalized): \(timeConverter(time: categorySummary(timeFrame: timeFrameChanger, results: allData, category: categoryStringGetter(Category.category2)), timeUnitIsHours: isHours), specifier: decimalsToShow(isHours: isHours))")
                                .padding(.horizontal, 10)
                                .foregroundColor(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
                        }
                        .font(.system(size: 16, weight: .semibold))

                        //Bottom 2 categories
                        HStack(alignment: .top) {
                            Text("\(category3Name.capitalized): \(timeConverter(time: categorySummary(timeFrame: timeFrameChanger, results: allData, category: categoryStringGetter(Category.category3)), timeUnitIsHours: isHours), specifier: decimalsToShow(isHours: isHours))")
                                .padding(.horizontal, 10)
                                .foregroundColor(Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)))
                            Text("\(category4Name.capitalized): \(timeConverter(time: categorySummary(timeFrame: timeFrameChanger, results: allData, category: categoryStringGetter(Category.category4)), timeUnitIsHours: isHours), specifier: decimalsToShow(isHours: isHours))")
                                .padding(.horizontal, 10)
                                .foregroundColor(Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)))
                        }
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .font(.system(size: 16, weight: .semibold))
                        
                        //Summary changer
                        HStack {
                            
                            Text("Week")
                                .foregroundColor(timeFrameChanger == TimeFrame.week ? .white : .gray)
                                .onTapGesture {
                                    self.timeFrameChanger = TimeFrame.week
                                }
                                
                            Divider()
                            
                            Text("Month")
                                .foregroundColor(timeFrameChanger == TimeFrame.month ? .white : .gray)
                                .onTapGesture {
                                    self.timeFrameChanger = TimeFrame.month
                                }
                            
                            Divider()
                            
                            Text("Total")
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
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .padding(.horizontal)
        }
    
    

    
    func categorySummary(timeFrame: TimeFrame, results: FetchedResults<AddedActivity>, category: String) -> Float {
        
        if timeFrame == TimeFrame.week {
            return results.filter({$0.category == category && $0.timestamp ?? Date() > date.startOfWeek() && $0.timestamp ?? Date() < date.startOfWeek().addingTimeInterval(7*24*60*60)}).reduce(0) { $0 + $1.duration }
        } else if timeFrame == TimeFrame.month {
            return results.filter({$0.category == category && $0.timestamp ?? Date() > date.startOfMonth && $0.timestamp ?? Date() < date.endOfMonth }).reduce(0) { $0 + $1.duration }
        } else if timeFrame == TimeFrame.allTime {
            return results.filter({$0.category == category}).reduce(0) { $0 + $1.duration }
        } else {
            return results.filter({$0.category == category}).reduce(0) { $0 + $1.duration }
        }
        
    }
    
    
    
}



struct DateTitleView: View {
    
    var timeFrame: TimeFrame
    var date: Date
    
    let dateFormatter: DateFormatter = {
        var df = DateFormatter()
        df.dateFormat = "EEE, MMM d"
        return df
    }()
    
    
    var body: some View {
        
        if timeFrame == TimeFrame.week {
            
            Text("\(date.startOfWeek(), formatter: dateFormatter) - \(date.endOfWeek, formatter: dateFormatter)")
                .font(.title2)
                .foregroundColor(Color.minutesYellow)
            
        } else if timeFrame == TimeFrame.month {
            
            Text("\(date.startOfMonth, formatter: dateFormatter) - \(date.endOfMonth, formatter: dateFormatter)")
                .font(.title2)
                .foregroundColor(Color.minutesYellow)
            
        } else {
            
            Text("All Activities Recorded")
                .font(.title2)
                .foregroundColor(Color.minutesYellow)
            
        }
        
    }
    
    
}

