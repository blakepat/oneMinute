//
//  AddActivityView.swift
//  oneWeek
//
//  Created by Blake Patenaude on 2020-10-21.
//

import SwiftUI
import CoreData

struct AddActivityView: View {
    
    @Environment(\.presentationMode)  var presentationMode
    @StateObject private var viewModel = AddActivityViewModel()
    
    //Fetch listed activities
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Activity.entity(), sortDescriptors: [])
    private var activities: FetchedResults<Activity>
    
    //Passed Items
    @Binding var showActivitySelector: Bool
    @Binding var showAddActivity: Bool
    @Binding var selectedDate: Date
    @Binding var itemToDelete: AddedActivity
    @Binding var showingNameEditor: Bool
    @ObservedObject var activityToSave: ActivityToSave
    @State var isEditScreen: Bool
    @State var categorySelected: Bool
    
    //Category Names
    @Binding var category1Name: String
    @Binding var category2Name: String
    @Binding var category3Name: String
    @Binding var category4Name: String
    


    @Binding var activeSheet: ActiveSheet?
    var body: some View {
        
        let categoryNames = [category1Name, category2Name, category3Name, category4Name]
        
        NavigationView {
            ZStack {
            
                //MARK: - Background Color
                Color(#colorLiteral(red: 0.2082437575, green: 0.2156656086, blue: 0.2157248855, alpha: 1))
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    
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
                                        self.categorySelected = true
                                        viewModel.activityName = "Select Activity..."
                                        self.activityToSave.activityName = "Select Activity..."
                                    })
                            }
                        }
                    }
                    .frame(width: screen.width, height: screen.width / 4, alignment: .center)
                    .padding(.bottom, 16)
                    
                //MARK: - Activity Name - IE: run, laundry, learn french, Work
                    HStack(spacing: 4) {

                        Image(systemName: "list.bullet")
                            .padding(.leading, 8)
                            .font(.system(size: 24))


                        ZStack(alignment: .leading) {

                            ActivityNameView(activityToSave: activityToSave)
                                .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                                    if categorySelected { self.showActivitySelector = true }
                                })
                                //MARK: - ActivitySelectorView
                                .sheet(isPresented: $showActivitySelector, onDismiss: {
                                    self.showActivitySelector = false
                                    viewModel.activityName = self.activityToSave.activityName
                                    print(activityToSave.activityName)
                                    
                                })
                                {
                                    ActivitySelectorView(filter: activityToSave.category,
                                                         showActivitySelector: $showActivitySelector,
                                                         activityToSave: activityToSave,
                                                         allActivities: activities,
                                                         categoryNames: categoryNames,
                                                         activityFilter: $viewModel.activityFilter
                                    ).environment(\.managedObjectContext, self.viewContext)
                                }
                        }
                    }
                    
                //MARK: - Activity Date - November 10
                    VStack(alignment: .leading) {
                        
                        Text("Time Started: ")
                            .font(.headline)
                            .padding(.top, 8)
                            .padding(.leading, 8)
                        
                        VStack {
                            HStack {
                                Image(systemName: "calendar")
                                    .padding(.leading, 8)
                                    .font(.system(size: 24))
                                
                                DatePicker("", selection: $selectedDate)
                                    .datePickerStyle(CompactDatePickerStyle())
                                    .frame(width: screen.width / 2, height: 50, alignment: .leading)

                                Spacer()
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    
                
                //MARK: - Activity Time - 45 minutes
                    TimeSelectorView(activityToSave: activityToSave)
                    
                //MARK: - Activity Notes - 5km run, chest workout, rosetta stone, 1 hour overtime
                    VStack(alignment: .leading, spacing: 0) {
                    
                        Text("Notes: ")
                            .font(.headline)
                            .padding(.vertical, 0)
                        
                        TextField("notes...", text: $activityToSave.notes)
                            .frame(width: screen.width - 16, height: screen.size.height > 800 ? screen.height / 7 : 40, alignment: .topLeading)
                            .contentShape(Rectangle())
                            .background(Color.black)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                //MARK: - Confirm Activity - add to data set
                    ZStack {
                        
                        Color.getCategoryColor(activityToSave.category)
                        
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
                        //If activity and duration has been selected save and dismiss screen
                        if activityToSave.minutes + activityToSave.hours != 0 && activityToSave.activityName != "Select Activity..." {
                            //save activity
                            viewModel.saveActivity(activity: activityToSave, date: selectedDate, favourite: false, viewContext: viewContext)
                            //reset activity
                            viewModel.resetActivity(activityToSave)
    //                        activityToSave.category = "category0"
                            viewModel.deleteActivity(itemToDelete: itemToDelete, viewContext: viewContext)
                            
                            //dismiss screen
                            self.activeSheet = nil
                            self.showAddActivity = false
                            
                        //if missing info show alert
                        } else {
                            viewModel.showingAlert = true
                        }
                    }.alert(isPresented: $viewModel.showingAlert) {
                        Alert(title: Text("Form Not Completed"), message: Text("Please ensure you have selected an Activity and Duration, Thank you!"), dismissButton: .cancel(Text("Okay")))
                    }
                    
                //MARK: - Save and Add to Favourites or delete button
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
                            viewModel.deleteActivity(itemToDelete: itemToDelete, viewContext: viewContext)
                            viewModel.resetActivity(activityToSave)
                            self.showAddActivity = false

                        } else {
                            //If activity and duration has been selected save and dismiss screen
                            if activityToSave.minutes + activityToSave.hours != 0 && (activityToSave.activityName != "Select Activity..." || activityToSave.activityName != "Select Category")  {
                                //save activity
                                viewModel.saveActivity(activity: activityToSave, date: selectedDate, favourite: true, viewContext: viewContext)
                                //reset activity
                                viewModel.resetActivity(activityToSave)
                                activityToSave.category = category1
                                //dismiss screen
                                self.showAddActivity = false
                                self.activeSheet = nil
                            //if missing info show alert
                            } else {
                                viewModel.showingAlert = true
                            }
                        }
                   
                    }.alert(isPresented: $viewModel.showingAlert) {
                        Alert(title: Text("Form Not Completed"), message: Text("Please ensure you have selected an Activity and Duration, Thank you!"), dismissButton: .cancel(Text("Okay")))
                    }
                    
                   Spacer()
                    
                }

                //Mark: - Hidden Views
                BlurView(style: .systemUltraThinMaterialDark)
                    .offset(y: self.showingNameEditor ? 0 : screen.height)
                    .edgesIgnoringSafeArea(.all)
                
                CategoryNameEditAlert(isShowing: $showingNameEditor, categoryNames: [$category1Name, $category2Name, $category3Name, $category4Name])
                    
                    .offset(x: 0, y: self.showingNameEditor ? -50 : screen.height)
                    .animation(.easeInOut)
            }
            .navigationTitle("Add Activity")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingNameEditor.toggle()
                    } label: {
                        Text("Edit")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Dismiss")
                    }
                }
            }
        }
    }
}


