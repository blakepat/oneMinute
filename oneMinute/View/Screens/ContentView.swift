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
    private var allSavedActivities:FetchedResults<AddedActivity>
    
    //@States for showing views
    @State private var showLastWeek = false
    @State private var showDetailedDay = false
    @State private var showAddActivity = false
    @State private var showActivitySelector = false
    @State private var showAddFavourite = false
    @State private var showEditScreen = false
    @State private var showCategoryNameEditor = false
    @State private var showHistoryView = false
    @State private var showStatsView = false
    @State private var showSettings = false
    
    //Variables
    @State var selectedDate = Date()
    @State var activityToDelete = AddedActivity()
    @ObservedObject var activityToSave = ActivityToSave()
    
    //Tab bar variables
    @State private var shouldShowModal = false
    @State private var activeSheet: ActiveSheet?
    
    
    //MARK: - Category Names
    @State private var category1Name = UserDefaults.standard.string(forKey: "category1Name")!
    @State private var category2Name = UserDefaults.standard.string(forKey: "category2Name")!
    @State private var category3Name = UserDefaults.standard.string(forKey: "category3Name")!
    @State private var category4Name = UserDefaults.standard.string(forKey: "category4Name")!
    
    //Time Unit
    @State var isHours = UserDefaults.standard.bool(forKey: "isHours")
    
    //Week Date Data
    private var currentWeek : [Date] {
        Array(stride(from: Date().startOfWeek(), through: Date().startOfWeek().addingTimeInterval(6*60*60*24), by:  60*60*24))
    }
    private var lastWeek : [Date] {
        Array(stride(from: Date().startOfWeek().addingTimeInterval(-6*24*60*60), to: Date().startOfWeek(), by:  60*60*24))
    }
    private let dates = [Date(), Date().addingTimeInterval(-60*60*24*7), Date().addingTimeInterval(-60*60*24*14), Date().addingTimeInterval(-60*60*24*21)]
    
    
    
    //MARK: - Body
    var body: some View {

        ZStack {
            //Background Color
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                //MARK: - Week Toggle at top
                WeekToggle(showLastWeek: $showLastWeek, dateSelected: $selectedDate)
                    .padding(.top, 4)
                
                //MARK:- Calendar Button
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
                
            
                //MARK: - Week Summary
                SummaryView(
                    selectedDate: selectedDate,
                    allData: allSavedActivities,
                    isHours: $isHours,
                    category1Name: $category1Name,
                    category2Name: $category2Name,
                    category3Name: $category3Name,
                    category4Name: $category4Name
                )
                .environment(\.managedObjectContext, self.viewContext)
                
                //MARK: - View of days of the week
                DayScrollView(
                    showDetailedDayView: $showDetailedDay,
                    selectedDate: $selectedDate,
                    showEditScreen: $showEditScreen,
                    activityToSave: activityToSave,
                    category1Name: $category1Name,
                    category2Name: $category2Name,
                    category3Name: $category3Name,
                    category4Name: $category4Name,
                    isHours: $isHours,
                    weekOnlyData: allSavedActivities.filter({ $0.timestamp ?? Date() > selectedDate.startOfWeek() && $0.timestamp ?? Date() < selectedDate.endOfWeek }
                                                        
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
                            weekFourData: allSavedActivities.filter({ $0.timestamp ?? Date() > dates[3].startOfWeek() && $0.timestamp ?? Date() < dates[3].endOfWeek}),
                            isHours: $isHours
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
                CustomTabBar(activeSheet: $activeSheet,
                             showStatsView: $showStatsView,
                             showAddFavourite: $showAddFavourite,
                             showHistoryView: $showHistoryView,
                             showAddActivity: $showAddActivity,
                             showActivitySelector: $showActivitySelector,
                             showCategoryNameEditor: $showCategoryNameEditor,
                             shouldShowModal: $shouldShowModal,
                             showSettings: $showSettings
                )
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
                            resetActivity(activityToSave: activityToSave)
                            
                           } , content: { item in
                            //Switch between views
                            switch item {
                            case .first:
                                StatsView(allData: allSavedActivities,
                                          category1Name: $category1Name,
                                          category2Name: $category2Name,
                                          category3Name: $category3Name,
                                          category4Name: $category4Name,
                                          isHours: $isHours,
                                          date: $selectedDate,
                                          showActivitySelectorView: $showActivitySelector,
                                          activityToShow: _activityToSave)
                                    .environment(\.managedObjectContext, self.viewContext)
                            case .second:
                                ActivityHistory(allData: allSavedActivities,
                                                category1Name: $category1Name,
                                                category2Name: $category2Name,
                                                category3Name: $category3Name,
                                                category4Name: $category4Name,
                                                isHours: $isHours,
                                                showActivitySelectorView: $showActivitySelector,
                                                activityToShow: activityToSave)
                                    .environment(\.managedObjectContext, self.viewContext)
                            case .third:
                                AddActivityView(showActivitySelector: $showActivitySelector,
                                                showAddActivity: $showAddActivity,
                                                selectedDate: $selectedDate,
                                                itemToDelete: $activityToDelete,
                                                showingNameEditor: $showCategoryNameEditor,
                                                activityToSave: activityToSave,
                                                isEditScreen: false,
                                                categorySelected: false,
                                                category1Name: $category1Name,
                                                category2Name: $category2Name,
                                                category3Name: $category3Name,
                                                category4Name: $category4Name,
                                                activeSheet: $activeSheet)
                                    .environment(\.managedObjectContext, self.viewContext)
                            
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
                                    .environment(\.managedObjectContext, self.viewContext)
                                
                            case .fifth:
                                SettingsView(isHours: $isHours)
                                    .environment(\.managedObjectContext, self.viewContext)
                            }
                           })
            }
            .padding(.horizontal, 16)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    

    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}
