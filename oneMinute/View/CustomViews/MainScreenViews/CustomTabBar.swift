//
//  CustomTabBar.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-08-26.
//

import SwiftUI

struct CustomTabBar: View {
    
    @Binding var activeSheet: ActiveSheet?
    @Binding var showStatsView: Bool
    @Binding var showAddFavourite: Bool
    @Binding var showHistoryView: Bool
    @Binding var showAddActivity: Bool
    @Binding var showActivitySelector: Bool
    @Binding var showCategoryNameEditor: Bool
    @Binding var shouldShowModal: Bool
    @Binding var showSettings: Bool
    
    @State private var selectedIndex = 0
    private let tabBarImageNames = ["chart.bar.doc.horizontal", "book.circle.fill", "plus.app.fill", "bookmark.circle.fill", "gear"]
    
    var body: some View {
    
        
        HStack {
            ForEach(0..<5) { num in
                Button(action: {
                    //Button Fuctions:
                    selectedIndex = num
                    
                    //Show Stats View Button
                    if num == 0 {
                        shouldShowModal.toggle()
                        activeSheet = .first
                        self.showStatsView.toggle()
                    }
                    
                    //History Button
                    if num == 1 {
                        shouldShowModal.toggle()
                        activeSheet = .second
                        self.showHistoryView.toggle()
                        return
                    }
                    
                    //Add Activity Button
                    if num == 2 {
                        shouldShowModal.toggle()
                        activeSheet = .third
                        self.showAddActivity.toggle()
                        return
                    }
                    //Add Favourite Button
                    if num == 3 {
                        shouldShowModal.toggle()
                        activeSheet = .fourth
                        self.showAddFavourite.toggle()
                        return
                    }
                    
                    if num == 4 {
                        shouldShowModal.toggle()
                        activeSheet = .fifth
                        self.showSettings.toggle()
                    }
                    
                }
                , label: {
                    
                    //Button Images:
                    Spacer()
                    
                    //Add Activity Button
                    if num == 2 {
                        ZStack {
                            let colorArray: [Color] = [Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)), Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)), Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))]
                            
                            ZStack {
                                
                                Circle()
                                    .foregroundColor(.minutesBackgroundBlack)
                                    .frame(width: 72, height: 72, alignment: .center)
                                
                                LinearGradient(gradient: Gradient(colors: colorArray), startPoint: .topLeading, endPoint: .bottomTrailing)
                                    .mask(Image(systemName: "plus.circle.fill")
                                            .font(.system(size: 48)))
                                .frame(width: 48, height: 48, alignment: .center)
                            }
                            .offset(y: -14)
                            
                        }
                        
                        Spacer()
                        //All other button images
                    } else {
                        Image(systemName: tabBarImageNames[num])
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(selectedIndex == num && shouldShowModal ? .yellow : .init(white: 0.8))
                        
                        Spacer()
                        
                    }
                })
            }
            Spacer()
        }
        .frame(height: 40)
    }

}

//MARK - Add Activity Button
struct AddActivityButton: View {
    
    var body: some View {
        ZStack {
            
            let colorArray: [Color] = [Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)), Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)), Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)), Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))]
            
            LinearGradient(gradient: Gradient(colors: colorArray), startPoint: .topLeading, endPoint: .bottomTrailing)
                .mask(Image(systemName: "plus.circle.fill")
                        .font(.system(size: 40)))
                .frame(width: 40, height: 40, alignment: .center)
            
        }
    }
}
