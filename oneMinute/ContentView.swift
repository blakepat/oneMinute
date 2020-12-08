//
//  ContentView.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2020-11-04.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    
    @Environment(\.managedObjectContext) private var viewContext
    
    //MARK: - FETCH ALL ACTIVITIES    
    //Fetch saved activities
    @FetchRequest(entity: AddedActivity.entity(), sortDescriptors: [])
    var allSavedActivities:FetchedResults<AddedActivity>
    
//    //**************************************************************************
//    //MARK: - FETCH CURRENT WEEK FOR EACH CATEGORY
//    @FetchRequest(entity: AddedActivity.entity(), sortDescriptors: [], predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "timestamp > %@", Date().startOfWeek() as CVarArg), NSPredicate(format: "category CONTAINS %@", "category1")]))
//    var FetchedThisWeekFitnessResults : FetchedResults<AddedActivity>
//
//    @FetchRequest(entity: AddedActivity.entity(), sortDescriptors: [], predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "timestamp > %@", Date().startOfWeek() as CVarArg), NSPredicate(format: "category CONTAINS %@", "category2")]))
//    var FetchedThisWeekLearningResults : FetchedResults<AddedActivity>
//
//    @FetchRequest(entity: AddedActivity.entity(), sortDescriptors: [], predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "timestamp > %@", Date().startOfWeek() as CVarArg), NSPredicate(format: "category CONTAINS %@", "category3")]))
//    var FetchedThisWeekChoresResults : FetchedResults<AddedActivity>
//
//    @FetchRequest(entity: AddedActivity.entity(), sortDescriptors: [], predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "timestamp > %@", Date().startOfWeek() as CVarArg), NSPredicate(format: "category CONTAINS %@", "category4")]))
//    var FetchedThisWeekWorkResults : FetchedResults<AddedActivity>
//    //SUM OF DURATION
//    var thisWeekFitnessSum: Float { FetchedThisWeekFitnessResults.reduce(0) { $0 + $1.duration }}
//    var thisWeekLearningSum: Float { FetchedThisWeekLearningResults.reduce(0) { $0 + $1.duration }}
//    var thisWeekChoresSum: Float { FetchedThisWeekChoresResults.reduce(0) { $0 + $1.duration }}
//    var thisWeekWorkSum: Float { FetchedThisWeekWorkResults.reduce(0) { $0 + $1.duration }}
    
    //**************************************************************************
