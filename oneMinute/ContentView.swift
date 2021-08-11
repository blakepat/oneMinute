//
//  ContentView.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2020-11-04.
//

import SwiftUI
import CoreData

struct ContentView: View {
     
    //Fetch saved activities
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: AddedActivity.entity(), sortDescriptors: [])
    var allSavedActivities:FetchedResults<AddedActivity>
    
    //@States for showing views
    @State var showLastWeek = false
    @State var showDetailedDay = false
    @State var showAddActivity = false
    @State var showActivitySelector = false
    @State var showAddFavourite = false
    @State var showEditScreen = false
    @State var showCategoryNameEditor = false
    @State var showHistoryView = false
    @State var showStatsView = false
    
    //Variables
    @State var selectedDate = Date()
    @State var activityToDelete = AddedActivity()
    @ObservedObject var activityToSave = ActivityToSave()
    
    
    //Tab bar variables
    @State var selectedIndex = 0
    @State var shouldShowModal = false
    let tabBarImageNames = ["chart.bar.doc.horizontal", "book.circle.fill", "plus.app.fill", "bookmark.circle.fill", "gear"]
    @State var activeSheet: ActiveSheet?
    
    
    //MARK: - Category Names
    @State var category1Name = UserDefaults.standard.string(forKey: "category1Name")!
    @State var category2Name = UserDefaults.standard.string(forKey: "category2Name")!
    @State var category3Name = UserDefaults.standard.string(forKey: "category3Name")!
    @State var category4Name = UserDefaults.standard.string(forKey: "category4Name")!
    
    //Week Date Data
    var currentWeek : [Date] {
        Array(stride(from: Date().startOfWeek(), through: Date().startOfWeek().addingTimeInterval(6*60*60*24), by:  60*60*24))
    }
    var lastWeek : [Date] {
        Array(stride(from: Date().startOfWeek().addingTimeInterval(-6*24*60*60), to: Date().startOfWeek(), by:  60*60*24))
    }
    let dates = [Date(), Date().addingTimeInterval(-60*60*24*7), Date().addingTimeInterval(-60*60*24*14), Date().addingTimeInterval(-60*60*24*21)]
    
    var body: some View {

        ZStack {
            //Background Color
            Color.black
                .edgesIgnoringSafeArea(.all)

            VStack {
                //Week Toggle at top
                WeekToggle(showLastWeek: $showLastWeek, dateSelected: $selectedDate)
                    .padding(.top, 4)
                //Current Date
                //Week Dates Button
                HStack {
                    Image(systemName: "calendar.circle")
                        .font(.system(size: 36))
                        .foregroundColor(.white)
                        .frame(width: 24)
                
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .frame(width: 100, height: 50, alignment: .leading)
                        
                    Spacer()

                }
                .frame(height: 16)
                .padding(.leading, 16)
                .padding(.leading, screen.size.width * 0.03)
                .padding(.vertical, 8)
                
            
                //Mark: - Week Summary and day scroll view
                SummaryView(
                    selectedDate: selectedDate,
                    allData: allSavedActivities,
                    category1Name: $category1Name,
                    category2Name: $category2Name,
                    category3Name: $category3Name,
                    category4Name: $category4Name
                )
                
                //View of days of the week
                DayScrollView(
                    showDetailedDayView: $showDetailedDay,
                    selectedDate: $selectedDate,
                    showEditScreen: $showEditScreen,
                    activityToSave: activityToSave,
                    category1Name: $category1Name,
                    category2Name: $category2Name,
                    category3Name: $category3Name,
                    category4Name: $category4Name,
                    weekOnlyData: allSavedActivities.filter({ $0.timestamp! > selectedDate.startOfWeek() && $0.timestamp! < selectedDate.endOfWeek }
                                                        
                    ), activeSheet: $activeSheet
                )
                .padding(.leading, screen.size.width * 0.01)
                    
                //MARK: - Last 5 Weeks Chart and Buttons
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        //Chart
                        BarChart(
                            selectedDate: $selectedDate,
                            weekOneData: allSavedActivities.filter({ $0.timestamp ?? Date() > dates[0].startOfWeek() && $0.timestamp ?? Date() < dates[0].endOfWeek}),
                            weekTwoData: allSavedActivities.filter({ $0.timestamp ?? Date() > dates[1].startOfWeek() && $0.timestamp ?? Date() < dates[1].endOfWeek}),
                            weekThreeData: allSavedActivities.filter({ $0.timestamp ?? Date() > dates[2].startOfWeek() && $0.timestamp ?? Date() < dates[2].endOfWeek}),
                            weekFourData: allSavedActivities.filter({ $0.timestamp ?? Date() > dates[3].startOfWeek() && $0.timestamp ?? Date() < dates[3].endOfWeek})
                        )
                        Spacer()
                    }
                }
                .frame(width: screen.size.width - 50)
                .padding(.leading, screen.size.width * 0.03)
                .padding(.horizontal)
                .padding(.vertical, 2)

                Spacer()
            
                Divider()
                    .frame(height: 6)
                    .foregroundColor(.init(white: 0.8))
            
                
                //MARK: - Tab Bar
                HStack{
                    ForEach(0..<5) { num in
                        Button(action: {
                            //Button Fuctions:
                            selectedIndex = num
                            
                            //Show Stats View Button
                            if num == 0 {
                                shouldShowModal.toggle()
                                activeSheet = .first
                                self.showStatsView.toggle()
                            }
                            
                            //History Button
                            if num == 1 {
                                shouldShowModal.toggle()
                                activeSheet = .second
                                self.showHistoryView.toggle()
                                return
                            }

                            //Add Activity Button
                            if num == 2 {
                                shouldShowModal.toggle()
                                activeSheet = .third
                                self.showAddActivity.toggle()
                                return
                            }
                            //Add Favourite Button
                            if num == 3 {
                                shouldShowModal.toggle()
                                activeSheet = .fourth
                                self.showAddFavourite.toggle()
                                return
                            }
                            
                        }
                        , label: {
                            
                            //Button Images:
                            Spacer()
                            
                            //Add Activity Button
                            if num == 2 {
                                ZStack {
                                    let colorArray: [Color] = [Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)), Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)), Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))]
                                    
                                    LinearGradient(gradient: Gradient(colors: colorArray), startPoint: .topLeading, endPoint: .bottomTrailing)
                                        .mask(Image(systemName: "plus.circle.fill")
                                                .font(.system(size: 36)))
                                        .frame(width: 36, height: 36, alignment: .center)
                                    
                                }
