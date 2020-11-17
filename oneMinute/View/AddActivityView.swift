//
//  AddActivityView.swift
//  oneWeek
//
//  Created by Blake Patenaude on 2020-10-21.
//

import SwiftUI
import CoreData

struct AddActivityView: View {
    
    
    @Environment(\.managedObjectContext) private var viewContext
    
    //Passed Items
    @Binding var showActivitySelector: Bool
    @Binding var activityToSave: ActivityToSave
    var activities: FetchedResults<Activity>
    @Binding var showAddActivity: Bool
    
    
    //Local Items
    @State var categorySelected = "fitness"
    @State var viewState = CGSize.zero
    @State var showingAlert = false
    @State var showCalendar = false
    @State var selectedDate = Date()
    
    
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
                                    activityToSave.category = category
                                    categorySelected = category
                                    
                                })
                        
                            
                            //Other 3 categories
                            } else {
                                ActivityTypeIcon(activityIconName: category, isSelected: false)
                                    .onTapGesture(count: 1, perform: {
                                        activityToSave.category = category
                                        categorySelected = category
                                        activityToSave.activityName = "Select Activity..."
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
                        
                        Text(activityToSave.activityName)
                            .frame(width: screen.width - 50, height: 40, alignment: .leading)
                            .padding(.leading, 4)
                            .padding(.horizontal, 6)
                            .background(Color(.black))
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .foregroundColor(Color("\(categorySelected)Color"))
                            .font(.system(size: 26))
                            .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                                self.showActivitySelector = true
                            })  
                    }
                }
                .padding(.vertical)
            //MARK: - Activity Date - November 10
                VStack(alignment: .leading) {
                    
                    Text("Time Started: ")
                        .font(.system(size: 24, weight: .semibold))
                        .padding(.vertical, 0)
                        .padding(.leading, 8)
                    
                    HStack {
                        
                        //calendar image
                        Image(systemName: "calendar")
                            .padding(.leading, 8)
                            .font(.system(size: 24))
                        
                        
                        DatePicker("", selection: $selectedDate)
                            .datePickerStyle(CompactDatePickerStyle())
                            .frame(width: screen.width / 2, height: 50, alignment: .leading)
                            .colorMultiply(.black)
                            
                        Spacer()
                    
                    }
                    .padding(.vertical, 8)
                
                
            
                }
                
            
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
                            
                            Picker(selection: $activityToSave.hours, label: Text("Hours")) {
                                ForEach(0 ..< self.hourArray.count) { number in
                                    Text(self.hourArray[number]).tag(Float(number))
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
                            Picker(selection: $activityToSave.minutes, label: Text("Hours")) {
                                ForEach(0 ..< self.minutesArray.count) { number in
                                    Text(self.minutesArray[number]).tag(Float(number))
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
                    .frame(height: 120)
                }
                
            //MARK: - Activity Notes - 5km run, chest workout, rosetta stone, 1 hour overtime
                
                VStack(alignment: .leading, spacing: 0) {
                
                Text("Notes: ")
                    .font(.system(size: 24, weight: .semibold))
                    .padding(.vertical, 0)
                    
                    
                    TextField("notes", text: $activityToSave.notes)
                        .frame(width: screen.width - 16, height: screen.height / 8, alignment: .topLeading)
                    .background(Color.black)
                    .foregroundColor(.white)
                    
                    
                }
            //MARK: - Confirm Activity - add to data set
             
                ZStack {
                    
                    Color("\(categorySelected)Color")
                    
                    Text("Add Activity")
                        .foregroundColor(.black)
                        .font(.system(size: 18, weight: .semibold))
                    
                }
                .frame(width: screen.width - 16, height: 60, alignment: .center)
                .padding(.vertical, 0)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .padding(.top, 24)
                .onTapGesture {
                    
                    print(activityToSave.activityName)
                    print(activityToSave.minutes)
                    print(activityToSave.hours)
                    
                    //If activity and duration has been selected save and dismiss screen
                    if activityToSave.minutes + activityToSave.hours != 0 && activityToSave.activityName != "Select Activity..." {
                        //save activity
                        saveActivity(activity: activityToSave, date: selectedDate, favourite: false)
                        //reset activity
                        resetActivity(activityToSave)
                        categorySelected = "fitness"
                        
                        
                        //dismiss screen
                        self.showAddActivity = false
                    //if missing info show alert
                    } else {
                        self.showingAlert = true
                    }
                }.alert(isPresented: $showingAlert) {
                    Alert(title: Text("Form Not Completed"), message: Text("Please ensure you have selected an Activity and Duration, Thank you!"), dismissButton: .cancel(Text("Okay")))
                }
                
                
            //MARK: - Save and Add to Favourites
                
                
                ZStack {
                    
                    Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
                    
                    Text("Add Activity & Save to Favourites")
                        .foregroundColor(.black)
                        .font(.system(size: 18, weight: .semibold))
                    
                }
                .frame(width: screen.width - 16, height: 60, alignment: .center)
                .padding(.vertical, 0)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .onTapGesture {
                    
                    
                    print(activityToSave.activityName)
                    
                    
                    //If activity and duration has been selected save and dismiss screen
                    if activityToSave.minutes + activityToSave.hours != 0 && activityToSave.activityName != "Select Activity..." {
                        //save activity
                        saveActivity(activity: activityToSave, date: selectedDate, favourite: true)
                        
                        //reset activity
                        resetActivity(activityToSave)
                        categorySelected = "fitness"
                        
                        //dismiss screen
                        self.showAddActivity = false
                    //if missing info show alert
                    } else {
                        self.showingAlert = true
                    }
                }.alert(isPresented: $showingAlert) {
                    Alert(title: Text("Form Not Completed"), message: Text("Please ensure you have selected an Activity and Duration, Thank you!"), dismissButton: .cancel(Text("Okay")))
                }
                
                
                
                
            //Spacer at bottom to push button up
               Spacer()
                
            }
            
            //*******************************************
            //End of VStack
            
            
            //MARK: - ActivitySelectorView
                
            ActivitySelectorView(showActivitySelector: $showActivitySelector, activityToSave: $activityToSave, allActivities: activities)
                    .frame(width: screen.width, height: screen.height)
                    .offset(x: showActivitySelector ? 0 : screen.width)
                    .offset(y: screen.minY)
                    .edgesIgnoringSafeArea(.all)
                    .offset(x: viewState.width)
                    .animation(.easeInOut)
        }
        
    }
    
    //MARK: - Reset Activity Function
    private func resetActivity(_ : ActivityToSave) {
        activityToSave.activityName = "Select Activity"
        activityToSave.category = "fitness"
        activityToSave.hours = 0
        activityToSave.minutes = 0
        activityToSave.notes = ""
    }
    
    
    //MARK: - Save Item
    private func saveActivity(activity: ActivityToSave, date: Date, favourite: Bool) {
        withAnimation {
            
                let newAddedActivity = AddedActivity(context: viewContext)
                newAddedActivity.name = activity.activityName
                newAddedActivity.category = activity.category
                newAddedActivity.notes = activity.notes
                newAddedActivity.duration = activity.minutes + (activity.hours * 60)
                newAddedActivity.timestamp = date
                newAddedActivity.favourite = favourite
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}



//MARK: - Activity Icon Struct
struct ActivityTypeIcon: View {
    
    var activityIconName: String
    @State var isSelected: Bool
    

    var body: some View {
        
        VStack(spacing: 0) {
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
            .padding(.vertical, 4)
            
            
            Text(activityIconName.capitalized)
                .font(.system(size: 18))
                .foregroundColor(.black)
            
        }
        .padding(.vertical, 0)
    }
}