//    //MARK: - FETCH LAST WEEK FOR EACH CATEGORY
//    @FetchRequest(entity: AddedActivity.entity(), sortDescriptors: [], predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "timestamp > %@", (Date().startOfWeek().addingTimeInterval(-7*24*60*60)) as CVarArg), NSPredicate(format: "timestamp < %@", Date().startOfWeek() as CVarArg), NSPredicate(format: "category CONTAINS %@", "category1")]))
//    var FetchedLastWeekFitnessResults : FetchedResults<AddedActivity>
//
//    @FetchRequest(entity: AddedActivity.entity(), sortDescriptors: [], predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "timestamp > %@", (Date().startOfWeek().addingTimeInterval(-7*24*60*60)) as CVarArg), NSPredicate(format: "timestamp < %@", Date().startOfWeek() as CVarArg), NSPredicate(format: "category CONTAINS %@", "category2")]))
//    var FetchedLastWeekLearningResults : FetchedResults<AddedActivity>
//
//    @FetchRequest(entity: AddedActivity.entity(), sortDescriptors: [], predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "timestamp > %@", (Date().startOfWeek().addingTimeInterval(-7*24*60*60)) as CVarArg), NSPredicate(format: "timestamp < %@", Date().startOfWeek() as CVarArg), NSPredicate(format: "category CONTAINS %@", "category3")]))
//    var FetchedLastWeekChoresResults : FetchedResults<AddedActivity>
//
//    @FetchRequest(entity: AddedActivity.entity(), sortDescriptors: [], predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "timestamp > %@", (Date().startOfWeek().addingTimeInterval(-7*24*60*60)) as CVarArg), NSPredicate(format: "timestamp < %@", Date().startOfWeek() as CVarArg), NSPredicate(format: "category CONTAINS %@", "category4")]))
//    var FetchedLastWeekWorkResults : FetchedResults<AddedActivity>
//
//    //SUM OF DURATION
//    var lastWeekFitnessSum: Float { FetchedLastWeekFitnessResults.reduce(0) { $0 + $1.duration }}
//    var lastWeekLearningSum: Float { FetchedLastWeekLearningResults.reduce(0) { $0 + $1.duration }}
//    var lastWeekChoresSum: Float { FetchedLastWeekChoresResults.reduce(0) { $0 + $1.duration }}
//    var lastWeekWorkSum: Float { FetchedLastWeekWorkResults.reduce(0) { $0 + $1.duration }}
    
    //**************************************************************************
    //MARK: - VARIABLES
    @State private var newActivity = ""
    @State var showLastWeek = false
    @State var showDetailedDay = false
    @State var showAddActivity = false
    @State var showActivitySelector = false
    @State var showAddFavourite = false
    @State var showEditScreen = false
    @State var showCategoryNameEditor = false
    
    @State var useHours = false
    @State var activityViewState = CGSize.zero
    @State var detailedDayViewState = CGSize.zero
    @State var favouriteViewState = CGSize.zero
    @ObservedObject var activityToSave = ActivityToSave()
    @State var daySelected = Date()
    @State var selectedDate = Date()
    @State var activityToDelete = AddedActivity()
    
    
    //MARK: - Category Names
    @State var category1Name = UserDefaults.standard.string(forKey: "category1Name")!
    @State var category2Name = UserDefaults.standard.string(forKey: "category2Name")!
    @State var category3Name = UserDefaults.standard.string(forKey: "category3Name")!
    @State var category4Name = UserDefaults.standard.string(forKey: "category4Name")!
    
    //MARK: - Week Date Data
    var currentWeek : [Date] {
        Array(stride(from: Date().startOfWeek(), through: Date().startOfWeek().addingTimeInterval(6*60*60*24), by:  60*60*24))
    }
    
    var lastWeek : [Date] {
        Array(stride(from: Date().startOfWeek().addingTimeInterval(-7*24*60*60), to: Date().startOfWeek(), by:  60*60*24))
    }
    
    
    //MARK: - Body
    var body: some View {
        
        //MARK: - SCREEN LAYOUT
        ZStack {
            //Background Color
            Color.black
                .edgesIgnoringSafeArea(.all)

            VStack {
                //Week Toggle at top
                WeekToggle(showLastWeek: $showLastWeek, dateSelected: $selectedDate)
                //Current Date
                //Week Dates Button
                HStack() {
                    
                    Image(systemName: "calendar.circle")
                        .font(.system(size: 36))
                        .foregroundColor(.white)
                        .frame(width: 24)
                
                    
                    DatePicker("", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .colorMultiply(.black)
                        .frame(width: 50, height: 50, alignment: .leading)
                        .colorInvert()
                        
                    
                    Spacer()
                    
                }
                .frame(height: 16)
                .padding(.horizontal, 16)
                .padding(.leading, screen.size.width * 0.03)
                .padding(.vertical, 8)
                //Week Summary
                SummaryView(
                    useHours: useHours,
                    selectedDate: selectedDate,
                    allData: allSavedActivities,
                    category1Name: $category1Name,
                    category2Name: $category2Name,
                    category3Name: $category3Name,
                    category4Name: $category4Name
                )
                
                //View of days of the week
                DayScrollView(showDetailedDayView: $showDetailedDay, detailedDayViewState: $detailedDayViewState, daySelected: $daySelected, selectedDate: $selectedDate, allData: allSavedActivities)
                    .padding(.leading, screen.size.width * 0.01)
                    
                
                
                     
                
                //MARK: - Last 5 Weeks Chart and Buttons
                VStack(alignment: .leading, spacing: 0) {
                    
                    //Title
                    Text("Last 5 Weeks")
                        .font(.system(size: 20, weight: .semibold))
                        .padding(.bottom, 4)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 0) {
                    
                        //Chart
                        BarChart(data: allSavedActivities)


                        //Buttons
                        HStack {
                            Spacer()
                            VStack(spacing: 0) {
                                
                                
                                //Add Activity Button
                                AddFavouriteButton()
                                    .frame(height: 50)
                                    .padding(.vertical, 8)
                                    .onTapGesture {
                                        self.showAddFavourite.toggle()
                                    }
                                //Add Activity Button
                                AddActivityButton()
                                    .padding(.vertical, 0)
                                    .onTapGesture {
                                        self.showAddActivity.toggle()
                                    }
                            }
                            .padding(.bottom, 16)
                        }
                        .frame(width: 20)
                        
                        Spacer()
                        
                    }
                }
                .padding(.leading, screen.size.width * 0.03)
                .padding(.horizontal)
                .padding(.vertical, 2)
                
                
                //Spacer
                Spacer()
              
            }
            .padding(.horizontal, 16)
            //**************************************
            //End of VStack
            //MARK: - Blur View
            //Background Blur view (Shown while add activity is open)
            BlurView(style: .systemThinMaterialDark).edgesIgnoringSafeArea(.all)
                .opacity((showAddActivity || showAddFavourite || showDetailedDay ) ? 0.6 : 0)
                .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                    self.showAddActivity = false
                    self.showAddFavourite = false
                    self.showActivitySelector = false
                    self.showDetailedDay = false
                    self.showEditScreen = false
                    self.showCategoryNameEditor = false
                    resetActivity(activityToSave)
                })
        
            //MARK: - Add activity view
            AddActivityView(
                showActivitySelector: $showActivitySelector,
                activityToSave: activityToSave,
                showAddActivity: $showAddActivity,
                isEditScreen: false,
                selectedDate: $daySelected,
                itemToDelete: $activityToDelete,
                showingNameEditor: $showCategoryNameEditor,
                category1Name: $category1Name,
                category2Name: $category2Name,
                category3Name: $category3Name,
                category4Name: $category4Name
            )
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .frame(width: screen.width, height: screen.height - 60, alignment: .leading)
                .offset(x: 0, y: showAddActivity ? 60 : screen.height)
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
                                self.showAddActivity = false
                                self.showActivitySelector = false
                                self.showCategoryNameEditor = false
                                
                                resetActivity(activityToSave)
                                
                            }
                            self.activityViewState = .zero
                        })
                )
            
            
            //MARK: - Add Favourite View
            //Add activity view
            AddFavouriteView(
                activityToSave: activityToSave,
                activities: allSavedActivities,
                showAddFavourite: $showAddFavourite,
                category1Name: $category1Name,
                category2Name: $category2Name,
                category3Name: $category3Name,
                category4Name: $category4Name
            
            )
                .environmentObject(activityToSave)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .frame(width: screen.width, height: screen.height - 60, alignment: .leading)
                .offset(x: 0, y: showAddFavourite ? 60 : screen.height)
                .offset(y: favouriteViewState.height)
                .animation(.easeInOut)
                .gesture(
                    DragGesture()
                        .onChanged({ (value) in
                            
                            if self.favouriteViewState.height > -1 {
                                self.favouriteViewState = value.translation
                            }
                        })
                        .onEnded({ (value) in
                            if self.favouriteViewState.height > 100 {
                                self.showAddFavourite = false

                                resetActivity(activityToSave)
                            }
                            self.favouriteViewState = .zero
                        })
                )
            
            
            
            //MARK: - Show DetailedDayView
            DetailedDayView(
                dailyData:  allSavedActivities,
                showEditScreen: $showEditScreen,
                activityToSave: activityToSave,
                useHours: $useHours, date: $daySelected,
                category1Name: $category1Name,
                category2Name: $category2Name,
                category3Name: $category3Name,
                category4Name: $category4Name
            )
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .environmentObject(activityToSave)
                .frame(width: screen.width, height: screen.height - 60, alignment: .leading)
                .offset(x: 0, y: showDetailedDay ? 60 : screen.height)
                .offset(y: detailedDayViewState.height)
                .animation(.easeInOut)
                .gesture(
                    DragGesture()
                        .onChanged({ (value) in
                            if self.detailedDayViewState.height > -1 {
                                self.detailedDayViewState = value.translation
                            }
                            
                        })
                        .onEnded({ (value) in
                            if self.detailedDayViewState.height > 100 {
                                resetActivity(activityToSave)
                                self.showDetailedDay = false
                                
                            }
                            self.detailedDayViewState = .zero
                        })
                )
        }
    //end of body
    }
    
    
    
    
    
    
    //MARK: - Functions
    
    
    //MARK: - Reset Activity Function
    private func resetActivity(_ : ActivityToSave) {
        activityToSave.activityName = "Select Activity"
        activityToSave.category = "category1"
        activityToSave.hours = 0
        activityToSave.minutes = 0
        activityToSave.notes = ""
    }
    
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()



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
                        dateSelected = Date().startOfWeek().addingTimeInterval(-7*24*60*60)
                        
                    })

                
                Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1))
                    .frame(width: 2, height: 50, alignment: .center)
                
                Text("This Week")
                    .padding(.horizontal, 30)
                    .foregroundColor(showLastWeek ? Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)) : Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)) )
                    .frame(width: screen.size.width / 2 - 1)
                    .onTapGesture(count: 1, perform: {
                        showLastWeek = false
                        dateSelected = Date().startOfWeek()
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
        
        let today = Date()
    
        HStack {
            Text("\(today, formatter: dateFormatter)")
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
    
    var useHours: Bool
    var selectedDate: Date
    var allData: FetchedResults<AddedActivity>
    
    //Category Names
    @Binding var category1Name: String
    @Binding var category2Name: String
    @Binding var category3Name: String
    @Binding var category4Name: String
    
    var body: some View {
    
        VStack {
            HStack {
                HStack {
                    Text("Total Weekly Minutes: \(Int(allData.filter({$0.timestamp ?? Date() > selectedDate.startOfWeek() && $0.timestamp ?? Date() < selectedDate.startOfWeek().addingTimeInterval(7*24*60*60)}).reduce(0) { $0 + $1.duration }))")
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
                        Text("\(category1Name.capitalized): \(Int(allData.filter({$0.category == "category1" && $0.timestamp ?? Date() > selectedDate.startOfWeek() && $0.timestamp ?? Date() < selectedDate.startOfWeek().addingTimeInterval(7*24*60*60)}).reduce(0) { $0 + $1.duration }))")
                            .padding(.horizontal, 10)
                            .foregroundColor(Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)))
                        
                        Text("\(category2Name.capitalized): \(Int(allData.filter({$0.category == "category2" && $0.timestamp ?? Date() > selectedDate.startOfWeek() && $0.timestamp ?? Date() < selectedDate.startOfWeek().addingTimeInterval(7*24*60*60)}).reduce(0) { $0 + $1.duration }))  ")
                            .padding(.horizontal, 10)
                            .foregroundColor(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
                    }
                    .padding(.vertical, 6)
                    
                    HStack(alignment: .top) {
                        Text("\(category3Name.capitalized): \(Int(allData.filter({$0.category == "category3" && $0.timestamp ?? Date() > selectedDate.startOfWeek() && $0.timestamp ?? Date() < selectedDate.startOfWeek().addingTimeInterval(7*24*60*60)}).reduce(0) { $0 + $1.duration }))  ")
                            .padding(.horizontal, 10)
                            .foregroundColor(Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)))
                        Text("\(category4Name.capitalized): \(Int(allData.filter({$0.category == "category4" && $0.timestamp ?? Date() > selectedDate.startOfWeek() && $0.timestamp ?? Date() < selectedDate.startOfWeek().addingTimeInterval(7*24*60*60)}).reduce(0) { $0 + $1.duration })) ")
                            .padding(.horizontal, 10)
                            .foregroundColor(Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)))
                    }
                    .padding(.all, 4)
                    
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(.bottom)
            }
        }
        .frame(width: screen.size.width * 0.94, height: screen.size.height * 0.16)
        .background(Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1)))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .padding(.horizontal)
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
    @Binding var detailedDayViewState: CGSize
    @Binding var daySelected: Date
    @Binding var selectedDate: Date
    
    @StateObject var scrollObject = ScrollToModel()
    
    var allData: FetchedResults<AddedActivity>
    
    let dateFormatter: DateFormatter = {
        var df = DateFormatter()
        df.dateFormat = "EEEE d"
        return df
    }()
    
    var body: some View {
        
        let weekToDisplay = Date.dates(from: selectedDate.startOfWeek(), to: selectedDate.startOfWeek().addingTimeInterval(60*60*25*6))
        
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
                                    ForEach(allData.filter({ Calendar.current.isDate($0.timestamp ?? Date(), inSameDayAs: day)}), id: \.self) { data in
                                        ActivityItem(item: data)
                                            .padding(.bottom, 2)
                                            .frame(width: 132)
                                    }
                                }
                                Spacer()
                                
                                let dailyTotal = allData.filter({ Calendar.current.isDate($0.timestamp ?? Date(), inSameDayAs: day)}).reduce(0) {$0 + $1.duration}
                                
                                Text("Total: \(dailyTotal, specifier: "%.0f")")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(Color("defaultYellow"))
                                    .padding(.bottom, 8)
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                print("DAY TAPPED *Show DetailedDayView* ")
                                self.daySelected = day
                                self.showDetailedDayView = true
                            }
                        }
                        .background((Calendar.current.isDate(day, inSameDayAs: Date())) ? Color("grayBackground") : Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1)))
                        .frame(width: 160, height: screen.size.height * 0.276, alignment: .center)
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
}


