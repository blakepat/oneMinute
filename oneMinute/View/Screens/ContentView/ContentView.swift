//
//  ContentView.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2020-11-04.
//

import SwiftUI
import CoreData

struct ContentView: View {
     
    @StateObject private var viewModel = ContentViewModel()
    
    //Fetch saved activities
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: AddedActivity.entity(), sortDescriptors: [])
    private var allSavedActivities:FetchedResults <AddedActivity>
    
    
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
    
    
    //Week Date Data
    private var currentWeek : [Date] {
        Array(stride(from: Date().startOfWeek(), through: Date().startOfWeek().addingTimeInterval(6*60*60*24), by:  60*60*24))
    }
    private var lastWeek : [Date] {
        Array(stride(from: Date().startOfWeek().addingTimeInterval(-6*24*60*60), to: Date().startOfWeek(), by:  60*60*24))
    }

    
    
    //MARK: - Body
    var body: some View {

        ZStack {
            //Background Color
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                //MARK: - Week Toggle at top
                WeekToggle(showLastWeek: $showLastWeek, dateSelected: $selectedDate)
                    .padding(.top, 8)
                
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
                    isHours: $viewModel.isHours,
                    category1Name: $viewModel.category1Name,
                    category2Name: $viewModel.category2Name,
                    category3Name: $viewModel.category3Name,
                    category4Name: $viewModel.category4Name
                )
                .environment(\.managedObjectContext, viewContext)
                
                //MARK: - View of days of the week
                DayScrollView(
                    showDetailedDayView: $showDetailedDay,
                    selectedDate: $selectedDate,
                    showEditScreen: $showEditScreen,
                    activityToSave: activityToSave,
                    category1Name: $viewModel.category1Name,
                    category2Name: $viewModel.category2Name,
                    category3Name: $viewModel.category3Name,
                    category4Name: $viewModel.category4Name,
                    isHours: $viewModel.isHours,
                    weekOnlyData: viewModel.returnThisWeek(selectedDate: selectedDate, activities: allSavedActivities),
                    activeSheet: $activeSheet
                )
                .padding(.leading, screen.size.width * 0.01)
                    
                //MARK: - Last 5 Weeks Chart and Buttons
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        //Chart
                        BarChart(
                            selectedDate: $selectedDate,
                            weekOneData: viewModel.returnWeekFromNumber(0, fetchedResults: allSavedActivities),
                            weekTwoData: viewModel.returnWeekFromNumber(1, fetchedResults: allSavedActivities),
                            weekThreeData: viewModel.returnWeekFromNumber(2, fetchedResults: allSavedActivities),
                            weekFourData: viewModel.returnWeekFromNumber(3, fetchedResults: allSavedActivities),
                            isHours: $viewModel.isHours
                        )
                        Spacer()
                    }
                }
                .frame(width: screen.size.width - 50)
                .padding(.leading, screen.size.width * 0.03)
                .padding(.horizontal)
                .padding(.vertical, 2)

                Spacer()
   
                
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
                                          category1Name: $viewModel.category1Name,
                                          category2Name: $viewModel.category2Name,
                                          category3Name: $viewModel.category3Name,
                                          category4Name: $viewModel.category4Name,
                                          isHours: $viewModel.isHours,
                                          date: $selectedDate,
                                          showActivitySelectorView: $showActivitySelector,
                                          activityToShow: _activityToSave)
                                    .environment(\.managedObjectContext, viewContext)
                            case .second:
                                ActivityHistoryView(allData: allSavedActivities,
                                                category1Name: $viewModel.category1Name,
                                                category2Name: $viewModel.category2Name,
                                                category3Name: $viewModel.category3Name,
                                                category4Name: $viewModel.category4Name,
                                                isHours: $viewModel.isHours,
                                                showActivitySelectorView: $showActivitySelector,
                                                activityToShow: activityToSave)
                                    .environment(\.managedObjectContext, viewContext)
                            case .third:
                                AddActivityView(showActivitySelector: $showActivitySelector,
                                                showAddActivity: $showAddActivity,
                                                selectedDate: $selectedDate,
                                                itemToDelete: $activityToDelete,
                                                showingNameEditor: $showCategoryNameEditor,
                                                activityToSave: activityToSave,
                                                isEditScreen: false,
                                                categorySelected: false,
                                                category1Name: $viewModel.category1Name,
                                                category2Name: $viewModel.category2Name,
                                                category3Name: $viewModel.category3Name,
                                                category4Name: $viewModel.category4Name,
                                                activeSheet: $activeSheet)
                                    .environment(\.managedObjectContext, viewContext)
                            
                            case .fourth:
                                AddFavouriteView(
                                    activityToSave: activityToSave,
                                    activities: allSavedActivities,
                                    showAddFavourite: $showAddFavourite,
                                    category1Name: $viewModel.category1Name,
                                    category2Name: $viewModel.category2Name,
                                    category3Name: $viewModel.category3Name,
                                    category4Name: $viewModel.category4Name,
                                    activeSheet: $activeSheet)
                                    .environment(\.managedObjectContext, viewContext)
                                
                            case .fifth:
                                SettingsView(isHours: $viewModel.isHours)
                                    .environment(\.managedObjectContext, viewContext)
                            }
                           })
            }
            .padding(.horizontal, 16)
            .edgesIgnoringSafeArea(.bottom)
            
            
        }
        .sheet(isPresented: $viewModel.showingOnboardView, content: {
            OnboardView()
        })
        .onAppear {
            viewModel.showOnboardView()
        }
    }
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}
