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
    @EnvironmentObject var activityToSave: ActivityToSave
    @State var showingAlert = false
    @State private var alertInput = ""
    var allActivities: FetchedResults<Activity>
    var categoryNames: [String]
    @State private var searchText = ""
    var fetchRequest: FetchRequest<Activity>
 
    var body: some View {
    
        ZStack {
            //backgroundColor
            Color("\(activityToSave.category)Color")

            VStack {
                
                //Title Bar
                TitleBar(showingAlert: $showingAlert, showActivitySelector: $showActivitySelector, categoryName: categoryNames[(Int(String(activityToSave.category.last!)) ?? 1) - 1])
                
                //List
                List {
                    
                    SearchBar(text: $searchText)
                    
                    ForEach(fetchRequest.wrappedValue.filter({ searchText.isEmpty ? true : $0.name.contains(searchText) }), id: \.self) { activity in
                        
                        HStack {
                        
                            Text(activity.name.capitalized)
                                
                            Spacer()
                        }
                        .frame(height: 30)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.showActivitySelector = false
                            self.activityToSave.activityName = activity.name.capitalized
                        }
                            
                    }
                    .onDelete(perform: deleteActivity)
                }
                
                .resignKeyboardOnDragGesture()
            }
            
            
            TextFieldAlert(isShowing: $showingAlert, text: $alertInput, category: activityToSave.category)
                .offset(x: 60, y: self.showingAlert ? 0 : screen.height)
                .animation(.easeInOut)
        }
    }
    
    func deleteActivity(at offsets: IndexSet) {
        for index in offsets {
            let activity = fetchRequest.wrappedValue[index]
            viewContext.delete(activity)
        }
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
        
    init(filter: String, showActivitySelector: Binding<Bool>, allActivities: FetchedResults<Activity>, categoryNames: [String]) {
        
        fetchRequest = FetchRequest<Activity>(entity: Activity.entity(), sortDescriptors: [], predicate: NSPredicate(format: "category CONTAINS %@", filter))
        
        self._showActivitySelector = showActivitySelector
//        self.activityToSave = activityToSave
        self.allActivities = allActivities
        self.categoryNames = categoryNames
        

    }
}
    

    


//MARK: - Title Bar
struct TitleBar: View {
    
    @Binding var showingAlert: Bool
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
            }
        }
    
}


extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}


extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}



//LIST

//                FilteredList(filter: activityToSave.category, passedActivityBinding: $activityToSave.activityName, showActivitySelector: $showActivitySelector)
//                    .colorMultiply(Color("\(activityToSave.category)Color"))
