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
    
    //Fetch listed activities
    @FetchRequest(entity: Activity.entity(), sortDescriptors: [])
    var activities: FetchedResults<Activity>
    
    
    //Passed Items
    @Binding var showActivitySelector: Bool
    @State var activityToSave: ActivityToSave
    @Binding var showAddActivity: Bool
    @State var isEditScreen: Bool
    @Binding var selectedDate: Date
    @Binding var itemToDelete: AddedActivity
    @Binding var showingNameEditor: Bool
    
    //Local Items
    @State var viewState = CGSize.zero
    @State var showingAlert = false
    @State var showCalendar = false
    let categories = ["category1", "category2", "category3", "category4"]
    @State var activityName = "Select Activity..."
    
    //MARK: - Category Names
    @Binding var category1Name: String
    @Binding var category2Name: String
    @Binding var category3Name: String
    @Binding var category4Name: String
    
    let hourArray = (0...24).map{"\($0)"}
    let minutesArray = (0...60).map{"\($0)"}
    
    var body: some View {
        
        let categoryNames = [category1Name, category2Name, category3Name, category4Name]
        
        ZStack {
        
            //MARK: - Background Color
            Color(#colorLiteral(red: 0.2082437575, green: 0.2156656086, blue: 0.2157248855, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                
            //MARK: - Pull down tap
                HStack {
                    
                    Spacer()
                    Color(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .frame(width: 50, height: 8, alignment: .center)
                        .padding(.top, 20)
                        .padding(.bottom, 0)
                        
                    Spacer()
                }
                
            //MARK: - Category Name Edit Button
                
                HStack {
                    
                    Spacer()
                    
                    Text("Edit")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(.all, 4)
                        .padding(.horizontal, 2)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.trailing, screen.size.width * 0.07)
                        .onTapGesture {
                            print("edit button tapped")
                            self.showingNameEditor.toggle()
                        }
                        
                }
                .padding(.bottom, 4)
                
            //MARK: - Activity Type - (fitness, chores, learning, work)
                HStack {
                    ForEach(Array(zip(categories, categories.indices)), id: \.0) { category, index in
                        //Current Selected Activity Category
                        if activityToSave.category == category {
                        
                            ActivityTypeIcon(activityIconName: category, activityName: categoryNames[index], isSelected: true, font: 30, iconSizeScreenDividedBy: 5)
                            .onTapGesture(count: 1, perform: {
                                activityToSave.category = category
                            })
                        //Other 3 categories
                        } else {
                            ActivityTypeIcon(activityIconName: category, activityName: categoryNames[index], isSelected: false, font: 30, iconSizeScreenDividedBy: 5)
                                .onTapGesture(count: 1, perform: {
                                    activityToSave.category = category
                                    self.activityName = "Select Activity..."
                                    self.activityToSave.activityName = "Select Activity..."
                                })
                        }
                    }
                }
                .frame(width: screen.width, height: screen.width / 4, alignment: .center)
                .padding(.bottom, 16)
                
            //MARK: - Activity Name - IE: run, laundry, learn french, Work
            //Create text field with a auto complete from list (if item is not on list pop up to assign point value per hour
                
                HStack(spacing: 4) {
                    
                    Image(systemName: "list.bullet")
                        .padding(.leading, 8)
                        .font(.system(size: 24))
                        
                    
                    ZStack(alignment: .leading) {
                        
                        Text(self.activityName)
                            .frame(width: screen.width - 50, height: 40, alignment: .leading)
                            .padding(.leading, 4)
                            .padding(.horizontal, 6)
                            .background(Color(.black))
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .foregroundColor(Color("\(activityToSave.category)Color"))
                            .font(.system(size: 26))
                            .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                                self.showActivitySelector = true
                            })
                            //MARK: - ActivitySelectorView
                            .sheet(isPresented: $showActivitySelector, onDismiss: {
                                self.showActivitySelector = false
                                self.activityName = self.activityToSave.activityName
                                print(activityToSave.activityName)
                                
                            })
                            {
                                ActivitySelectorView(filter: activityToSave.category, showActivitySelector: $showActivitySelector, allActivities: activities, categoryNames: categoryNames)
                                    .environmentObject(activityToSave)
//                                            .frame(width: screen.width, height: screen.height)
//                                            .offset(x: showActivitySelector ? 0 : screen.width)
//                                            .offset(y: screen.minY)
//                                            .offset(x: viewState.width)
//                                            .animation(.easeInOut)
                            }
                    }
                }
                
            //MARK: - Activity Date - November 10
                VStack(alignment: .leading) {
                    
                    Text("Time Started: ")
                        .font(.system(size: 20, weight: .semibold))
                        .padding(.top, 8)
                        .padding(.leading, 8)
                    
                    VStack {
                    
                        HStack {
                            
                            //calendar image
                            Image(systemName: "calendar")
                                .padding(.leading, 8)
                                .font(.system(size: 24))
                            
                            
                            DatePicker("", selection: $selectedDate)
                                .datePickerStyle(CompactDatePickerStyle())
                                .frame(width: screen.width / 2, height: 50, alignment: .leading)
//                                .colorMultiply(.black)
                                
                            Spacer()
                        
                        }
                        .padding(.vertical, 8)
                    }
                
            
                }
                
            
            //MARK: - Activity Time - 45 minutes
                VStack(alignment: .leading, spacing: 0) {

                    Text("Duration: ")
                        .font(.system(size: 20, weight: .semibold))
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
                        .frame(width: screen.width - 16, height: screen.height / 7, alignment: .topLeading)
                        .background(Color.black)
                        .foregroundColor(.white)
                    
                    
                }
            //MARK: - Confirm Activity - add to data set
             
                ZStack {
                    
                    Color("\(activityToSave.category)Color")
                    
                    Text("Save Activity")
                        .foregroundColor(.black)
                        .font(.system(size: 18, weight: .semibold))
                    
                }
                .frame(width: screen.width - 16, height: 60, alignment: .center)
                .padding(.vertical, 0)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .padding(.top, 16)
                .padding(.bottom, 8)
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
                        activityToSave.category = "category1"
                        deleteActivity()
                        
                        //dismiss screen
                        self.showAddActivity = false
                    //if missing info show alert
                    } else {
                        self.showingAlert = true
                    }
                }.alert(isPresented: $showingAlert) {
                    Alert(title: Text("Form Not Completed"), message: Text("Please ensure you have selected an Activity and Duration, Thank you!"), dismissButton: .cancel(Text("Okay")))
                }
                
            //MARK: - Save and Add to Favourites OR DELETE BUTTON
                ZStack {
                    isEditScreen ? Color.red : Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1))
                    Text(isEditScreen ? "Delete Activity" : "Save Activity & Add to Favourites")
                        .foregroundColor(.black)
                        .font(.system(size: 18, weight: .semibold))
                }
                .frame(width: screen.width - 16, height: 60, alignment: .center)
                .padding(.vertical, 0)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .onTapGesture {
                    if isEditScreen {
                    
                        deleteActivity()
                        resetActivity(activityToSave)
                        activityToSave.category = "category1"
                        self.showAddActivity = false

                    } else {
                        //If activity and duration has been selected save and dismiss screen
                        if activityToSave.minutes + activityToSave.hours != 0 && activityToSave.activityName != "Select Activity..." {
                            //save activity
                            saveActivity(activity: activityToSave, date: selectedDate, favourite: true)
                            //reset activity
                            resetActivity(activityToSave)
                            activityToSave.category = "category1"
                            //dismiss screen
                            self.showAddActivity = false
                        //if missing info show alert
                        } else {
                            self.showingAlert = true
                        }
                    }
               
                }.alert(isPresented: $showingAlert) {
                    Alert(title: Text("Form Not Completed"), message: Text("Please ensure you have selected an Activity and Duration, Thank you!"), dismissButton: .cancel(Text("Okay")))
                }
                
            //Spacer at bottom to push button up
               Spacer()
                
            }
            
            //*******************************************
            //End of VStack
            
            
            
                    
            
            CategoryNameEditAlert(isShowing: $showingNameEditor, categoryNames: [$category1Name, $category2Name, $category3Name, $category4Name])
                .offset(x: 0, y: self.showingNameEditor ? -100 : screen.height)
                .animation(.easeInOut)
            
        }
//        .ignoresSafeArea(.keyboard)
    }
    
    
    //MARK: - Delete Activity
    private func deleteActivity() {
        
        self.viewContext.delete(self.itemToDelete)
                    do {
                        try self.viewContext.save()
                    }catch{
                        print(error)
                    }
            
    }
    
    
    
    
    //MARK: - Reset Activity Function
    private func resetActivity(_ : ActivityToSave) {
        activityToSave.activityName = "Select Activity"
        activityToSave.category = "category1"
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
