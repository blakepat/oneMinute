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
    
    //FETCH ALL ACTIVITIES
    //Fetch listed activities
    @FetchRequest(entity: Activity.entity(), sortDescriptors: [])
    var allFetchedActivities:FetchedResults<Activity>
    
    //Fetch saved activities
    @FetchRequest(entity: AddedActivity.entity(), sortDescriptors: [])
    var allSavedActivities:FetchedResults<AddedActivity>
    
    //**************************************************************************
    //Fetch ALL Last week and All this week
    //Last Week
    @FetchRequest(entity: AddedActivity.entity(), sortDescriptors: [], predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "timestamp > %@", (Date().startOfWeek().addingTimeInterval(-7*24*60*60)) as CVarArg), NSPredicate(format: "timestamp < %@", Date().startOfWeek() as CVarArg)]))
    var FetchedAllLastWeekResults : FetchedResults<AddedActivity>
    //This Week
    @FetchRequest(entity: AddedActivity.entity(), sortDescriptors: [], predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "timestamp > %@", Date().startOfWeek() as CVarArg)]))
    var FetchedAllThisWeekResults : FetchedResults<AddedActivity>
    
    
    //**************************************************************************
    //FETCH CURRENT WEEK FOR EACH CATEGORY
    @FetchRequest(entity: AddedActivity.entity(), sortDescriptors: [], predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "timestamp > %@", Date().startOfWeek() as CVarArg), NSPredicate(format: "category CONTAINS %@", "fitness")]))
    var FetchedThisWeekFitnessResults : FetchedResults<AddedActivity>
    
    @FetchRequest(entity: AddedActivity.entity(), sortDescriptors: [], predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "timestamp > %@", Date().startOfWeek() as CVarArg), NSPredicate(format: "category CONTAINS %@", "learning")]))
    var FetchedThisWeekLearningResults : FetchedResults<AddedActivity>
    
    @FetchRequest(entity: AddedActivity.entity(), sortDescriptors: [], predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "timestamp > %@", Date().startOfWeek() as CVarArg), NSPredicate(format: "category CONTAINS %@", "chores")]))
    var FetchedThisWeekChoresResults : FetchedResults<AddedActivity>
    
    @FetchRequest(entity: AddedActivity.entity(), sortDescriptors: [], predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "timestamp > %@", Date().startOfWeek() as CVarArg), NSPredicate(format: "category CONTAINS %@", "work")]))
    var FetchedThisWeekWorkResults : FetchedResults<AddedActivity>
    //SUM OF DURATION
    var thisWeekFitnessSum: Float { FetchedThisWeekFitnessResults.reduce(0) { $0 + $1.duration }}
    var thisWeekLearningSum: Float { FetchedThisWeekLearningResults.reduce(0) { $0 + $1.duration }}
    var thisWeekChoresSum: Float { FetchedThisWeekChoresResults.reduce(0) { $0 + $1.duration }}
    var thisWeekWorkSum: Float { FetchedThisWeekWorkResults.reduce(0) { $0 + $1.duration }}
    
    //**************************************************************************
    //FETCH LAST WEEK FOR EACH CATEGORY
    @FetchRequest(entity: AddedActivity.entity(), sortDescriptors: [], predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "timestamp > %@", (Date().startOfWeek().addingTimeInterval(-7*24*60*60)) as CVarArg), NSPredicate(format: "timestamp < %@", Date().startOfWeek() as CVarArg), NSPredicate(format: "category CONTAINS %@", "fitness")]))
    var FetchedLastWeekFitnessResults : FetchedResults<AddedActivity>
    
    @FetchRequest(entity: AddedActivity.entity(), sortDescriptors: [], predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "timestamp > %@", (Date().startOfWeek().addingTimeInterval(-7*24*60*60)) as CVarArg), NSPredicate(format: "timestamp < %@", Date().startOfWeek() as CVarArg), NSPredicate(format: "category CONTAINS %@", "learning")]))
    var FetchedLastWeekLearningResults : FetchedResults<AddedActivity>
    
    @FetchRequest(entity: AddedActivity.entity(), sortDescriptors: [], predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "timestamp > %@", (Date().startOfWeek().addingTimeInterval(-7*24*60*60)) as CVarArg), NSPredicate(format: "timestamp < %@", Date().startOfWeek() as CVarArg), NSPredicate(format: "category CONTAINS %@", "chores")]))
    var FetchedLastWeekChoresResults : FetchedResults<AddedActivity>
    
    @FetchRequest(entity: AddedActivity.entity(), sortDescriptors: [], predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "timestamp > %@", (Date().startOfWeek().addingTimeInterval(-7*24*60*60)) as CVarArg), NSPredicate(format: "timestamp < %@", Date().startOfWeek() as CVarArg), NSPredicate(format: "category CONTAINS %@", "work")]))
    var FetchedLastWeekWorkResults : FetchedResults<AddedActivity>
    
    //SUM OF DURATION
    var lastWeekFitnessSum: Float { FetchedLastWeekFitnessResults.reduce(0) { $0 + $1.duration }}
    var lastWeekLearningSum: Float { FetchedLastWeekLearningResults.reduce(0) { $0 + $1.duration }}
    var lastWeekChoresSum: Float { FetchedLastWeekChoresResults.reduce(0) { $0 + $1.duration }}
    var lastWeekWorkSum: Float { FetchedLastWeekWorkResults.reduce(0) { $0 + $1.duration }}
    
    //**************************************************************************
    //VARIABLES
    @State private var newActivity = ""
    @State var showLastWeek = false
    @State var showAddActivity = false
    @State var showActivitySelector = false
    @State var showAddFavourite = false
    @State var useHours = false
    @State var activityViewState = CGSize.zero
    @State var favouriteViewState = CGSize.zero
    @State var activityToSave = ActivityToSave()
    
    var body: some View {
        
        ZStack {
            //Background Color
            Color.black
                .edgesIgnoringSafeArea(.all)

            VStack {
                //Week Toggle at top
                WeekToggle(showLastWeek: $showLastWeek)
                
                //Current Date
                DateView()
                    .padding(.bottom, 4)
                
                //Week Summary
                SummaryView(
                    useHours: useHours,
                    sumOfWeeklyFitnessMinutes: showLastWeek ? lastWeekFitnessSum : thisWeekFitnessSum,
                    sumOfWeeklyLearningMinutes: showLastWeek ? lastWeekLearningSum : thisWeekLearningSum,
                    sumOfWeeklyChoresMinutes: showLastWeek ? lastWeekChoresSum : thisWeekChoresSum,
                    sumOfWeeklyWorkMinutes: showLastWeek ? lastWeekWorkSum : thisWeekWorkSum
                )
                
                //View of days of the week
                DayScrollView(showLastWeek: $showLastWeek, weeklyData: showLastWeek ? FetchedAllLastWeekResults : FetchedAllThisWeekResults)
                
                
                Spacer()
                //MARK: - Buttons
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
                            .onTapGesture {
                                self.showAddActivity.toggle()
                            }

                    }
                }
            }
            //**************************************
            //End of VStack

            //Background Blur view (Shown while add activity is open)
            BlurView(style: .systemThinMaterialDark).edgesIgnoringSafeArea(.all)
                .opacity((showAddActivity || showAddFavourite ) ? 0.6 : 0)
                .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                    self.showAddActivity = false
                    self.showAddFavourite = false
                    self.showActivitySelector = false
                })
        
            //MARK: - Add activity view
            AddActivityView(showActivitySelector: $showActivitySelector, activityToSave: $activityToSave, activities: self.allFetchedActivities, showAddActivity: $showAddActivity)
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
                                
                                resetActivity(activityToSave)
                                
                            }
                            self.activityViewState = .zero
                        })
                )
            
            
            //MARK: - Add Favourite View
            //Add activity view
            AddFavouriteView(activityToSave: $activityToSave, activities: allSavedActivities, showAddFavourite: $showAddFavourite)
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
        }
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

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()



