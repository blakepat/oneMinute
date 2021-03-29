//
//  AlertView.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2020-11-06.
//

import SwiftUI

struct TextFieldAlert: View {

    @Environment(\.managedObjectContext) private var viewContext
    @Binding var isShowing: Bool
    @Binding var text: String
    var category: String

    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ZStack {
                VStack {
                    Text("Add New Activity")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.black)
                    TextField("New Activity", text: self.$text)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .id(self.isShowing)
                        .foregroundColor(.black)
                        .ignoresSafeArea(.keyboard)
                    Divider()
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.isShowing.toggle()
                                self.text = ""
                            }
                        }) {
                            Text("Dismiss")
                        }
                        .padding()
                        .frame(width: deviceSize.size.width*0.3)
                        
                        Spacer()
                        Divider()
                            .frame(height: deviceSize.size.height*0.05)
                        Spacer()
                        
                        Button {
                            withAnimation {
                                addActivity(name: self.text, category: category)
                                self.isShowing.toggle()
                                self.text = ""
                                
                            }
                        } label: {
                            Text("Add")
                        }
                        .padding()
                        .frame(width: deviceSize.size.width*0.3)

                    }
                }
                .padding()
                .background(Color.white)
                .frame(
                    width: deviceSize.size.width*0.7,
                    height: deviceSize.size.height*0.7
                )
                .shadow(radius: 1)
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }

    //MARK: - Save Item
    private func addActivity(name: String, category: String) {
        withAnimation {
            
            if name.isEmpty { return }
            
            let newActivity = Activity(context: viewContext)
            newActivity.name = name
            newActivity.category = category
            
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
