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
    
    lazy var weekToDisplay: [Date] = {
        
        return Date.dates(from: selectedDate.startOfWeek(), to: selectedDate.endOfWeek)
    }()
    
    func getDates() -> [Date] {
        var mutableSelf = self
        return mutableSelf.weekToDisplay
    }
    
    @StateObject var scrollObject = ScrollToModel()
    
    var weekOnlyData: [AddedActivity]
    
    let dateFormatter: DateFormatter = {
        var df = DateFormatter()
        df.dateFormat = "EEEE d"
        return df
    }()
    
    @Binding var activeSheet: ActiveSheet?
    

    
    var body: some View {
        
        
        
        ScrollView(.horizontal) {
            ScrollViewReader { sp in
                HStack(spacing: 4) {
                    //Cycle through days of either last week or this week
                    ForEach((getDates()), id: \.self) { day in
                        GeometryReader { geometry in
                            VStack(spacing: 0){
                                HStack {
                                    Spacer()
                                    Text("\(day, formatter: dateFormatter)")
                                        .foregroundColor((Calendar.current.isDate(day, inSameDayAs: Date())) ? Color("defaultYellow") : .white)
                                        .font(.system(size: 20, weight: (Calendar.current.isDate(day, inSameDayAs: Date())) ? .bold : .semibold))
                                    Spacer()
                                }.padding(.vertical, 4)
                                
                                Divider()
                                    .padding(.bottom, 2)
                                
                                ScrollView(.vertical) {
                                    //For each day fill in information if dates match
                                    ForEach(weekOnlyData.filter({ Calendar.current.isDate($0.timestamp ?? Date(), inSameDayAs: day)}), id: \.self) { data in
                                        
                                        ActivityItem(item: data, isHours: isHours)
                                            .padding(.bottom, 2)
                                            .frame(width: 132, height: 36)
                                            .padding(8)
                                            .background(Color("\(data.category ?? "category1")Color").opacity(0.25))
                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                            
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
                                activityToSave: activityToSave,
                                dailyData:  weekOnlyData,
                                showEditScreen: $showEditScreen,
                                date: $selectedDate,
                                category1Name: $category1Name,
                                category2Name: $category2Name,
                                category3Name: $category3Name,
                                category4Name: $category4Name,
                                isHours: $isHours,
                                activeSheet: $activeSheet
                            )
                            .environmentObject(activityToSave)
//                            .offset(y: 40)
                        }
                    }
                }
                .onReceive(scrollObject.$direction) { action in
                                        guard !getDates().isEmpty else { return }
                                        withAnimation {
                                            switch action {
                                                case .top:
                                                    sp.scrollTo(getDates().first!, anchor: .leading)
                                                case .end:
                                                    sp.scrollTo(getDates().last!, anchor: .trailing)
                                                case .point(let point):
                                                    sp.scrollTo(getDates()[point], anchor: .center)
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
        
        VStack {
            HStack {
                Text("\(item.name ?? "Unknown Activity")")
                    .font(.footnote)
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.7)
                    .lineLimit(2)
                    
                Spacer()
                
                Text("\(timeConverter(time: item.duration, timeUnitIsHours: isHours), specifier: decimalsToShow(isHours: isHours))")
                    .font(.body)
                    .foregroundColor(.white)
                    .minimumScaleFactor(0.7)
            }
            Spacer()
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