//                                .sheet(isPresented: $showAddActivity, onDismiss: {
//                                    self.showAddActivity = false
//                                    self.showActivitySelector = false
//                                    self.showCategoryNameEditor = false
//                                    resetActivity(activityToSave)
//                                }) {
//                                    //MARK: - Add activity view
//                                    AddActivityView(showActivitySelector: $showActivitySelector,
//                                                    showAddActivity: $showAddActivity,
//                                                    selectedDate: $selectedDate,
//                                                    itemToDelete: $activityToDelete,
//                                                    showingNameEditor: $showCategoryNameEditor,
//                                                    activityToSave: activityToSave,
//                                                    isEditScreen: false,
//                                                    categorySelected: false,
//                                                    category1Name: $category1Name,
//                                                    category2Name: $category2Name,
//                                                    category3Name: $category3Name,
//                                                    category4Name: $category4Name)
//                                }


                                
                                Spacer()
                            //All other button images
                            } else {
                                Image(systemName: tabBarImageNames[num])
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(selectedIndex == num && shouldShowModal ? .yellow : .init(white: 0.8))
//                                    .sheet(isPresented: $showHistoryView, onDismiss: {
//                                        self.showHistoryView = false
//                                    }) {
//                                        //MARK: - show history view
//                                        ActivityHistory(allData: allSavedActivities,
//                                                        category1Name: $category1Name,
//                                                        category2Name: $category2Name,
//                                                        category3Name: $category3Name,
//                                                        category4Name: $category4Name,
//                                                        showActivitySelectorView: $showActivitySelector,
//                                                        activityToShow: activityToSave)
//                                    }
                                Spacer()
                                
                            }
                        })
                    }
                    Spacer()
                }
                .padding(.bottom)
                .padding(.vertical, 4)
                .edgesIgnoringSafeArea(.bottom)
                .background(Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1)))
                .sheet(item: $activeSheet,
                       onDismiss: {
                        self.showStatsView = false
                        self.showAddFavourite = false
                        self.showHistoryView = false
                        self.showAddActivity = false
                        self.showActivitySelector = false
                        self.showCategoryNameEditor = false
                        self.shouldShowModal = false
                        self.activeSheet = nil
                        resetActivity(activityToSave)
                        
                       } , content: { item in
//                    //Switch between views
                    switch item {
                    case .first:
                        StatsView(allData: allSavedActivities,
                                        category1Name: $category1Name,
                                        category2Name: $category2Name,
                                        category3Name: $category3Name,
                                        category4Name: $category4Name,
                                        showActivitySelectorView: $showActivitySelector,
                                        activityToShow: activityToSave)
                    case .second:
                        ActivityHistory(allData: allSavedActivities,
                                        category1Name: $category1Name,
                                        category2Name: $category2Name,
                                        category3Name: $category3Name,
                                        category4Name: $category4Name,
                                        showActivitySelectorView: $showActivitySelector,
                                        activityToShow: activityToSave)
                    case .third:
                        AddActivityView(showActivitySelector: $showActivitySelector,
                                        showAddActivity: $showAddActivity,
                                        selectedDate: $selectedDate,
                                        itemToDelete: $activityToDelete,
                                        showingNameEditor: $showCategoryNameEditor,
//                                        activityToSave: activityToSave,
                                        isEditScreen: false,
                                        categorySelected: false,
                                        category1Name: $category1Name,
                                        category2Name: $category2Name,
                                        category3Name: $category3Name,
                                        category4Name: $category4Name,
                                        activeSheet: $activeSheet)
                            .environmentObject(activityToSave)
                            
                    case .fourth:
                        AddFavouriteView(
                            activityToSave: activityToSave,
                            activities: allSavedActivities,
                            showAddFavourite: $showAddFavourite,
                            category1Name: $category1Name,
                            category2Name: $category2Name,
                            category3Name: $category3Name,
                            category4Name: $category4Name,
                            activeSheet: $activeSheet)
                        .environmentObject(activityToSave)
                    case .fifth:
                        AddFavouriteView(
                        activityToSave: activityToSave,
                        activities: allSavedActivities,
                        showAddFavourite: $showAddFavourite,
                        category1Name: $category1Name,
                        category2Name: $category2Name,
                        category3Name: $category3Name,
                        category4Name: $category4Name,
                            activeSheet: $activeSheet)
                    .environmentObject(activityToSave)
                    }
                })
            }
            .padding(.horizontal, 16)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    //MARK: - Reset Activity Function
    private func resetActivity(_ : ActivityToSave) {
        activityToSave.activityName = "Select Activity"
        activityToSave.category = "category0"
        activityToSave.hours = 0
        activityToSave.minutes = 0
        activityToSave.notes = ""
    }
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}



