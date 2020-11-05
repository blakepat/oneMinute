//
//  AddActivityView.swift
//  oneWeek
//
//  Created by Blake Patenaude on 2020-10-21.
//

import SwiftUI
import CoreData

struct AddActivityView: View {
    
    @State var activitySelected = "fitness"
    @State var placeHolder = "   Select Activity"
    @Binding var showActivitySelector: Bool
    @State var viewState = CGSize.zero
    var categories: FetchedResults<ActivityCategory>
    
    var body: some View {
        
        ZStack {
        
            //MARK: - Background Color
            Color(#colorLiteral(red: 0.2082437575, green: 0.2156656086, blue: 0.2157248855, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
            //MARK: - Pull down tap
                

            //MARK: - Activity Type - (fitness, chores, learning, work)
                HStack {
                    
                    ForEach(categories, id: \.self) { category in
                        
                        
                        
                        GeometryReader { geometry in
                            
                            //Current Selected Activity Category
                        if activitySelected == category.categoryName {
                            
                            ActivityTypeIcon(activityIconName: category.categoryName, isSelected: true)
                                .onTapGesture(count: 1, perform: {
                                    activitySelected = category.categoryName
                                    
                                })
                        
                            
                            //Other 3 categories
                            } else {
                                ActivityTypeIcon(activityIconName: category.categoryName, isSelected: false)
                                    .onTapGesture(count: 1, perform: {
                                        activitySelected = category.categoryName

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
                        
                        Text(placeHolder)
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
            
            
            //MARK: - Activity Notes - 5km run, chest workout, rosetta stone, 1 hour overtime
            
            
            //MARK: - Confirm Activity - add to data set
                
               Spacer()
                
                


                
            }
            
            //MARK: - ActivitySelectorView
                
            ActivitySelectorView(showActivitySelector: $showActivitySelector, allCategories: categories, categorySelected: activitySelected)
                    .frame(width: screen.width, height: screen.height)
                    .offset(x: showActivitySelector ? 0 : screen.width)
                    .offset(y: screen.minY)
                    .edgesIgnoringSafeArea(.all)
                    .offset(x: viewState.width)
                    .animation(.easeInOut)
                    .gesture(
                        DragGesture()
                            .onChanged({ (value) in
                                self.viewState = value.translation
                            })
                            .onEnded({ (value) in
                                if self.viewState.width > 80 {
                                    self.showActivitySelector = false
                                }
                                self.viewState = .zero
                            })
                    )
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
