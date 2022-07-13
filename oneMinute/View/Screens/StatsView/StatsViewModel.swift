//
//  StatsViewModel.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-09-01.
//

import SwiftUI
import Foundation


final class StatsViewModel: ObservableObject {
    
    func getDatesForTimeFrame(timeFrame: TimeFrame, date: Date, activities: [AddedActivity]) -> [Date] {
        
        if timeFrame == .week {
            return Date.dates(from: date.startOfWeek(), to: date.endOfWeek)
        } else if timeFrame == .month {
            return Date.dates(from: date.startOfMonth, to: date.endOfMonth)
        } else if timeFrame == .year {
            return Date.dates(from: date.startOfYear, to: date.endOfYear)
        } else {
            let sortedActivities = activities.sorted(by: { $0.timestamp ?? Date() < $1.timestamp ?? Date() })
            return Date.dates(from: sortedActivities.first?.timestamp ?? Date(), to: sortedActivities.last?.timestamp ?? Date())
        }
    }
    
    func getActivitiesForThis(timeFrame: TimeFrame, activeIndex: Int, data: FetchedResults<AddedActivity>, date: Date) -> [AddedActivity] {
        return data.filter({
            
            if activeIndex == -1 {
                if timeFrame == TimeFrame.week {
                    return $0.timestamp ?? Date() > date.startOfWeek() && $0.timestamp ?? Date() < date.endOfWeek
                } else if timeFrame == TimeFrame.month {
                    return $0.timestamp ?? Date() > date.startOfMonth && $0.timestamp ?? Date() < date.endOfMonth
                } else if timeFrame == TimeFrame.year {
                    return $0.timestamp?.isInThisYear() ?? true
                } else {
                    return true
                }
            } else {
                
                if timeFrame == TimeFrame.week {
                    return $0.timestamp ?? Date() > date.startOfWeek() && $0.timestamp ?? Date() < date.endOfWeek && $0.category == categories[activeIndex]
                } else if timeFrame == TimeFrame.month {
                    return $0.timestamp ?? Date() > date.startOfMonth && $0.timestamp ?? Date() < date.endOfMonth  && $0.category == categories[activeIndex]
                } else if timeFrame == TimeFrame.year {
                    return $0.timestamp?.isInThisYear() ?? true && $0.category == categories[activeIndex]
                } else {
                    return $0.category == categories[activeIndex]
                }
            }
        })
    }
    
    
    func getDataForLineChart(timeframe: TimeFrame, activeIndex: Int, data: FetchedResults<AddedActivity>, date: Date) -> [Double] {
        
        let activities = getActivitiesForThis(timeFrame: timeframe, activeIndex: activeIndex, data: data, date: date)
        var totalsToReturn: [Double] = []
        
        if timeframe == TimeFrame.week {
            let daysOfWeek = dates(from: date.startOfWeek(), to: date.endOfWeek)
            
            for day in daysOfWeek {
                
                let daysActivities = activities.filter({ $0.timestamp?.startOfDay.advanced(by: 1) ?? Date() > day.startOfDay && $0.timestamp ?? Date() < day.endOfDay})
                
                totalsToReturn.append(Double(daysActivities.reduce(0) { $0 + $1.duration}))
            }
        } else if timeframe == TimeFrame.month {
            let daysOfMonth = dates(from: date.startOfMonth, to: date.endOfMonth)
            
            for day in daysOfMonth {
                let daysActivities = activities.filter({ $0.timestamp?.startOfDay.advanced(by: 1) ?? Date() > day.startOfDay && $0.timestamp ?? Date() < day.endOfDay})
                totalsToReturn.append(Double(daysActivities.reduce(0) { $0 + $1.duration}))
            }
        } else if timeframe == TimeFrame.year {
            
            let daysOfMonth = dates(from: date.startOfYear, to: date.endOfYear)
            
            for day in daysOfMonth {
                let daysActivities = activities.filter({ $0.timestamp?.startOfDay.advanced(by: 1) ?? Date() > day.startOfDay && $0.timestamp ?? Date() < day.endOfDay})
                totalsToReturn.append(Double(daysActivities.reduce(0) { $0 + $1.duration}))
            }
        
        } else {
            
            let oldestActivity = activities.max(by: { $0.timestamp?.startOfDay.advanced(by: 1) ?? Date() > $1.timestamp ?? Date() })
            
            let monthsOfYear = dates(from: oldestActivity?.timestamp ?? Date(), to: date.endOfMonth) // get oldest activities and do months from there until end of current month
            
            for month in monthsOfYear {
                print(month)
                let monthActivities = activities.filter({ $0.timestamp?.startOfDay.advanced(by: 1) ?? Date() > month.startOfMonth && $0.timestamp ?? Date() < month.endOfMonth})
                
                totalsToReturn.append(Double(monthActivities.reduce(0) { $0 + $1.duration}))
            }
        }
        return totalsToReturn
    }
    
    
    
