//
//  FilteredList.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2020-11-05.
//

import SwiftUI
import CoreData

struct FilteredList: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var showActivitySelector: Bool
    @Binding var selectedActivity: String
    @State private var searchText = ""
    var fetchRequest: FetchRequest<Activity>
    
    var body: some View {
            
        List {

            ForEach(fetchRequest.wrappedValue, id: \.self) { activity in
                Text(activity.name.capitalized)
                    .onTapGesture {
                        print("TAPPED!")
                        self.showActivitySelector = false
                        self.selectedActivity = activity.name.capitalized
                    }
            }.onDelete(perform: deleteActivity)
            
        
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
        
    
    init(filter: String, passedActivityBinding: Binding<String>, showActivitySelector: Binding<Bool>) {
        fetchRequest = FetchRequest<Activity>(entity: Activity.entity(), sortDescriptors: [], predicate: NSPredicate(format: "category CONTAINS %@", filter))
        
        self._selectedActivity = passedActivityBinding
        self._showActivitySelector = showActivitySelector
    }
}

