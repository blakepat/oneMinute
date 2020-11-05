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

    @FetchRequest(entity: ActivityCategory.entity(), sortDescriptors: [])
    var allFetchedItems:FetchedResults<ActivityCategory>
    

    static let dateFormatter: DateFormatter = {
        var df = DateFormatter()
        df.dateFormat = "EEEE, MMM, d, yyyy"
        return df
    }()
    
    @State private var newActivity = ""
    @State var showLastWeek = false
    @State var showAddActivity = false
    @State var showActivitySelector = false
    @State var viewState = CGSize.zero
    
    var body: some View {
        
    
        //Full Screen View
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)

            
            
            //Top area for current week summary
            VStack {
                
                WeekToggle(showLastWeek: $showLastWeek)
                
                DateView()
                    .padding(.bottom, 4)
                
//                SummaryTitleView()
                
                SummaryView()
                
                //TO DO: Insert view of week
                ScrollView(.horizontal) {
                    HStack(spacing: 4) {
                        ForEach(self.showLastWeek ? lastWeekData : thisWeekData) { item in
                            GeometryReader { geometry in
                                dayView(day: item)
                            }
                            .frame(width: 140, height: 200, alignment: .center)
                        }
                    }
                }
                .background(Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1)))
                .padding(.leading)
                .padding(.vertical)
                
                
                
                Spacer()
                
                
                //MARK: - Add Activity Button
                AddActivityButton(showAddActivity: $showAddActivity)
                
                    
            }

            BlurView(style: .systemThinMaterialDark).edgesIgnoringSafeArea(.all)
                .opacity(showAddActivity ? 0.6 : 0)
                .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                    self.showAddActivity = false
                    self.showActivitySelector = false
                })
        
            AddActivityView(showActivitySelector: $showActivitySelector, categories: self.allFetchedItems)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .frame(width: screen.width, height: screen.height - 60, alignment: .leading)
                .offset(x: 0, y: showAddActivity ? 60 : screen.height)
                .offset(y: viewState.height)
                .animation(.easeInOut)
                .gesture(
                    DragGesture()
                        .onChanged({ (value) in
                            self.viewState = value.translation
                        })
                        .onEnded({ (value) in
                            if self.viewState.height > 100 {
                                self.showAddActivity = false
                                self.showActivitySelector = false
                            }
                            self.viewState = .zero
                        })
                )
            
                
        }
        
    }
    
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
//    
    



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
                    .frame(width: .infinity, height: 2, alignment: .center)
                Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
                    .frame(width: screen.width / 2, height: 4, alignment: .leading)
                    .position(x: showLastWeek ? 0 + screen.width / 4 : screen.width / 2 + screen.width / 4)
                    .animation(.easeInOut)
            }
            .frame(width: .infinity, height: 4, alignment: .center)
        }
    }
}

struct SummaryView: View {
    var body: some View {
        
        let preferedUnit = "Minutes"
        let hoursCompleted = "4000"
        
        VStack {
            HStack {
                HStack {
                    Text("Minutes Completed:")
                        .font(.system(size: 20, weight: .semibold))
                    Text("\(hoursCompleted)")
                        .font(.system(size: 20))
                }
            }
            .padding(.all, 6)
            .foregroundColor(.white)
            
            ZStack {
                VStack(alignment: .center) {
                    HStack(alignment: .top) {
                        Text("Fitness \(preferedUnit): 420")
                            .padding(.horizontal, 10)
                            .foregroundColor(Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)))
                        
                        Text("Learning \(preferedUnit): 300")
                            .padding(.horizontal, 10)
                            .foregroundColor(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
                    }
                    .padding(.all, 6)
                    
                    HStack(alignment: .top) {
                        Text("Chores \(preferedUnit): 360")
                            .padding(.horizontal, 10)
                            .foregroundColor(Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)))
                        Text("Work \(preferedUnit): 360")
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

struct DateView: View {
    var body: some View {
        
        let today = Date()
        
        HStack {
            
            Text("\(today, formatter: ContentView.dateFormatter)")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .semibold))
            Spacer()
        }
        .padding(.horizontal)
    }
}


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
                            .foregroundColor(.orange)
                            .padding(.vertical, 2)
                    }
                    .font(.system(size: 18, weight: .semibold))
                    
                }
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




struct AddActivityButton: View {
    
    @Binding var showAddActivity: Bool
    
    var body: some View {
        HStack {
            
            Spacer()
            
            ZStack {
                
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.yellow)
                    //                            .frame(width: 40, height: 40, alignment: .center)
                    .font(.system(size: 44))
                    .padding()
                    .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                        self.showAddActivity.toggle()
                        
                    })
            }
            
            
        }
    }
}


let screen = UIScreen.main.bounds