//Activity Item (Displayed in Day by Day Scroll
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



//MARK: - Day View
struct dayView: View {
    
    var day: dayOfWeek
    var category1: String
    var category2: String
    var category3: String
    var category4: String
    
    var body: some View {
        ZStack {
            
            Color.black
                
            
            VStack {
                Text("\(day.nameOfDay) \(day.dateOfDay)")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.bottom, 4)
                
                VStack(alignment: .center) {
                    Text("\(category1.capitalized): \(day.category1)")
                        .foregroundColor(Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)))
                        .padding(.vertical, 2)
                    
                    Text("Learn: \(day.category2)")
                        .foregroundColor(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
                        .padding(.vertical, 2)
                    
                    Text("category3: \(day.category3)")
                        .foregroundColor(Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)))
                        .padding(.vertical, 2)
                    
                    Text("Custom: \(day.category4)")
                        .foregroundColor(Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)))
                        .padding(.vertical, 2)
                    
                    Text("Total: \(day.category1 + day.category2 + day.category3 + day.category4)")
                        .foregroundColor(Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)))
                        .padding(.vertical, 2)
                }
                .font(.system(size: 18, weight: .semibold))
            }
        }
    }
}


//MARK: - Chart Structs
struct BarChart: View {
    
    var data: FetchedResults<AddedActivity>
    
