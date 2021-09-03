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
    
    @Binding var isHours: Bool
    @State private var showDeleteAllAlert = false
    
    var body: some View {

        ZStack {
            //Background
            Color(#colorLiteral(red: 0.2078431373, green: 0.2156862745, blue: 0.2156862745, alpha: 1))
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                HStack {
                    Text("Settings")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("category0Color"))
                        
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                
                //Minutes or Hours selection
                Text("\(isHours ? "Change Units to Minutes" : "Change Units to Hours")")
                    .foregroundColor(.white)
                    .frame(width: 280, height: 70, alignment: .center)
                    .background(Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1)))
                    .cornerRadius(10)
                    .onTapGesture {
                        isHours.toggle()
                        UserDefaults.standard.setValue("\(isHours)", forKey: "isHours")
                    }
                
                //rewatch onboarding
                Text("Rewatch Onboarding")
                    .foregroundColor(.white)
                    .frame(width: 280, height: 70, alignment: .center)
                    .background(Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1)))
                    .cornerRadius(10)
                
                
                //Delete all activities
                Text("Delete all saved activities")
                    .foregroundColor(.red)
                    .frame(width: 280, height: 70, alignment: .center)
                    .background(Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1)))
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
                
                Spacer()
            }
            
            .background(Color.black)
            .cornerRadius(10)
            .padding(.all)
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