//MARK: - VIEWS for this screen
struct PullDownTab: View {
    var body: some View {
        HStack {
            
            Spacer()
            
            Color(.black)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .frame(width: 50, height: 8, alignment: .center)
                .padding(.top, 20)
                .padding(.bottom, 0)
            
            Spacer()
        }
    }
}

struct EditButton: View {
    
    @Binding var showingNameEditor: Bool
    
    var body: some View {
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
}

struct TimeSelectorView: View {
    
    @ObservedObject var activityToSave: ActivityToSave
    private let hourArray = (0...24).map{"\($0)"}
    private let minutesArray = (0...60).map{"\($0)"}
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Duration: ")
                .font(.headline)
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
                        ForEach(0 ..< self.hourArray.count, id: \.self) { number in
                            Text(self.hourArray[number]).tag(Float(number))
                        }
                    }
                    .frame(width: 100, height: 80, alignment: .center)
                    .clipped()
                    
                    //hour signafier
                    Text("hours")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Spacer()
                    
                    //Minute Selection
                    Picker(selection: $activityToSave.minutes, label: Text("Hours")) {
                        ForEach(0 ..< self.minutesArray.count, id: \.self) { number in
                            Text(self.minutesArray[number]).tag(Float(number))
                        }
                    }
                    .frame(width: 100, height: 80, alignment: .center)
                    .clipped()
                    
                    //minute signafier
                    Text("minutes")
                        .font(.system(size: 16, weight: .semibold))
                    
                    Spacer()
                }
            }
            .frame(height: 80)
        }
    }
}