//MARK: - Last Week/Current Week Toggle
struct WeekToggle: View {
    
    @Binding var showLastWeek: Bool
    @Binding var dateSelected: Date
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Last Week")
                    .padding(.horizontal, 30)
                    .foregroundColor(showLastWeek ? Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)) : Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                    .frame(width: screen.size.width / 2 - 1)
                    .onTapGesture(count: 1, perform: {
                        showLastWeek = true
                        dateSelected = Date().startOfWeek().addingTimeInterval(-6*24*60*60)
                        
                    })

                
                Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1))
                    .frame(width: 2, height: 50, alignment: .center)
                
                Text("This Week")
                    .padding(.horizontal, 30)
                    .foregroundColor(showLastWeek ? Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)) : Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)) )
                    .frame(width: screen.size.width / 2 - 1)
                    .onTapGesture(count: 1, perform: {
                        showLastWeek = false
                        dateSelected = Date()
                    })
                
            }
            .font(.system(size: 24, weight: .bold))
            
            ZStack {
                Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1))
                    .frame(width: screen.width, height: 2, alignment: .center)
                Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
                    .frame(width: screen.width / 2, height: 4, alignment: .leading)
                    .position(x: showLastWeek ? 0 + screen.width / 4 : screen.width / 2 + screen.width / 4)
                    .animation(.easeInOut)
            }
            .frame(width: screen.width, height: 4, alignment: .center)
        }
    }
}


