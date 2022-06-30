//
//  BarChart.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-08-26.
//

import SwiftUI

struct BarChart: View {
              
    @Binding var selectedDate: Date
    var weekOneData: [AddedActivity]
    var weekTwoData: [AddedActivity]
    var weekThreeData: [AddedActivity]
    var weekFourData: [AddedActivity]
    @Binding var isHours: Bool
    let capsuleWidth: CGFloat = screen.size.width * 0.80 - 60
    let capsuleHeight: CGFloat = 36
    
    @State var animater = false

    
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
        
        
        let highestTotal: Float = totalSums.max() ?? 0
        
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
                            .minimumScaleFactor(0.65)
                            .font(.system(size: 13, weight: .semibold))
                            .frame(width: 58, height: capsuleHeight + 8, alignment: .center)
                            .padding(.trailing, 4)
                            .padding(.horizontal, 4)
                        
                        //Bar
                        ZStack(alignment: .leading) {
                            
                            //background capsule
//                            Capsule().frame(width: capsuleWidth, height: capsuleHeight, alignment: .center)
//                                .foregroundColor(Color("charcoalColor"))
                            
                            //stack of category capsules - Cycle through categories
                            HStack(spacing: 0) {
                                ForEach(Array(zip(categories, categories.indices)), id: \.0) { category, index in
                                    
                                    //Layer number of category total over individual category capsule
//                                    ZStack {
                                        
                                        let hasAddedActivity = totalSums[dateIndex] > 0
                                        let categoryCapsuleWidth: Float = (Float(capsuleWidth) / Float(totalSums[dateIndex])) * Float(totalSums[dateIndex]) / highestTotal
                                        let figure: Float = (monthData[dateIndex][index] * (hasAddedActivity ? ((Float(capsuleWidth) / totalSums[dateIndex]) * (totalSums[dateIndex] / highestTotal)) : 0))
                                
                                        
                                        if hasAddedActivity {
                                            Capsule().frame(
                                                width: CGFloat(monthData[dateIndex][index] * (hasAddedActivity ? categoryCapsuleWidth : 0)),
                                                height: capsuleHeight,
                                                alignment: .leading
                                                                    )
                                                .foregroundColor(Color("\(category)Color"))
                                                .offset(x: animater ? 0 : -100)
                                                .animation(.easeOut(duration: 2))
                                                .overlay(Text(hasAddedActivity ? "\(timeConverter(time: monthData[dateIndex][index], timeUnitIsHours: isHours), specifier: decimalsToShow(isHours: isHours))" : "")
                                                            .opacity(
                                                                ((Float("\(Int(monthData[dateIndex][index]))".widthOfString(usingFont: UIFont.systemFont(ofSize: 16))))
                                                                    > figure
                                                                )
                                                                ? 0 : 1))
                                                
                                        }
                                }
                                if totalSums[dateIndex] != highestTotal {
                                    Spacer()
                                }
                                
                                if totalSums[dateIndex] == 0 {
                                    Capsule()
                                        .frame(width: capsuleWidth, height: capsuleHeight, alignment: .center)
                                        .foregroundColor(.minutesBackgroundCharcoal)
                                }
                                
                            }
                            .background(Color.minutesBackgroundCharcoal)
                            .frame(width: capsuleWidth, height: capsuleHeight, alignment: .center)
                            .clipShape(Capsule())
                            .clipped()

                            
                        }

                        //Total for the week (all categories)
                        Text("\(timeConverter(time: totalSums[dateIndex], timeUnitIsHours: isHours), specifier: decimalsToShow(isHours: isHours))")
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
        .onAppear {
            animater = true
        }
    }
}

