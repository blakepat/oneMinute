//
//  PieSliceView.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-08-03.
//

import SwiftUI

struct PieSliceView: View {
    
    var pieSliceData: PieSliceData
    
    var minRadians: Double {
        return Double.pi / 2.0 - (pieSliceData.startingAngle + pieSliceData.endAngle).radians / 2.0
    }
    
    
    var body: some View {
       
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    let width: CGFloat = min(geometry.size.width, geometry.size.height)
                    let height = width
                    
                    let center = CGPoint(x: width * 0.5, y: height * 0.5)
                    
                    path.move(to: center)
                    
                    path.addArc(center: center,
                                radius: width * 0.5,
                                startAngle: Angle(degrees: -90.0) + pieSliceData.startingAngle,
                                endAngle: Angle(degrees: -90.0) + pieSliceData.endAngle,
                                clockwise: false
                    )
                    
                }
                .fill(pieSliceData.color)
                
                if pieSliceData.text != "0%" {
                
                    Text(pieSliceData.text)
                        .position(x: geometry.size.width * 0.5 * CGFloat(1.0 + 0.78 * cos(self.minRadians)),
                                  y: geometry.size.height * 0.5 * CGFloat(1.0 - 0.78 * sin(self.minRadians))
                        )
                        .foregroundColor(.white)
                        .font(.subheadline)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}


struct PieSliceData {
    
    var startingAngle: Angle
    var endAngle: Angle
    var color: Color
    var text: String
    
}


//struct PieSliceView_Previews: PreviewProvider {
//    static var previews: some View {
//        PieSliceView(pieSliceData: PieSliceData(startingAngle: Angle(degrees: 0), endAngle: Angle(degrees: 220), color: Color.black, text: "65%"), categorySelected: CategorySelected.none)
//    }
//}