    //Get totals for each category and put in Array
    func eachCategoryTotalDuration(timeFrame: TimeFrame, results: FetchedResults<AddedActivity>, date: Date) -> [Double] {
    
        var totals = [Double]()
        
        for category in categories {
            if timeFrame == TimeFrame.week {
                totals.append(Double(results.filter({$0.category == category && $0.timestamp ?? Date() > date.startOfWeek() && $0.timestamp ?? Date() < date.startOfWeek().addingTimeInterval(7*24*60*60)}).reduce(0) { $0 + $1.duration }))
            } else if timeFrame == TimeFrame.month {
                
                totals.append(Double(results.filter({$0.category == category && $0.timestamp ?? Date() > date.startOfMonth && $0.timestamp ?? Date() < date.endOfMonth }).reduce(0) { $0 + $1.duration }))
                
            } else if timeFrame == TimeFrame.year {
                totals.append(Double(results.filter({$0.category == category && $0.timestamp?.isInThisYear() ?? true }).reduce(0) { $0 + $1.duration }))
            } else {
                totals.append(Double(results.filter({$0.category == category}).reduce(0) { $0 + $1.duration }))
            }
        }
        
        return totals
        

        
    }
    
    
    //Cycle through all actvitiesAdded and get which ones are done the most based on timeFrame provided
    func mostActivityLoggedDuring(timeFrame: TimeFrame, results: FetchedResults<AddedActivity>, activityNames: FetchRequest<Activity>, activeIndex: Int, date: Date) -> [((String, Float), String)] {
        
        if timeFrame == TimeFrame.week {
            
            var topActivtiesArray = [((String, Float), String)]()
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
                if activityTotalAmount > topActivtiesArray.min(by: { $0.0.1 < $1.0.1 })?.0.1 ?? 0 || topActivtiesArray.count < 5 && activityTotalAmount != 0 {
                    
                    if topActivtiesArray.count < 5 {
                        topActivtiesArray.append(((activity.name, activityTotalAmount), activity.category))
                    } else {
                        topActivtiesArray.sort(by: { $0.0.1 > $1.0.1 })
                        topActivtiesArray.removeLast()
                        topActivtiesArray.append(((activity.name, activityTotalAmount), activity.category))
                    }

                }
            }
            return topActivtiesArray.sorted(by: {$0.0.1 > $1.0.1})
            
        //Activity with Most this Month
        } else if timeFrame == TimeFrame.month {
            
            var topActivtiesArray = [((String, Float), String)]()
            var activityTotalAmount: Float = 0
            
                //Cycle through all activity types
                for activity in activityNames.wrappedValue {

                    //Get the total duration for each that activity type
                    if activeIndex == -1 {
                        activityTotalAmount = results.filter({$0.timestamp ?? Date() > date.startOfMonth && $0.timestamp ?? Date() < date.endOfMonth && $0.name == activity.name }).reduce(0) { $0 + $1.duration }
                    } else {
                        activityTotalAmount = results.filter({$0.timestamp ?? Date() > date.startOfMonth && $0.timestamp ?? Date() < date.endOfMonth && $0.name == activity.name && $0.category == categories[activeIndex] }).reduce(0) { $0 + $1.duration }
                    }
                    
          
                    
                    if activityTotalAmount > topActivtiesArray.min(by: { $0.0.1 < $1.0.1 })?.0.1 ?? 0 || topActivtiesArray.count < 5 && activityTotalAmount != 0 {
                        
                        if topActivtiesArray.count < 5 {
                            topActivtiesArray.append(((activity.name, activityTotalAmount), activity.category))
                        } else {
                                topActivtiesArray.sort(by: { $0.0.1 > $1.0.1 })
                            topActivtiesArray.removeLast()
                            topActivtiesArray.append(((activity.name, activityTotalAmount), activity.category))
                        }
   
                    }
                }
            return topActivtiesArray.sorted(by: {$0.0.1 > $1.0.1})
        //Activity  with most ALL TIME
        } else if timeFrame == TimeFrame.year {
            
            var topActivtiesArray = [((String, Float), String)]()
            var activityTotalAmount: Float = 0
            
            //Cycle through all activity types
            for activity in activityNames.wrappedValue {

                //Get the total duration for each that activity type
                if activeIndex == -1 {
                    activityTotalAmount = results.filter({$0.name == activity.name && $0.timestamp?.isInThisYear() ?? true}).reduce(0) { $0 + $1.duration }
                } else {
                    activityTotalAmount = results.filter({$0.name == activity.name && $0.category == categories[activeIndex] && $0.timestamp?.isInThisYear() ?? true }).reduce(0) { $0 + $1.duration }
                }
                
                
                if activityTotalAmount > topActivtiesArray.min(by: { $0.0.1 < $1.0.1 })?.0.1 ?? 0 || topActivtiesArray.count < 5 && activityTotalAmount != 0 {
                    
                    if topActivtiesArray.count < 5 {
                        topActivtiesArray.append(((activity.name, activityTotalAmount), activity.category))
                    } else {
                        topActivtiesArray.sort(by: { $0.0.1 > $1.0.1 })
                        topActivtiesArray.removeLast()
                        topActivtiesArray.append(((activity.name, activityTotalAmount), activity.category))
                    }

                }
            }
            return topActivtiesArray.sorted(by: {$0.0.1 > $1.0.1})
            
        } else if timeFrame == TimeFrame.allTime {
            
            var topActivtiesArray = [((String, Float), String)]()
            var activityTotalAmount: Float = 0
            
            //Cycle through all activity types
            for activity in activityNames.wrappedValue {

                //Get the total duration for each that activity type
                if activeIndex == -1 {
                    activityTotalAmount = results.filter({$0.name == activity.name }).reduce(0) { $0 + $1.duration }
                } else {
                    activityTotalAmount = results.filter({$0.name == activity.name && $0.category == categories[activeIndex] }).reduce(0) { $0 + $1.duration }
                }
                
                
                if activityTotalAmount > topActivtiesArray.min(by: { $0.0.1 < $1.0.1 })?.0.1 ?? 0 || topActivtiesArray.count < 5 && activityTotalAmount != 0 {
                    
                    if topActivtiesArray.count < 5 {
                        topActivtiesArray.append(((activity.name, activityTotalAmount), activity.category))
                    } else {
                        topActivtiesArray.sort(by: { $0.0.1 > $1.0.1 })
                        topActivtiesArray.removeLast()
                        topActivtiesArray.append(((activity.name, activityTotalAmount), activity.category))
                    }

                }
            }
            return topActivtiesArray.sorted(by: {$0.0.1 > $1.0.1})
            
        }
        return [(("Unknown", Float(0)), "")]
    }
}