//MARK: - Date
struct DateView: View {
    
    let dateFormatter: DateFormatter = {
        var df = DateFormatter()
        df.dateFormat = "EEEE, MMM, d, yyyy"
        return df
    }()
    
    var body: some View {
        HStack {
            Text("\(Date(), formatter: dateFormatter)")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .semibold))
            Spacer()
        }
        .padding(.horizontal)
    }
}


//MARK: - Summary View
struct SummaryView: View {
        
        @Environment(\.managedObjectContext) private var viewContext
        
        var selectedDate: Date
        var allData: FetchedResults<AddedActivity>
        @State var timeFrameChanger = TimeFrame.week
        @State var totalSummary = ""
        
        //Category Names
        @Binding var category1Name: String
        @Binding var category2Name: String
        @Binding var category3Name: String
        @Binding var category4Name: String
        
        var body: some View {
            
            VStack {
                HStack {
                    HStack {
                        Text("Total \(timeFrameStringGetter(timeFrameChanger).capitalized) Minutes: \(totalSummary(timeFrame: timeFrameChanger, results: allData))")
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
            .frame(width: screen.size.width * 0.94, height: screen.size.height * 0.16)
            .background(Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1)))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .padding(.horizontal)
        }
        
        
        func totalSummary(timeFrame: TimeFrame, results: FetchedResults<AddedActivity>) -> String {
            
            if timeFrame == TimeFrame.week {
                return String(Int(results.filter({$0.timestamp ?? Date() > selectedDate.startOfWeek() && $0.timestamp ?? Date() < selectedDate.startOfWeek().addingTimeInterval(7*24*60*60)}).reduce(0) { $0 + $1.duration }))
            } else if timeFrame == TimeFrame.month {
                return String(Int(results.filter({$0.timestamp ?? Date() > selectedDate.startOfMonth && $0.timestamp ?? Date() < selectedDate.endOfMonth }).reduce(0) { $0 + $1.duration }))
            } else if timeFrame == TimeFrame.allTime {
                return String(Int(results.reduce(0) { $0 + $1.duration }))
            } else {
                return String(Int(results.reduce(0) { $0 + $1.duration }))
            }
        }
        
        
        func categorySummary(timeFrame: TimeFrame, results: FetchedResults<AddedActivity>, category: String) -> String {
            
            if timeFrame == TimeFrame.week {
                return String(Int(results.filter({$0.category == category && $0.timestamp ?? Date() > selectedDate.startOfWeek() && $0.timestamp ?? Date() < selectedDate.startOfWeek().addingTimeInterval(7*24*60*60)}).reduce(0) { $0 + $1.duration }))
            } else if timeFrame == TimeFrame.month {
                return String(Int(results.filter({$0.category == category && $0.timestamp ?? Date() > selectedDate.startOfMonth && $0.timestamp ?? Date() < selectedDate.endOfMonth }).reduce(0) { $0 + $1.duration }))
            } else if timeFrame == TimeFrame.allTime {
                return String(Int(results.filter({$0.category == category}).reduce(0) { $0 + $1.duration }))
            } else {
                return String(Int(results.filter({$0.category == category}).reduce(0) { $0 + $1.duration }))
            }
            
        }
}

//MARK: - Day Scroll View
class ScrollToModel: ObservableObject {
    enum Action {
        case end
        case top
        case point(point: Int)
    }
    @Published var direction: Action? = nil
}


struct DayScrollView: View {
    
    @Binding var showDetailedDayView: Bool
    @Binding var selectedDate: Date
    @Binding var showEditScreen: Bool
    @ObservedObject var activityToSave: ActivityToSave
    @Binding var category1Name: String
    @Binding var category2Name: String
    @Binding var category3Name: String
    @Binding var category4Name: String
    
    
    @StateObject var scrollObject = ScrollToModel()
    
