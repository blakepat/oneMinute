//
//  StatsViewModel.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-09-01.
//

import SwiftUI


final class StatsViewModel: ObservableObject {
    
    func getActivitiesForThis(timeFrame: TimeFrame, activeIndex: Int, data: FetchedResults<AddedActivity>, date: Date) -> [AddedActivity] {
        return data.filter({
            
            if activeIndex == -1 {
                if timeFrame == TimeFrame.week {
                    return $0.timestamp ?? Date() > date.startOfWeek() && $0.timestamp ?? Date() < date.endOfWeek
                } else if timeFrame == TimeFrame.month {
                    return $0.timestamp ?? Date() > date.startOfMonth && $0.timestamp ?? Date() < date.endOfMonth
                } else {
                    return true
                }
            } else {
                
                if timeFrame == TimeFrame.week {
                    return $0.timestamp ?? Date() > date.startOfWeek() && $0.timestamp ?? Date() < date.endOfWeek && $0.category == categories[activeIndex]
                } else if timeFrame == TimeFrame.month {
                    return $0.timestamp ?? Date() > date.startOfMonth && $0.timestamp ?? Date() < date.endOfMonth  && $0.category == categories[activeIndex]
                } else {
                    return  $0.category == categories[activeIndex]
                }
            }
        })
    }
    
    
    
    //Get totals for each category and put in Array
    func eachCategoryTotalDuration(timeFrame: TimeFrame, results: FetchedResults<AddedActivity>, date: Date) -> [Double] {
    
        var totals = [Double]()
        
        for category in categories {
            if timeFrame == TimeFrame.week {
                totals.append(Double(results.filter({$0.category == category && $0.timestamp ?? Date() > date.startOfWeek() && $0.timestamp ?? Date() < date.startOfWeek().addingTimeInterval(7*24*60*60)}).reduce(0) { $0 + $1.duration }))
            } else if timeFrame == TimeFrame.month {
                
                totals.append(Double(results.filter({$0.category == category && $0.timestamp ?? Date() > date.startOfMonth && $0.timestamp ?? Date() < date.endOfMonth }).reduce(0) { $0 + $1.duration }))
                
            } else if timeFrame == TimeFrame.allTime {
                totals.append(Double(results.filter({$0.category == category}).reduce(0) { $0 + $1.duration }))
            } else {
                totals.append(Double(results.filter({$0.category == category}).reduce(0) { $0 + $1.duration }))
            }
        }
        
        return totals
        

        
    }
    
    
    //Cycle through all actvitiesAdded and get which ones are done the most based on timeFrame provided
    func mostActivityLoggedDuring(timeFrame: TimeFrame, results: FetchedResults<AddedActivity>, activityNames: FetchRequest<Activity>, activeIndex: Int, date: Date) -> [(String, Float)] {
        
        if timeFrame == TimeFrame.week {
            
            var topActivtiesArray = [(String, Float)]()
            var activityTotalAmount: Float = 0
            
            //Cycle through all activity types
            for activity in activityNames.wrappedValue {

                //Get the total duration for each that activity type
                if activeIndex == -1 {
                    activityTotalAmount = results.filter({$0.timestamp ?? Date() > date.startOfWeek() && $0.timestamp ?? Date() < date.endOfWeek && $0.name == activity.name }).reduce(0) { $0 + $1.duration}
                } else {
                    activityTotalAmount = results.filter({$0.timestamp ?? Date() > date.startOfWeek() && $0.timestamp ?? Date() < date.endOfWeek && $0.name == activity.name && $0.category == categories[activeIndex] }).reduce(0) { $0 + $1.duration}
                }
                

                
                //CHANGE IT TO CHECK IF IT IS LOWER THAN 5th item in array
                if activityTotalAmount > topActivtiesArray.min(by: { $0.1 < $1.1 })?.1 ?? 0 || topActivtiesArray.count < 5 && activityTotalAmount != 0 {
                    
                    if topActivtiesArray.count < 5 {
                        topActivtiesArray.append((activity.name, activityTotalAmount))
                    } else {
                        topActivtiesArray.sort(by: { $0.1 > $1.1 })
                        topActivtiesArray.removeLast()
                        topActivtiesArray.append((activity.name, activityTotalAmount))
                    }

                }
            }
            return topActivtiesArray.sorted(by: {$0.1 > $1.1})
        //Activity with Most this Month
        } else if timeFrame == TimeFrame.month {
            
            var topActivtiesArray = [(String, Float)]()
            var activityTotalAmount: Float = 0
            
                //Cycle through all activity types
                for activity in activityNames.wrappedValue {

                    //Get the total duration for each that activity type
                    if activeIndex == -1 {
                        activityTotalAmount = results.filter({$0.timestamp ?? Date() > date.startOfMonth && $0.timestamp ?? Date() < date.endOfMonth && $0.name == activity.name }).reduce(0) { $0 + $1.duration }
                    } else {
                        activityTotalAmount = results.filter({$0.timestamp ?? Date() > date.startOfMonth && $0.timestamp ?? Date() < date.endOfMonth && $0.name == activity.name && $0.category == categories[activeIndex] }).reduce(0) { $0 + $1.duration }
                    }
                    
          
                    
                    if activityTotalAmount > topActivtiesArray.min(by: { $0.1 < $1.1 })?.1 ?? 0 || topActivtiesArray.count < 5 && activityTotalAmount != 0 {
                        
                        if topActivtiesArray.count < 5 {
                            topActivtiesArray.append((activity.name, activityTotalAmount))
                        } else {
                            topActivtiesArray.sort(by: { $0.1 > $1.1 })
                            topActivtiesArray.removeLast()
                            topActivtiesArray.append((activity.name, activityTotalAmount))
                        }
   
                    }
                }
            return topActivtiesArray.sorted(by: {$0.1 > $1.1})
        //Activity  with most ALL TIME
        } else if timeFrame == TimeFrame.allTime {
            
            var topActivtiesArray = [(String, Float)]()
            var activityTotalAmount: Float = 0
            
            //Cycle through all activity types
            for activity in activityNames.wrappedValue {

                //Get the total duration for each that activity type
                if activeIndex == -1 {
                    activityTotalAmount = results.filter({$0.name == activity.name }).reduce(0) { $0 + $1.duration }
                } else {
                    activityTotalAmount = results.filter({$0.name == activity.name && $0.category == categories[activeIndex] }).reduce(0) { $0 + $1.duration }
                }
                
                
                if activityTotalAmount > topActivtiesArray.min(by: { $0.1 < $1.1 })?.1 ?? 0 || topActivtiesArray.count < 5 && activityTotalAmount != 0 {
                    
                    if topActivtiesArray.count < 5 {
                        topActivtiesArray.append((activity.name, activityTotalAmount))
                    } else {
                        topActivtiesArray.sort(by: { $0.1 > $1.1 })
                        topActivtiesArray.removeLast()
                        topActivtiesArray.append((activity.name, activityTotalAmount))
                    }

                }
            }
            return topActivtiesArray.sorted(by: {$0.1 > $1.1})
            
        } else {
            return [("Unknown", Float(0.0))]
        }
        
    }
    
    
}
