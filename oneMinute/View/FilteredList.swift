//
//  FilteredList.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2020-11-05.
//

import SwiftUI
import CoreData

struct FilteredList: View {
    
    @State private var searchText = ""
    var fetchRequest: FetchRequest<ActivityCategory>
    
    var body: some View {
        ForEach(fetchRequest.wrappedValue, id: \.self) { category in
            List {
                SearchBar(text: $searchText)
                                    
                ForEach((category.activity?.allObjects as? [Activity] ?? []).filter({ searchText.isEmpty ? true : $0.name.contains(searchText)}), id: \.self) { activity in
                    Text(activity.name.capitalized)
                }
            }
        }
    }
    
    init(filter: String) {
        fetchRequest = FetchRequest<ActivityCategory>(entity: ActivityCategory.entity(), sortDescriptors: [], predicate: NSPredicate(format: "categoryName CONTAINS %@", filter))
    }
}