    var weekOnlyData: [AddedActivity]
    
    let dateFormatter: DateFormatter = {
        var df = DateFormatter()
        df.dateFormat = "EEEE d"
        return df
    }()
    
    @Binding var activeSheet: ActiveSheet?
    
    var body: some View {
        
        let weekToDisplay = Date.dates(from: selectedDate.startOfWeek(), to: selectedDate.endOfWeek)
        
        ScrollView(.horizontal) {
            ScrollViewReader { sp in
                HStack(spacing: 4) {
                    //Cycle through days of either last week or this week
                    ForEach((weekToDisplay), id: \.self) { day in
                        GeometryReader { geometry in
                            VStack{
                                HStack {
                                    Spacer()
                                    Text("\(day, formatter: dateFormatter)")
                                        .foregroundColor((Calendar.current.isDate(day, inSameDayAs: Date())) ? Color("defaultYellow") : .white)
                                        .font(.system(size: 20, weight: (Calendar.current.isDate(day, inSameDayAs: Date())) ? .bold : .semibold))
                                    Spacer()
                                }.padding(.vertical, 4)
                                ScrollView(.vertical) {
                                    //For each day fill in information if dates match
                                    ForEach(weekOnlyData.filter({ Calendar.current.isDate($0.timestamp ?? Date(), inSameDayAs: day)}), id: \.self) { data in
                                        
//                                        Print(day)
                                        
                                        ActivityItem(item: data)
                                            .padding(.bottom, 2)
                                            .frame(width: 132)
                                    }
                                }
                                Spacer()
                                
                                let dailyTotal = weekOnlyData.filter({ Calendar.current.isDate($0.timestamp ?? Date(), inSameDayAs: day)}).reduce(0) {$0 + $1.duration}
                                
                                Text("Total: \(dailyTotal, specifier: "%.0f")")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color("defaultYellow"))
                                    .padding(.bottom, 8)
                            }
                            .contentShape(Rectangle())
                           
                        }
                        .background((Calendar.current.isDate(day, inSameDayAs: Date())) ? Color("grayBackground") : Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1)))
                        .frame(width: 160, height: screen.size.height * 0.276, alignment: .center)
                        .onTapGesture {
                            self.selectedDate = day
                            self.showDetailedDayView = true
                        }
                        .sheet(isPresented: $showDetailedDayView, onDismiss: {
                            resetActivity(activityToSave)

                        }) {
                            //MARK: - Show DetailedDayView
                            DetailedDayView(
                                dailyData:  weekOnlyData,
                                showEditScreen: $showEditScreen,
                                activityToSave: activityToSave,
                                date: $selectedDate,
                                category1Name: $category1Name,
                                category2Name: $category2Name,
                                category3Name: $category3Name,
                                category4Name: $category4Name,
                                activeSheet: $activeSheet
                            )
                            .environmentObject(activityToSave)
                            .offset(y: 40)
                        }
                    }
                }
                .onReceive(scrollObject.$direction) { action in
                                        guard !weekToDisplay.isEmpty else { return }
                                        withAnimation {
                                            switch action {
                                                case .top:
                                                    sp.scrollTo(weekToDisplay.first!, anchor: .leading)
                                                case .end:
                                                    sp.scrollTo(weekToDisplay.last!, anchor: .trailing)
                                                case .point(let point):
                                                    sp.scrollTo(weekToDisplay[point], anchor: .center)
                                                default:
                                                    return
                                            }
                                        }
                }
            }
            .background(Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1)))
            .padding(.leading)
            .padding(.vertical, 6)
        }
        .onAppear(perform: {
            scrollObject.direction = .point(point: Calendar.current.dateComponents([.day], from: selectedDate.startOfWeek(), to: selectedDate).day ?? 0)
        })
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


//Activity Item (Displayed in Day by Day Scroll)
struct ActivityItem: View {
    
    var item: FetchedResults<AddedActivity>.Element
    
    var body: some View {
        
        HStack {
            Text("\(item.name ?? "Unknown Activity")")
                .font(.system(size: 16))
                .foregroundColor(Color("\(item.category ?? "category1")Color"))
                
            Spacer()
            
            Text("\(item.duration, specifier: "%.0f")")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color("\(item.category ?? "category1")Color"))
        }
    }
}


