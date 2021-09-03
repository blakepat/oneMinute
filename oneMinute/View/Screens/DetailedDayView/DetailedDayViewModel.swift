//
//  DetailedDayViewModel.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-08-31.
//

import SwiftUI

final class DetailedDayViewModel: ObservableObject {
    
    
    func getCategoryTotalForDate(_ date: Date, category: String, allActivities: [AddedActivity]) -> Float {
        
        allActivities.filter({ Calendar.current.isDate($0.timestamp ?? Date(), inSameDayAs: date) && $0.category == category}).reduce(0) {$0 + $1.duration}
        
    }
 
    func getCategoryActivitiesForDate(_ date: Date, allActivities: [AddedActivity], index: Int) -> [AddedActivity] {
        allActivities.filter { Calendar.current.isDate($0.timestamp ?? Date(), inSameDayAs: date) && $0.category == categories[index] }
    }
    
}