    let capsuleWidth: CGFloat = screen.size.width * 0.80 - 90
    let capsuleHeight: CGFloat = 32
    
    let catagories = ["category1", "category2", "category3", "category4"]
    
    let dateFormatter: DateFormatter = {
        var df = DateFormatter()
        df.dateFormat = "MMM d"
        return df
    }()
    
    let dates = [Date(), Date().addingTimeInterval(-60*60*24*6), Date().addingTimeInterval(-60*60*24*13), Date().addingTimeInterval(-60*60*24*20), Date().addingTimeInterval(-60*60*24*27)]
    
    
    
    var week1FitnessSum: Float { data.filter({ $0.timestamp ?? Date() > dates[0].startOfWeek() && $0.timestamp ?? Date() < dates[0].startOfWeek().advanced(by: 60*60*25*6) && $0.category == "category1"}).reduce(0) { $0 + $1.duration }}
    var week1LearningSum: Float { data.filter({ $0.timestamp ?? Date() > dates[0].startOfWeek() && $0.timestamp ?? Date() < dates[0].startOfWeek().advanced(by: 60*60*25*6) && $0.category == "category2" }).reduce(0) { $0 + $1.duration }}
    var week1ChoresSum: Float { data.filter({ $0.timestamp ?? Date() > dates[0].startOfWeek() && $0.timestamp ?? Date() < dates[0].startOfWeek().advanced(by: 60*60*25*6) && $0.category == "category3" }).reduce(0) { $0 + $1.duration }}
    var week1WorkSum: Float { data.filter({ $0.timestamp ?? Date() > dates[0].startOfWeek() && $0.timestamp ?? Date() < dates[0].startOfWeek().advanced(by: 60*60*25*6) && $0.category == "category4"  }).reduce(0) { $0 + $1.duration }}
    
