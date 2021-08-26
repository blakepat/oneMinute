//
//  WeekToggle.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-08-26.
//

import SwiftUI

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
                        dateSelected = Date().startOfWeek().addingTimeInterval(-6*24*60*60)
                        
                    })

                
                Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1))
                    .frame(width: 2, height: 50, alignment: .center)
                
                Text("This Week")
                    .padding(.horizontal, 30)
                    .foregroundColor(showLastWeek ? Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)) : Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)) )
                    .frame(width: screen.size.width / 2 - 1)
                    .onTapGesture(count: 1, perform: {
                        showLastWeek = false
                        dateSelected = Date()
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

