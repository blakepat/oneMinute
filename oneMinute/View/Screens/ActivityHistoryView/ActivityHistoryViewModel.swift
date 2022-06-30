//
//  ActivityHistoryViewModel.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-08-31.
//

import SwiftUI
import CoreData


final class ActivityHistoryViewModel: ObservableObject {
    
    func getActivitiesForTimeFrameAndFilter(timeFrame: TimeFrame,
                                      data: FetchedResults<AddedActivity>,
                                      activityToShow: ActivityToSave,
                                      activityFilter: ActivityFilter) -> [AddedActivity] {
        if activityFilter == .all {
            return getAllActivitiesFor(timeFrame: timeFrame, data: data)
        } else if activityFilter == .category {
            return filterActivitiesForCategory(category: activityToShow.category, data: data, timeFrame: timeFrame)
        } else {
            return filterActivitiesForActivityName(name: activityToShow.activityName, data: data, timeFrame: timeFrame)
        }
    }
    
    func getAllActivitiesFor(timeFrame: TimeFrame, data: FetchedResults<AddedActivity>) -> [AddedActivity] {
        if timeFrame == TimeFrame.allTime {
            return data.filter({_ in true})
        } else if timeFrame == TimeFrame.month {
            return data.filter({ $0.timestamp ?? Date() > Date().startOfMonth && $0.timestamp ?? Date() < Date().endOfMonth  })
        } else {
            return data.filter(({ $0.timestamp ?? Date() > Date().startOfWeek() && $0.timestamp ?? Date() < Date().endOfWeek  }))
        }
    }
    
    
    func filterActivitiesForCategory(category: String, data: FetchedResults<AddedActivity>, timeFrame: TimeFrame) -> [AddedActivity] {
        
        if timeFrame == TimeFrame.allTime {
            return data.filter({ $0.category == category })
        } else if timeFrame == TimeFrame.month {
            return data.filter({ $0.category == category && $0.timestamp ?? Date() > Date().startOfMonth && $0.timestamp ?? Date() < Date().endOfMonth  })
        } else {
            return data.filter(({ $0.category == category && $0.timestamp ?? Date() > Date().startOfWeek() && $0.timestamp ?? Date() < Date().endOfWeek  }))
        }
        
    }
    
    
        func filterActivitiesForActivityName(name: String, data: FetchedResults<AddedActivity>, timeFrame: TimeFrame) -> [AddedActivity] {
            
            if timeFrame == TimeFrame.allTime {
                return data.filter({ $0.name == name })
            } else if timeFrame == TimeFrame.month {
                return data.filter({ $0.name == name && $0.timestamp ?? Date() > Date().startOfMonth && $0.timestamp ?? Date() < Date().endOfMonth  })
            } else {
                return data.filter(({ $0.name == name && $0.timestamp ?? Date() > Date().startOfWeek() && $0.timestamp ?? Date() < Date().endOfWeek  }))
            }
    }
}