    var week2FitnessSum: Float { data.filter({ $0.timestamp ?? Date() > dates[1].startOfWeek() && $0.timestamp ?? Date() < dates[1].startOfWeek().advanced(by: 60*60*25*6) && $0.category == "category1" }).reduce(0) { $0 + $1.duration }}
    var week2LearningSum: Float { data.filter({ $0.timestamp ?? Date() > dates[1].startOfWeek() && $0.timestamp ?? Date() < dates[1].startOfWeek().advanced(by: 60*60*25*6) && $0.category == "category2" }).reduce(0) { $0 + $1.duration }}
    var week2ChoresSum: Float { data.filter({ $0.timestamp ?? Date() > dates[1].startOfWeek() && $0.timestamp ?? Date() < dates[1].startOfWeek().advanced(by: 60*60*25*6) && $0.category == "category3" }).reduce(0) { $0 + $1.duration }}
    var week2WorkSum: Float { data.filter({ $0.timestamp ?? Date() > dates[1].startOfWeek() && $0.timestamp ?? Date() < dates[1].startOfWeek().advanced(by: 60*60*25*6) && $0.category == "category4"  }).reduce(0) { $0 + $1.duration }}

    var week3FitnessSum: Float { data.filter({ $0.timestamp ?? Date() > dates[2].startOfWeek() && $0.timestamp ?? Date() < dates[2].startOfWeek().advanced(by: 60*60*25*6) && $0.category == "category1" }).reduce(0) { $0 + $1.duration }}
    var week3LearningSum: Float { data.filter({ $0.timestamp ?? Date() > dates[2].startOfWeek() && $0.timestamp ?? Date() < dates[2].startOfWeek().advanced(by: 60*60*25*6) && $0.category == "category2" }).reduce(0) { $0 + $1.duration }}
    var week3ChoresSum: Float { data.filter({ $0.timestamp ?? Date() > dates[2].startOfWeek() && $0.timestamp ?? Date() < dates[2].startOfWeek().advanced(by: 60*60*25*6) && $0.category == "category3" }).reduce(0) { $0 + $1.duration }}
    var week3WorkSum: Float { data.filter({ $0.timestamp ?? Date() > dates[2].startOfWeek() && $0.timestamp ?? Date() < dates[2].startOfWeek().advanced(by: 60*60*25*6) && $0.category == "category4"  }).reduce(0) { $0 + $1.duration }}

