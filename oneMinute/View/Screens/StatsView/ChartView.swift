//
//  ChartView.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2022-07-08.
//

import SwiftUI

struct ChartView: View {
    
    private let data: [Double]
    private var maxY: Double
    private var minY: Double
    private let lineColor: Color
    private let dates: [Date]
    private let startingDate: Date
    private let endingDate: Date
    private let timeframe: TimeFrame
    var isHours: Bool
    
    @State private var percentage: CGFloat = 0
    
    init(activities: [Double], activeIndex: Int, timeframe: TimeFrame, dates: [Date], isHours: Bool) {
        data = activities
        self.dates = dates
        self.timeframe = timeframe
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        startingDate = dates.first ?? Date()
        endingDate = dates.last ?? Date()
        self.isHours = isHours
        
        if activeIndex == -1 {
            lineColor = .minutesYellow
        } else {
            lineColor = getCategoryColor(categories[activeIndex])
        }
    }
    
    let dateFormatter: DateFormatter = {
        var df = DateFormatter()
        df.dateFormat = "MMM, d"
        return df
    }()
    
    let allTimeDateFormatter: DateFormatter = {
        var df = DateFormatter()
        df.dateFormat = "dd/MM/YY"
        return df
    }()
    
    
    var body: some View {
        VStack {
            chartView
                .frame(width: screen.width - 50, height: 200, alignment: .center)
                .background(chartBackground)
                .overlay(chartYAxis.offset(x: -20), alignment: .leading)
            
            chartXAxis
        }
        .font(.caption)
        .foregroundColor(.gray)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 2)) {
                    percentage = 1
                }
            }
        }
        .onChange(of: data) { _ in
            percentage = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 1.5)) {
                    percentage = 1
                }
            }
        }
    }
}


extension ChartView {
    
    private var chartView: some View {
        GeometryReader { geometry in
            Path { path in
                for index in dates.indices {
                    
                    //if you had 300 screen width and 100 items it would make each item 3 pixels then for each data item you move over 3 pixels
                    let xPosition = geometry.size.width / CGFloat(dates.count) * CGFloat(index + 1)
                    
                    var yAxis = maxY - minY
                    
                    if maxY == minY {
                        yAxis = minY + 100
                    }
                    
                    
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 10, x: 0, y: 6)
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0, y: 16)
        }
    }
    
    
    private var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartYAxis: some View {
        VStack {
            if isHours {
                let hoursMaxY = timeConverter(time: Float(maxY), timeUnitIsHours: true)
                let hoursMinY = timeConverter(time: Float(minY), timeUnitIsHours: true)
                
                Text("\(hoursMaxY == hoursMinY ? hoursMinY + 10 : hoursMaxY, specifier: "%.1f")")
                Spacer()
                let mid = hoursMaxY == hoursMinY ? hoursMinY + 5 : (hoursMaxY + hoursMinY) / 2
                Text("\(mid, specifier: "%.1f")")
                Spacer()
                Text("\(hoursMinY, specifier: "%.1f")")
                
            } else {
                Text("\(maxY == minY ? minY + 100 : maxY, specifier: "%.0f")")
                Spacer()
                let mid = maxY == minY ? minY + 50 : (maxY + minY) / 2
                Text("\(mid, specifier: "%.0f")")
                Spacer()
                Text("\(minY, specifier: "%.0f")")
            }
        }
    }
    
    private var chartXAxis: some View {
        HStack {
            Text(startingDate, formatter: timeframe == .allTime ? allTimeDateFormatter : dateFormatter)
            Spacer()
            Text(endingDate, formatter: timeframe == .allTime ? allTimeDateFormatter : dateFormatter)
        }
        .padding(.horizontal)
    }
}
