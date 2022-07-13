//
//  SummaryView.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-08-26.
//

import SwiftUI

struct SummaryView: View {
        
        @Environment(\.managedObjectContext) private var viewContext
        
        var selectedDate: Date
        var allData: FetchedResults<AddedActivity>
        @State var timeFrameChanger = TimeFrame.week
        @State var totalSummary = ""
        @Binding var isHours: Bool
        
        //Category Names
        @Binding var category1Name: String
        @Binding var category2Name: String
        @Binding var category3Name: String
        @Binding var category4Name: String
        
        var body: some View {
            
            VStack {
                HStack {
                    HStack(spacing: 0) {
                        Text("Total \(timeFrameStringGetter(timeFrameChanger).capitalized) \(timeUnitName(isHours: isHours)): ")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.minutesYellow)
                        Text("\(timeConverter(time: totalSummary(timeFrame: timeFrameChanger, results: allData), timeUnitIsHours: isHours), specifier: decimalsToShow(isHours: isHours))")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.minutesYellow)
                    }
                }
                .padding(6)
                .padding(.top, 4)
                .foregroundColor(.white)
                
                ZStack {
                    VStack(alignment: .center, spacing: 2) {
                        
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
                            
                            
                            Text("Year")
                                .foregroundColor(timeFrameChanger == .year ? .white : .gray)
                                .onTapGesture {
                                    self.timeFrameChanger = TimeFrame.year
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
            .frame(width: screen.size.width * 0.94, height: 120)
            .background(Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1)))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .padding(.horizontal)
        }
        
        
        func totalSummary(timeFrame: TimeFrame, results: FetchedResults<AddedActivity>) -> Float {
            
            if timeFrame == TimeFrame.week {
                return results.filter({$0.timestamp ?? Date() > selectedDate.startOfWeek() && $0.timestamp ?? Date() < selectedDate.startOfWeek().addingTimeInterval(7*24*60*60)}).reduce(0) { $0 + $1.duration }
            } else if timeFrame == TimeFrame.month {
                return results.filter({$0.timestamp ?? Date() > selectedDate.startOfMonth && $0.timestamp ?? Date() < selectedDate.endOfMonth }).reduce(0) { $0 + $1.duration }
            } else if timeFrame == TimeFrame.year {
                return results.filter({ $0.timestamp?.isInThisYear() ?? true }).reduce(0) { $0 + $1.duration }
            } else {
                return results.reduce(0) { $0 + $1.duration }
            }
        }
        
        
        func categorySummary(timeFrame: TimeFrame, results: FetchedResults<AddedActivity>, category: String) -> Float {
            
            if timeFrame == TimeFrame.week {
                return results.filter({$0.category == category && $0.timestamp ?? Date() > selectedDate.startOfWeek() && $0.timestamp ?? Date() < selectedDate.startOfWeek().addingTimeInterval(7*24*60*60)}).reduce(0) { $0 + $1.duration }
            } else if timeFrame == TimeFrame.month {
                return results.filter({$0.category == category && $0.timestamp ?? Date() > selectedDate.startOfMonth && $0.timestamp ?? Date() < selectedDate.endOfMonth }).reduce(0) { $0 + $1.duration }
            } else if timeFrame == TimeFrame.year {
                return results.filter({$0.category == category && $0.timestamp?.isInThisYear() ?? true }).reduce(0) { $0 + $1.duration }
            } else {
                return results.filter({$0.category == category}).reduce(0) { $0 + $1.duration }
            }
            
        }
}