    var week4FitnessSum: Float { data.filter({ $0.timestamp ?? Date() > dates[3].startOfWeek() && $0.timestamp ?? Date() < dates[3].startOfWeek().advanced(by: 60*60*25*6)  && $0.category == "category1" }).reduce(0) { $0 + $1.duration }}
    var week4LearningSum: Float { data.filter({ $0.timestamp ?? Date() > dates[3].startOfWeek() && $0.timestamp ?? Date() < dates[3].startOfWeek().advanced(by: 60*60*25*6) && $0.category == "category2" }).reduce(0) { $0 + $1.duration }}
    var week4ChoresSum: Float { data.filter({ $0.timestamp ?? Date() > dates[3].startOfWeek() && $0.timestamp ?? Date() < dates[3].startOfWeek().advanced(by: 60*60*25*6) && $0.category == "category3" }).reduce(0) { $0 + $1.duration }}
    var week4WorkSum: Float { data.filter({ $0.timestamp ?? Date() > dates[3].startOfWeek() && $0.timestamp ?? Date() < dates[3].startOfWeek().advanced(by: 60*60*25*6) && $0.category == "category4"  }).reduce(0) { $0 + $1.duration }}

    var week5FitnessSum: Float { data.filter({ $0.timestamp ?? Date() > dates[4].startOfWeek() && $0.timestamp ?? Date() < dates[4].startOfWeek().advanced(by: 60*60*25*6)  && $0.category == "category1" }).reduce(0) { $0 + $1.duration }}
    var week5LearningSum: Float { data.filter({ $0.timestamp ?? Date() > dates[4].startOfWeek() && $0.timestamp ?? Date() < dates[4].startOfWeek().advanced(by: 60*60*25*6) && $0.category == "category2" }).reduce(0) { $0 + $1.duration }}
    var week5ChoresSum: Float { data.filter({ $0.timestamp ?? Date() > dates[4].startOfWeek() && $0.timestamp ?? Date() < dates[4].startOfWeek().advanced(by: 60*60*25*6) && $0.category == "category3" }).reduce(0) { $0 + $1.duration }}
    var week5WorkSum: Float { data.filter({ $0.timestamp ?? Date() > dates[4].startOfWeek() && $0.timestamp ?? Date() < dates[4].startOfWeek().advanced(by: 60*60*25*6) && $0.category == "category4" }).reduce(0) { $0 + $1.duration }}

    
    
