//
//  DayScrollView.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-08-26.
//

import SwiftUI

struct DayScrollView: View {
    
    @Binding var showDetailedDayView: Bool
    @Binding var selectedDate: Date
    @Binding var showEditScreen: Bool
    @ObservedObject var activityToSave: ActivityToSave
    @Binding var category1Name: String
    @Binding var category2Name: String
    @Binding var category3Name: String
    @Binding var category4Name: String
    @Binding var isHours: Bool
    
    
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
                                        
                                        ActivityItem(item: data, isHours: isHours)
                                            .padding(.bottom, 2)
                                            .frame(width: 132)
                                    }
                                }
                                Spacer()
                                
                                let dailyTotal = weekOnlyData.filter({ Calendar.current.isDate($0.timestamp ?? Date(), inSameDayAs: day)}).reduce(0) {$0 + $1.duration}
                                
                                Text("Total: \(timeConverter(time: dailyTotal, timeUnitIsHours: isHours), specifier: decimalsToShow(isHours: isHours))")
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
                                isHours: $isHours,
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
    var isHours: Bool
    
    var body: some View {
        
        HStack {
            Text("\(item.name ?? "Unknown Activity")")
                .font(.system(size: 16))
                .foregroundColor(Color("\(item.category ?? "category1")Color"))
                
            Spacer()
            
            Text("\(timeConverter(time: item.duration, timeUnitIsHours: isHours), specifier: decimalsToShow(isHours: isHours))")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color("\(item.category ?? "category1")Color"))
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

