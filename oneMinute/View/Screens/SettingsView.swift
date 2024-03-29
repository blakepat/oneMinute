//
//  SettingsView.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-07-28.
//

import SwiftUI
import CoreData

struct SettingsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: AddedActivity.entity(), sortDescriptors: [])
    var allSavedActivities:FetchedResults<AddedActivity>
    @Environment(\.presentationMode)  var presentationMode
    
    @Binding var isHours: Bool
    @Binding var startWeekOnMonday: Bool
    @State private var showDeleteAllAlert = false
    let impactMed = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {

        NavigationView {
            ZStack {
                //Background
                Color.minutesBackgroundBlack
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
//                    HStack {
//                        Text("Settings")
//                            .font(.largeTitle)
//                            .fontWeight(.semibold)
//                            .foregroundColor(Color("category0Color"))
//
//
//                        Spacer()
//                    }
//                    .padding(.horizontal, 16)
                    
                    //Minutes or Hours selection
                    Text("\(isHours ? "Change Units to Minutes" : "Change Units to Hours")")
                        .foregroundColor(.white)
                        .frame(width: 280, height: 70, alignment: .center)
                        .background(Color.minutesBackgroundCharcoal)
                        .cornerRadius(10)
                        .onTapGesture {
                            impactMed.impactOccurred()
                            isHours.toggle()
                            UserDefaults.standard.setValue("\(isHours)", forKey: "isHours")
                        }
                    
                    //Start week on sunday or monday
                    Text("\(startWeekOnMonday ? "Start Week On Sunday" : "Start Week On Monday")")
                        .foregroundColor(.white)
                        .frame(width: 280, height: 70, alignment: .center)
                        .background(Color.minutesBackgroundCharcoal)
                        .cornerRadius(10)
                        .onTapGesture {
                            impactMed.impactOccurred()
                            startWeekOnMonday.toggle()
                            UserDefaults.standard.setValue("\(startWeekOnMonday)", forKey: "startWeekOnMonday")
                        }
                    
                    
                    
                    //rewatch onboarding
                    Text("See Intro Screen on Next Open")
                        .foregroundColor(.white)
                        .frame(width: 280, height: 70, alignment: .center)
                        .background(Color.minutesBackgroundCharcoal)
                        .cornerRadius(10)
                        .onTapGesture {
                            impactMed.impactOccurred()
                            UserDefaults.standard.set(false, forKey: "hasSeenOnboardView")
                            presentationMode.wrappedValue.dismiss()
                        }
                    
                    Spacer()
                    
                    //Delete all activities
                    Text("Delete all saved activities")
                        .foregroundColor(.red)
                        .frame(width: 280, height: 70, alignment: .center)
                        .background(Color.minutesBackgroundCharcoal)
                        .cornerRadius(10)
                        .alert(isPresented: self.$showDeleteAllAlert, content: {
                            Alert(title: Text("Delete All"),
                                  message: Text("Are you sure you want to delete all saved activities"),
                                  primaryButton: .destructive(Text("Delete"), action: {
                                    deleteAllEntities()
                                  }),
                                  secondaryButton: .cancel())
                        })
                        .onTapGesture {
                            self.showDeleteAllAlert.toggle()
                        }
                    
                }
                .padding(.bottom, 24)
                .padding(.top)
                .cornerRadius(10)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Dismiss")
                }
            }
        }
    }
    
    //MARK: - Delete Activity
    func deleteAllEntities() {
        delete(entityName: "AddedActivity")
        do {
            try viewContext.save()
            viewContext.reset()
        } catch let error as NSError {
            debugPrint(error)
        }
    }

    func delete(entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try PersistenceController.shared.container.viewContext.execute(deleteRequest)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
}
//
//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView(isHours: $false)
//    }
//}
