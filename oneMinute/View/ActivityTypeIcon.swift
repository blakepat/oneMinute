//
//  ActivityTypeIcon.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-04-12.
//

import Foundation
import SwiftUI


//MARK: - Activity Icon Struct
struct ActivityTypeIcon: View {
    
    var activityIconName: String
    var activityName: String
    @State var isSelected: Bool
    var font: CGFloat
    var iconSizeScreenDividedBy: CGFloat
    

    var body: some View {
        
        VStack(spacing: 0) {
            VStack {
                
                Image(activityIconName).renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: screen.width / iconSizeScreenDividedBy, height: screen.width / iconSizeScreenDividedBy, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .foregroundColor(isSelected ? Color("\(activityIconName)Color") : .white)
                    .background(Color(.black))
                    .font(.system(size: font))
                
            }
            .clipShape(Circle())
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            
            
            Text(activityName.capitalized)
                .font(.system(size: font * 0.6))
                .foregroundColor(isSelected ? Color("\(activityIconName)Color") : .white)
            
        }
        .padding(.vertical, 0)
    }
}
