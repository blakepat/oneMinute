//
//  ActivitySelectorView.swift
//  oneWeek
//
//  Created by Blake Patenaude on 2020-11-03.
//

import SwiftUI
import CoreData

struct ActivitySelectorView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var showActivitySelector: Bool
    @State var showingAlert = false
    @ObservedObject var itemList = ActivityListData()
    var allCategories: FetchedResults<ActivityCategory>
    var categorySelected: String
    
    
    var body: some View {
    
        ZStack {
            
            //backgroundColor
            Color("fitnessColor")
        
            VStack {
                TitleBar(showActivitySelector: $showActivitySelector, categoryName: categorySelected)
                
                //MARK: - LIST
                FilteredList(filter: categorySelected)
                    .colorMultiply(Color("fitnessColor"))                
            }
        }
    }
    
    
    private func addItem() {
        withAnimation {
            let newItem = Activity(context: viewContext)
            newItem.name = "test name"

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

    private func deleteItems(offsets: IndexSet, item: Activity) {
        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)

            
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
    
    
    
    

//struct ActivitySelectorView_Previews: PreviewProvider {
//    static var previews: some View {
//
//        ActivitySelectorView(showActivitySelector: .constant(true), backgroundColor: .constant("fitness"), itemList: ActivityListData())
//    }
//}



//MARK: - Title Bar
struct TitleBar: View {
    
    @State var showingAlert = false
    @Binding var showActivitySelector: Bool
    var categoryName: String
    
    var body: some View {
        
            HStack {
                //back button
                Image(systemName: "arrow.left")
                    .padding()
                    .font(.system(size: 22))
                    .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                        self.showActivitySelector = false
                    })
                
                Spacer()
                
                Text("\(categoryName.capitalized)")
                    .font(.system(size: 24, weight: .semibold))
                
                Spacer()
                
                //add activity button
                Image(systemName: "plus")
                    .padding()
                    .font(.system(size: 22))
                    .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                        self.showingAlert = true
                    })
                    .alert(isPresented: $showingAlert, content: {
                        
                        return Alert(
                            title: Text("Text Field currently empty"),
                            message: Text("Please write the name of the item you would like to add to \(categoryName.capitalized) List in text field then press add button"),
                            dismissButton: .cancel(Text("Okay")))
                    })
            }
        }
    }

extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}
