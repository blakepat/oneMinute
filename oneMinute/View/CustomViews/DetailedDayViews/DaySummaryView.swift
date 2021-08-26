//
//  DaySummaryView.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-08-26.
//

import SwiftUI

struct DaySummaryView: View {
    
    var sumOfWeeklyFitnessMinutes: Float
    var sumOfWeeklyLearningMinutes: Float
    var sumOfWeeklyChoresMinutes: Float
    var sumOfWeeklyWorkMinutes: Float
    
    @Binding var category1Name: String
    @Binding var category2Name: String
    @Binding var category3Name: String
    @Binding var category4Name: String
    @Binding var isHours: Bool
    
    var body: some View {
        
        let totalSum : Float = { sumOfWeeklyWorkMinutes + sumOfWeeklyChoresMinutes + sumOfWeeklyFitnessMinutes + sumOfWeeklyLearningMinutes }()
        
        VStack(alignment: .center) {
            HStack {
                VStack {
                    Text("Total Daily Minutes: \(totalSum, specifier: "%.0f")")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color("defaultYellow"))
                    
                    Text("(\(totalSum / 60, specifier: "%.2f") hours) ")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color("defaultYellow"))
                }
            }
            .padding(.all, 6)
            .foregroundColor(.white)
            
            ZStack {
                VStack(alignment: .center) {
                    HStack(alignment: .top) {
                        Text("\(category1Name.capitalized): \(timeConverter(time: sumOfWeeklyFitnessMinutes, timeUnitIsHours: isHours), specifier: decimalsToShow(isHours: isHours)) ")
                            .padding(.horizontal, 10)
                            .foregroundColor(Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)))
                        
                        Text("\(category2Name.capitalized): \(timeConverter(time: sumOfWeeklyLearningMinutes, timeUnitIsHours: isHours), specifier: decimalsToShow(isHours: isHours))  ")
                            .padding(.horizontal, 10)
                            .foregroundColor(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
                    }
                    .padding(.vertical, 6)
                    
                    HStack(alignment: .top) {
                        Text("\(category3Name.capitalized): \(timeConverter(time: sumOfWeeklyChoresMinutes, timeUnitIsHours: isHours), specifier: decimalsToShow(isHours: isHours))  ")
                            .padding(.horizontal, 10)
                            .foregroundColor(Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)))
                        Text("\(category4Name.capitalized): \(timeConverter(time: sumOfWeeklyWorkMinutes, timeUnitIsHours: isHours), specifier: decimalsToShow(isHours: isHours)) ")
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