//MARK: - Chart Structs
struct BarChart: View {
              
    @Binding var selectedDate: Date
    var weekOneData: [AddedActivity]
    var weekTwoData: [AddedActivity]
    var weekThreeData: [AddedActivity]
    var weekFourData: [AddedActivity]
    let capsuleWidth: CGFloat = screen.size.width * 0.80 - 60
    let capsuleHeight: CGFloat = 40

    let dateFormatter: DateFormatter = {
        var df = DateFormatter()
        df.dateFormat = "MMM d"
        return df
    }()
    
    let dates = [Date(), Date().addingTimeInterval(-60*60*24*7), Date().addingTimeInterval(-60*60*24*14), Date().addingTimeInterval(-60*60*24*21)]
    
    var monthData: [[Float]] { [weekOneData, weekTwoData, weekThreeData, weekFourData].map { week in
        var data = [Float]()
            for categoryName in categories {
                let total = week.filter({ $0.category == categoryName} ).reduce(0) { $0 + $1.duration }
            
                data.append(total)
            }
        return data
        }
    }
                     
    var body: some View {
        
        //array of the totals of all categories per week
        let totalSums: [Float] = [
            monthData[0].reduce(0, +),
            monthData[1].reduce(0, +),
            monthData[2].reduce(0, +),
            monthData[3].reduce(0, +)
        ]
        
        
        let highestTotal = totalSums.max()
        
        //Graph
        VStack(alignment: .leading) {
    
            //Bar Stack - Cycle through dates
            ForEach(Array(zip(dates, dates.indices)), id: \.0) { date, dateIndex in
    
                ZStack {
                    
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .foregroundColor(Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1)))
                        
                    HStack(alignment: .center, spacing: 0) {
                        //Date text
                        Text("\(date.endOfWeek, formatter: dateFormatter) -\n\(date.startOfWeek(), formatter: dateFormatter)")
                            .foregroundColor(.white)
                            .font(.system(size: 13, weight: .semibold))
                            .frame(width: 58, height: capsuleHeight + 8, alignment: .center)
                            .padding(.trailing, 4)
                            .padding(.horizontal, 4)
                        
                        //Bar
                        ZStack(alignment: .leading) {
                            
                            //background capsule
                            Capsule().frame(width: capsuleWidth, height: capsuleHeight, alignment: .center)
                                .foregroundColor(Color("charcoalColor"))
                            
                            //stack of category capsules - Cycle through categories
                            HStack(alignment: .center, spacing: 0) {
                                ForEach(Array(zip(categories, categories.indices)), id: \.0) { category, index in
                                    
                                    //Layer number of category total over individual category capsule
                                    ZStack {
                                    
                                        Capsule().frame(width: CGFloat(monthData[dateIndex][index] * ((totalSums[dateIndex] > 0) ? ((Float(capsuleWidth) / totalSums[dateIndex]) * (totalSums[dateIndex] / highestTotal!)) : 0)), height: capsuleHeight, alignment: .center)
                                            .foregroundColor(Color("\(category)Color"))
                                        
                                        
                                        Text((monthData[dateIndex][index] > 0) ? "\(monthData[dateIndex][index], specifier: "%.0f")" : "")
                                            .opacity(
                                                ((Float("\(Int(monthData[dateIndex][index]))".widthOfString(usingFont: UIFont.systemFont(ofSize: 16))))
                                                    >
                                                (monthData[dateIndex][index] * ((totalSums[dateIndex] > 0) ? ((Float(capsuleWidth) / totalSums[dateIndex]) * (totalSums[dateIndex] / highestTotal!)) : 0)))
                                                ? 0 : 1)
                                    }
                                }
                            }
                        }
                        .frame(height: capsuleHeight)
                        
                        //Total for the week (all categories)
                        Text("\(totalSums[dateIndex], specifier: "%.0f")")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.yellow)
                            .frame(width: 52, height: 40)
                    }
                }
                .onTapGesture {
                    selectedDate = date.startOfWeek()
                }
            }
        }
    }
}