    var body: some View {
        
        
        
        //array of all the weekly sums for each category
        let categoryTotalsArray: [[Float]] =
            [[week1FitnessSum, week1LearningSum, week1ChoresSum, week1WorkSum],
            [week2FitnessSum, week2LearningSum, week2ChoresSum, week2WorkSum],
            [week3FitnessSum, week3LearningSum, week3ChoresSum, week3WorkSum],
            [week4FitnessSum, week4LearningSum, week4ChoresSum, week4WorkSum],
            [week5FitnessSum, week5LearningSum, week5ChoresSum, week5WorkSum]]
        //array of the totals of all categories per week
        let totalSums: [Float] = [
            categoryTotalsArray[0].reduce(0, +),
            categoryTotalsArray[1].reduce(0, +),
            categoryTotalsArray[2].reduce(0, +),
            categoryTotalsArray[3].reduce(0, +),
            categoryTotalsArray[4].reduce(0, +)]
        
        
        let highestTotal = totalSums.max()
        
        //Graph
        VStack(alignment: .leading) {
    
            //Bar Stack - Cycle through dates
            ForEach(Array(zip(dates, dates.indices)), id: \.0) { date, dateIndex in
    
                HStack(alignment: .center, spacing: 0) {
                    //Date text
                    Text("\(date.startOfWeek(), formatter: dateFormatter)\n \(date.startOfWeek().advanced(by: 60*60*25*6), formatter: dateFormatter)")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                        .frame(width: 56, height: 40, alignment: .center)
                        .background(Color("charcoalColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.trailing, 4)
                    
                    //Bar
                    ZStack(alignment: .leading) {
                        
                        //background capsule
                        Capsule().frame(width: capsuleWidth, height: capsuleHeight, alignment: .center)
                            .foregroundColor(Color("charcoalColor"))
                        
                        //stack of category capsules - Cycle through categories
                        HStack(alignment: .center, spacing: 0) {
                            ForEach(Array(zip(catagories, catagories.indices)), id: \.0) { category, index in
                                
                                //Layer number of category total over individual category capsule
                                ZStack {
                                
                                    Capsule().frame(width: CGFloat(categoryTotalsArray[dateIndex][index] * ((totalSums[dateIndex] > 0) ? ((Float(capsuleWidth) / totalSums[dateIndex]) * (totalSums[dateIndex] / highestTotal!)) : 0)), height: capsuleHeight, alignment: .center)
                                        .foregroundColor(Color("\(category)Color"))
                                    
                                    
                                    Text((categoryTotalsArray[dateIndex][index] > 0) ? "\(categoryTotalsArray[dateIndex][index], specifier: "%.0f")" : "")
                                        .opacity(
                                            ((Float("\(Int(categoryTotalsArray[dateIndex][index]))".widthOfString(usingFont: UIFont.systemFont(ofSize: 16))))
                                                >
                                            (categoryTotalsArray[dateIndex][index] * ((totalSums[dateIndex] > 0) ? ((Float(capsuleWidth) / totalSums[dateIndex]) * (totalSums[dateIndex] / highestTotal!)) : 0)))
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
                        .frame(width: 60, height: 40)
                    
                    
                }
                
            }
        }
    }
}





//MARK: - Button Structs
struct SettingsButton: View {
    
    var body: some View {
        ZStack {
            Image(systemName: "line.horizontal.3.circle.fill")
                .foregroundColor(.gray)
                .font(.system(size: 44))
                .padding()
        }
    }
}





struct AddActivityButton: View {
    
    var body: some View {
        ZStack {
            
            let colorArray: [Color] = [Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)), Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)), Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))]
            
            LinearGradient(gradient: Gradient(colors: colorArray), startPoint: .topLeading, endPoint: .bottomTrailing)
                .mask(Image(systemName: "plus.circle.fill")
                        .font(.system(size: 44)))
                .frame(width: 44, height: 44, alignment: .center)
            
        }
    }
}

struct AddFavouriteButton: View {
    
