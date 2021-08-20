//
//  PieChartView.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-08-03.
//

import SwiftUI

struct PieChartView: View {
    
    public let values: [Double]
    public let colors: [Color]
    public let names: [String]
    
    public var backgroundColor: Color
    
//    public var widthFraction: CGFloat = 1
    public var innerRadiusFraction: CGFloat
    
    @Binding var activeIndex: Int    
    
    var slices: [PieSliceData] {
        let sum = values.reduce(0, +)
        var endDeg: Double = 0
        var tempSlices: [PieSliceData] = []
        
        for (i, value) in values.enumerated() {
            let degrees: Double = value * 360 / sum
            tempSlices.append(PieSliceData(startingAngle: Angle(degrees: endDeg), endAngle: Angle(degrees: endDeg + degrees), color: self.colors[i], text: String(format: "%0.f%%", value * 100 / sum)))
            endDeg += degrees
        }
        
        return tempSlices
    }
    
    var body: some View {
        
        ZStack {
            
            backgroundColor
                .onTapGesture {
                    self.activeIndex = -1
                }
            
            GeometryReader { geometry in
                VStack {
                    ZStack{
                                            
                        ForEach(0..<self.values.count) { i in
                            PieSliceView(pieSliceData: self.slices[i])
                                .scaleEffect(self.activeIndex == i ? 1.03 : 1)
                                .animation(Animation.spring())
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    let radius = 0.5 * geometry.size.width
                                    let diff = CGPoint(x: value.location.x - radius, y: radius - value.location.y)
                                    let dist = pow(pow(diff.x, 2.0) + pow(diff.y, 2.0), 0.5)
                                    if (dist > radius || dist < radius * innerRadiusFraction) {
                                        self.activeIndex = -1
                                        return
                                    }
                                    var radians = Double(atan2(diff.x, diff.y))
                                    if (radians < 0) {
                                        radians = 2 * Double.pi + radians
                                    }
                                    
                                    for (i, slice) in slices.enumerated() {
                                        if (radians < slice.endAngle.radians) {
                                            self.activeIndex = i
                                            break
                                        }
                                    }
                                }
    //                            .onEnded { value in
    //                                self.activeIndex = -1
    //                            }
                        )
                            Circle()
                            .fill(self.backgroundColor)
                            .frame(width: geometry.size.width * innerRadiusFraction, height: geometry.size.width * innerRadiusFraction)
                            .onTapGesture {
                                self.activeIndex = -1
                            }
                        
                        VStack {
                            Text(self.activeIndex == -1 ? "Total" : names[self.activeIndex])
                                .font(.title)
                                .foregroundColor(Color.gray)
                            Text(String(format: "%0.f", self.activeIndex == -1 ? values.reduce(0, +) : values[self.activeIndex]))
                                .font(.title)
                        }
                    }
    //                PieChartRows(colors: self.colors, names: self.names, values: self.values.map { String(format: "%0.f", $0) }, percents: self.values.map { String(format: "%0.f%%", $0 * 100 / self.values.reduce(0, +)) })
                }
                
                .foregroundColor(.white)
            }
            .padding(.horizontal, 30)
        }
    }
}

//struct PieChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        PieChartView(values: [1300, 500, 300], colors: [Color.blue, Color.green, Color.orange], names: ["Rent", "Transport", "Education"], backgroundColor: Color(red: 21 / 255, green: 24 / 255, blue: 30 / 255, opacity: 1.0), innerRadiusFraction: 0.6)
//    }
//}