struct AddActivityButton: View {
    
    var body: some View {
        ZStack {
            
            let colorArray: [Color] = [Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)), Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)), Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))]
            
            LinearGradient(gradient: Gradient(colors: colorArray), startPoint: .topLeading, endPoint: .bottomTrailing)
                .mask(Image(systemName: "plus.circle.fill")
                        .font(.system(size: 40)))
                .frame(width: 40, height: 40, alignment: .center)
            
        }
    }
}

struct AddFavouriteButton: View {
    
    var body: some View {
        ZStack {
            Image(systemName: "bookmark.circle.fill")
                .foregroundColor(.yellow)
                .font(.system(size: 40))
                .padding()
        }
    }
}


struct ShowHistoryViewButton: View {
    
    var body: some View {
        ZStack {
            Image(systemName: "book.circle.fill")
                .foregroundColor(Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)))
                .font(.system(size: 40))
                .padding()
        }
    }
}



struct dayOfWeek: Identifiable {
    
    var id = UUID()
    var nameOfDay: String
    var dateOfDay: Int
    var month: String
    var category1: Int
    var category2: Int
    var category3: Int
    var category4: Int
    
}





//OLD BUTTONS

//                    //Mark: - Buttons
//                    HStack(spacing: 0) {
//
//                        ShowHistoryViewButton()
//                            .frame(width: 40)
//                            .frame(height: 40)
//                            .padding(.vertical, 8)
//                            .onTapGesture {
//                                self.showHistoryView.toggle()
//                            }
//                            .sheet(isPresented: $showHistoryView, onDismiss: {
//                                self.showHistoryView = false
//                            }) {
//                                //MARK: - show history view
//                                ActivityHistory(allData: allSavedActivities,
//                                                category1Name: $category1Name,
//                                                category2Name: $category2Name,
//                                                category3Name: $category3Name,
//                                                category4Name: $category4Name,
//                                                showActivitySelectorView: $showActivitySelector,
//                                                activityToShow: activityToSave)
//                            }
//
//                        //Add Activity Button
//                        AddFavouriteButton()
//                            .frame(width: 40)
//                            .frame(height: 40)
//                            .padding(.vertical, 8)
//                            .padding(.horizontal, 8)
//                            .onTapGesture {
//                                self.showAddFavourite.toggle()
//                            }
//                            .sheet(isPresented: $showAddFavourite, onDismiss: {
//                                self.showAddFavourite = false
//                                resetActivity(activityToSave)
//                            }) {
//                                //MARK: - Add Favourite View
//                                //Add activity view
//                                AddFavouriteView(
//                                    activityToSave: activityToSave,
//                                    activities: allSavedActivities,
//                                    showAddFavourite: $showAddFavourite,
//                                    category1Name: $category1Name,
//                                    category2Name: $category2Name,
//                                    category3Name: $category3Name,
//                                    category4Name: $category4Name
//
//                                )
//                                .environmentObject(activityToSave)
//                            }
//
//                        //Add Activity Button
//                        AddActivityButton()
//                            .frame(width: 40)
//                            .padding(.vertical, 0)
//                            .onTapGesture {
//                                self.showAddActivity.toggle()
//                            }
//                            .sheet(isPresented: $showAddActivity, onDismiss: {
//                                self.showAddActivity = false
//                                self.showActivitySelector = false
//                                self.showCategoryNameEditor = false
//                                resetActivity(activityToSave)
//                            }) {
//                                //MARK: - Add activity view
//                                AddActivityView(showActivitySelector: $showActivitySelector,
//                                                showAddActivity: $showAddActivity,
//                                                selectedDate: $selectedDate,
//                                                itemToDelete: $activityToDelete,
//                                                showingNameEditor: $showCategoryNameEditor,
//                                                activityToSave: activityToSave,
//                                                isEditScreen: false,
//                                                categorySelected: false,
//                                                category1Name: $category1Name,
//                                                category2Name: $category2Name,
//                                                category3Name: $category3Name,
//                                                category4Name: $category4Name)
//                            }
//                    }
//                    .padding(.trailing, 16)