    var body: some View {
        ZStack {
            Image(systemName: "bookmark.circle.fill")
                .foregroundColor(.yellow)
                .font(.system(size: 44))
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



extension Calendar {
    func isDayInCurrentWeek(date: Date) -> Bool? {
        let currentComponents = Calendar.current.dateComponents([.weekOfYear], from: Date())
        let dateComponents = Calendar.current.dateComponents([.weekOfYear], from: date)
        guard let currentWeekOfYear = currentComponents.weekOfYear, let dateWeekOfYear = dateComponents.weekOfYear else { return nil }
        return currentWeekOfYear == dateWeekOfYear
    }
}

extension Calendar {
    static let gregorian = Calendar(identifier: .gregorian)
}


extension Date {
    func startOfWeek(using calendar: Calendar = .gregorian) -> Date {
        calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }
}

extension Date: Strideable {
    // typealias Stride = SignedInteger // doesn't work (probably because declared in extension
    public func advanced(by n: Int) -> Date {
        self.addingTimeInterval(TimeInterval(n))
    }

    public func distance(to other: Date) -> Int {
        return Int(self.distance(to: other))
    }
}

let screen = UIScreen.main.bounds

extension Date {
    func generateDates(startDate :Date?, addbyUnit:Calendar.Component, value : Int) -> [Date]
{
    let calendar = Calendar.current
    var datesArray: [Date] =  [Date] ()

    for i in 0 ... value {
        if let newDate = calendar.date(byAdding: addbyUnit, value: i + 1, to: startDate!) {
            datesArray.append(newDate)
        }
    }

    return datesArray
}
}


extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate

        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
}

extension String {
   func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
