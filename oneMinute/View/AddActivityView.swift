//
//  AddActivityView.swift
//  oneWeek
//
//  Created by Blake Patenaude on 2020-10-21.
//

import SwiftUI
import CoreData

struct AddActivityView: View {
    
    @State var hourPickerSelection = 0
    @State var minutePickerSelection = 0
    @State var categorySelected = "fitness"
    @Binding var showActivitySelector: Bool
    @State var viewState = CGSize.zero
    @State var selectedActivity: String
    var activities: FetchedResults<Activity>
    
    let hourArray = (0...24).map{"\($0)"}
    let minutesArray = (0...60).map{"\($0)"}
    
    var body: some View {
        
        let categoryNames = ["fitness", "learning", "chores", "work"]
        
        ZStack {
        
            //MARK: - Background Color
            Color(#colorLiteral(red: 0.2082437575, green: 0.2156656086, blue: 0.2157248855, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
            //MARK: - Pull down tap
                HStack {
                    
                    Spacer()
                    Color(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .frame(width: 50, height: 8, alignment: .center)
                        .padding(.top, 8)
                        .padding(.bottom, 0)
                        
                    Spacer()
                }
                
            //MARK: - Activity Type - (fitness, chores, learning, work)
                HStack {
                    ForEach(categoryNames, id: \.self) { category in
                        GeometryReader { geometry in
                            //Current Selected Activity Category
                        if categorySelected == category {
                            
                            ActivityTypeIcon(activityIconName: category, isSelected: true)
                                .onTapGesture(count: 1, perform: {
                                    categorySelected = category
                                })
                        
                            
                            //Other 3 categories
                            } else {
                                ActivityTypeIcon(activityIconName: category, isSelected: false)
                                    .onTapGesture(count: 1, perform: {
                                        categorySelected = category

                                    })
                            }
                        }
                    }
                }
                .frame(width: screen.width, height: screen.width / 4, alignment: .center)
                
            //MARK: - Activity Name - IE: run, laundry, learn french, Work
            //Create text field with a auto complete from list (if item is not on list pop up to assign point value per hour
                
                HStack(spacing: 4) {
                    
                    Image(systemName: "list.bullet")
                        .padding(.leading, 8)
                        .font(.system(size: 24))
                        
                    
                    ZStack(alignment: .leading) {
                        
                        Text(selectedActivity)
                            .frame(width: screen.width - 50, height: 40, alignment: .leading)
                            .padding(.leading, 4)
                            .background(Color(.black))
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .padding(.horizontal, 6)
                            .foregroundColor(.gray)
                            .font(.system(size: 32))
                            .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                                self.showActivitySelector = true
                            })  
                    }
                }
                .padding(.vertical)
                
            
            //MARK: - Activity Time - 45 minutes
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("Duration: ")
                        .font(.system(size: 24, weight: .semibold))
                        .padding(.vertical, 0)
                        .padding(.leading, 8)
                    
                    GeometryReader { geometry in
                        HStack {
                            
                            //clock image
                            Image(systemName: "clock")
                                .padding(.leading, 8)
                                .font(.system(size: 24))
                            
                            //Hour Selection
                            
                            Picker(selection: self.$hourPickerSelection, label: Text("Hours")) {
                                ForEach(0 ..< self.hourArray.count) { number in
                                    Text(self.hourArray[number]).tag(number)
                                }
                            }
                            .frame(width: 100, height: 100, alignment: .center)
                            .clipped()
                            
        
                            
                            //hour signafier
                            Text("hours")
                                .font(.system(size: 16, weight: .semibold))
                            
                            
                            //Spacer
                            Spacer()
                            
                            
                            
                           //Minute Selection
                            Picker(selection: self.$minutePickerSelection, label: Text("Hours")) {
                                ForEach(0 ..< self.minutesArray.count) { number in
                                    Text(self.minutesArray[number]).tag(number)
                                }
                            }
                            .frame(width: 100, height: 100, alignment: .center)
                            .clipped()
                            
                            //minute signafier
                            Text("minutes")
                                .font(.system(size: 16, weight: .semibold))
                            
                            Spacer()
                        }
                    }
                }
                
            //MARK: - Activity Notes - 5km run, chest workout, rosetta stone, 1 hour overtime
            
            
            //MARK: - Confirm Activity - add to data set
                
               Spacer()
                
                


                
            }
            
            //MARK: - ActivitySelectorView
                
            ActivitySelectorView(showActivitySelector: $showActivitySelector, selectedActivity: $selectedActivity, allActivities: activities, selectedCategoryName: categorySelected)
                    .frame(width: screen.width, height: screen.height)
                    .offset(x: showActivitySelector ? 0 : screen.width)
                    .offset(y: screen.minY)
                    .edgesIgnoringSafeArea(.all)
                    .offset(x: viewState.width)
                    .animation(.easeInOut)
        }
    }
}

//struct AddActivityView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddActivityView(showActivitySelector: .constant(false))
//    }
//}

//MARK: - Activity Icon
struct ActivityTypeIcon: View {
    
    var activityIconName: String
    @State var isSelected: Bool

    var body: some View {
        VStack {
            
            Image(activityIconName).renderingMode(.template)
                .resizable()
                .scaledToFit()
                .padding()
                .frame(width: screen.width / 5, height: screen.width / 5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor(isSelected ? Color("\(activityIconName)Color") : .white)
                .background(Color(.black))
                .font(.system(size: 30))
            
        }
        .clipShape(Circle())
        .padding(.horizontal, 6)
        .padding(.vertical)
    }
}





//Function to request either system image or XCAsset (Not needed)
//    var isSystemImage: Bool
//
//    func isSystemImage(imageName: String, isSystemImage: Bool) -> Image {
//        if isSystemImage {
//            return Image(systemName: imageName)
//        } else {
//            return Image(imageName).renderingMode(.template)
//                .resizable()
//        }
//    }
//