//MARK: - Last Week/Current Week Toggle
struct WeekToggle: View {
    
    @Binding var showLastWeek: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Last Week")
                    .padding(.horizontal, 30)
                    .foregroundColor(showLastWeek ? Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)) : Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)))
                    .onTapGesture(count: 1, perform: {
                        showLastWeek = true
                        
                    })
                
                Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1))
                    .frame(width: 2, height: 50, alignment: .center)
                
                Text("This Week")
                    .padding(.horizontal, 30)
                    .foregroundColor(showLastWeek ? Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)) : Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)) )
                    .onTapGesture(count: 1, perform: {
                        showLastWeek = false
                        
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
    var sumOfWeeklyFitnessMinutes: Float
    var sumOfWeeklyLearningMinutes: Float
    var sumOfWeeklyChoresMinutes: Float
    var sumOfWeeklyWorkMinutes: Float
    
    
    var body: some View {
        
        VStack {
            HStack {
                HStack {
                    Text("Minutes Completed: \(sumOfWeeklyWorkMinutes + sumOfWeeklyChoresMinutes + sumOfWeeklyFitnessMinutes + sumOfWeeklyLearningMinutes, specifier: "%.0f")")
                        .font(.system(size: 20, weight: .semibold))
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
                    .padding(.all, 6)
                    
                    HStack(alignment: .top) {
                        Text("Chores \(useHours ? "Hours" : "Minutes"):\(sumOfWeeklyChoresMinutes, specifier: "%.0f")  ")
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

//MARK: - Day Scroll View

struct DayScrollView: View {
    
    @Binding var showLastWeek: Bool
    var weeklyData: FetchedResults<AddedActivity>
    
    var currentWeek : [Date] {
        Array(stride(from: Date().startOfWeek(), through: Date().startOfWeek().addingTimeInterval(6*60*60*24), by:  60*60*24))
    }
    
    var lastWeek : [Date] {
        Array(stride(from: Date().startOfWeek().addingTimeInterval(-7*24*60*60), to: Date().startOfWeek(), by:  60*60*24))
    }
    
    let dateFormatter: DateFormatter = {
        var df = DateFormatter()
        df.dateFormat = "EEEE d"
        return df
    }()
    
    
    var body: some View {
        
        ScrollView(.horizontal) {
            HStack(spacing: 4) {
                //Cycle through days of either last week or this week
                ForEach((showLastWeek ? lastWeek : currentWeek), id: \.self) { day in
                    GeometryReader { geometry in
                        VStack{
                            HStack {
                                Spacer()
                                Text("\(day, formatter: dateFormatter)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .semibold))
                                Spacer()
                            }
                                
                            //For each day fill in information if dates match
                            List {
                                
                                Print(weeklyData)
                                
                                ForEach(weeklyData.filter({ Calendar.current.isDate($0.timestamp ?? Date(), inSameDayAs: day) }), id: \.self) { data in
              
                                    Print(data)
                                    
                                    Text("\(data.name ?? "Unknown Activity")\n")
                                        .font(.system(size: 24))
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    .frame(width: 140, height: 240, alignment: .center)
                }
            }
        }
        .background(Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1)))
        .padding(.leading)
        .padding(.vertical)
     
    }
}





//MARK: - Day View
struct dayView: View {
    
    var day: dayOfWeek
    
    var body: some View {
        ZStack {
            
            Color.black
                
            
            VStack {
                Text("\(day.nameOfDay) \(day.dateOfDay)")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.bottom, 4)
                
                VStack(alignment: .center) {
                    Text("Fitness: \(day.fitness)")
                        .foregroundColor(Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)))
                        .padding(.vertical, 2)
                    
                    Text("Learn: \(day.learning)")
                        .foregroundColor(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
                        .padding(.vertical, 2)
                    
                    Text("Chores: \(day.chores)")
                        .foregroundColor(Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)))
                        .padding(.vertical, 2)
                    
                    Text("Custom: \(day.custom)")
                        .foregroundColor(Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)))
                        .padding(.vertical, 2)
                    
                    Text("Total: \(day.fitness + day.learning + day.chores + day.custom)")
                        .foregroundColor(Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)))
                        .padding(.vertical, 2)
                }
                .font(.system(size: 18, weight: .semibold))
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
    var fitness: Int
    var chores: Int
    var learning: Int
    var custom: Int
    
}


let thisWeekData = [
    
    dayOfWeek(nameOfDay: "Monday", dateOfDay: 19, month: "October", fitness: 360, chores: 200, learning: 300, custom: 240),
    dayOfWeek(nameOfDay: "Tuesday", dateOfDay: 20, month: "October", fitness: 360, chores: 200, learning: 300, custom: 240),
    dayOfWeek(nameOfDay: "Wednesday", dateOfDay: 21, month: "October", fitness: 360, chores: 200, learning: 300, custom: 240),
    dayOfWeek(nameOfDay: "Thursday", dateOfDay: 22, month: "October", fitness: 360, chores: 200, learning: 300, custom: 240),
    dayOfWeek(nameOfDay: "Friday", dateOfDay: 23, month: "October", fitness: 360, chores: 200, learning: 300, custom: 240),
    dayOfWeek(nameOfDay: "Saturday", dateOfDay: 24, month: "October", fitness: 360, chores: 200, learning: 300, custom: 240),
    dayOfWeek(nameOfDay: "Sunday", dateOfDay: 25, month: "October", fitness: 360, chores: 200, learning: 300, custom: 240),

]

let lastWeekData = [
    
    dayOfWeek(nameOfDay: "Monday", dateOfDay: 12, month: "October", fitness: 360, chores: 200, learning: 300, custom: 240),
    dayOfWeek(nameOfDay: "Tuesday", dateOfDay: 13, month: "October", fitness: 360, chores: 200, learning: 300, custom: 240),
    dayOfWeek(nameOfDay: "Wednesday", dateOfDay: 14, month: "October", fitness: 360, chores: 200, learning: 300, custom: 240),
    dayOfWeek(nameOfDay: "Thursday", dateOfDay: 15, month: "October", fitness: 360, chores: 200, learning: 300, custom: 240),
    dayOfWeek(nameOfDay: "Friday", dateOfDay: 16, month: "October", fitness: 360, chores: 200, learning: 300, custom: 240),
    dayOfWeek(nameOfDay: "Saturday", dateOfDay: 17, month: "October", fitness: 360, chores: 200, learning: 300, custom: 240),
    dayOfWeek(nameOfDay: "Sunday", dateOfDay: 18, month: "October", fitness: 360, chores: 200, learning: 300, custom: 240),

]


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

