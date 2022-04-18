//
//  ContentViewModel.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-08-31.
//

import SwiftUI
import CoreData


final class ContentViewModel: ObservableObject {
    
    
    //MARK: - Category Names
    @Published var category1Name = UserDefaults.standard.string(forKey: "category1Name")!
    @Published var category2Name = UserDefaults.standard.string(forKey: "category2Name")!
    @Published var category3Name = UserDefaults.standard.string(forKey: "category3Name")!
    @Published var category4Name = UserDefaults.standard.string(forKey: "category4Name")!
    
    
    @Published var showingOnboardView = false {
        didSet {
            print("✅ showingOnboardView changed!")
        }
    }
    
    
    //Time Unit
    @Published var isHours = UserDefaults.standard.bool(forKey: "isHours")
    
    var hasSeenOnboardView: Bool {
        return UserDefaults.standard.bool(forKey: "hasSeenOnboardView")
    }
    
    
    func showOnboardView() {
        if !hasSeenOnboardView {
            showingOnboardView = true
            UserDefaults.standard.set(true, forKey: "hasSeenOnboardView")
        }
    }
    
    
    func returnWeekFromNumber(_ num : Int, fetchedResults: FetchedResults<AddedActivity>) -> [AddedActivity] {
        
        let dates = [Date(), Date().addingTimeInterval(-60*60*24*7), Date().addingTimeInterval(-60*60*24*14), Date().addingTimeInterval(-60*60*24*21)]
        
        return fetchedResults.filter({ $0.timestamp ?? Date() > dates[num].startOfWeek() && $0.timestamp ?? Date() < dates[num].endOfWeek})
        
    }
    
    
    func returnThisWeek(selectedDate: Date, activities: FetchedResults<AddedActivity>) -> [AddedActivity] {
        activities.filter({ $0.timestamp ?? Date() > selectedDate.startOfWeek() && $0.timestamp ?? Date() < selectedDate.endOfWeek })
    }
    
}
