//
//  SupportItems.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-04-06.
//

import Foundation
import SwiftUI


extension Calendar {
    func numberOfDaysBetween(from: Date, to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.day!
    }
}
extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}

extension Calendar {
    func isDayInCurrentWeek(date: Date) -> Bool? {
        let currentComponents = Calendar.current.dateComponents([.weekOfYear], from: Date())
        let dateComponents = Calendar.current.dateComponents([.weekOfYear], from: date)
        guard let currentWeekOfYear = currentComponents.weekOfYear, let dateWeekOfYear = dateComponents.weekOfYear else { return nil }
        return currentWeekOfYear == dateWeekOfYear
    }
}

extension Calendar {
    static let gregorian = Calendar(identifier: .gregorian)
}


extension Date {
    func startOfWeek(using calendar: Calendar = .gregorian) -> Date {
        calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var startOfMonth: Date {

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.year, .month], from: self)

        return  calendar.date(from: components)!
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfMonth)!
    }
    
    var endOfWeek: Date {
        var components = DateComponents()
        components.weekOfYear = 1
        components.second = -1
        return Calendar(identifier: .gregorian).date(byAdding: components, to: startOfWeek())!
        
        
    }
    

//    func isMonday() -> Bool {
//        let calendar = Calendar(identifier: .gregorian)
//        let components = calendar.dateComponents([.weekday], from: self)
//        return components.weekday == 2
//    }
}



extension Date: Strideable {
    // typealias Stride = SignedInteger // doesn't work (probably because declared in extension
    public func advanced(by n: Int) -> Date {
        self.addingTimeInterval(TimeInterval(n))
    }

    public func distance(to other: Date) -> Int {
        return Int(self.distance(to: other))
    }
}

let screen = UIScreen.main.bounds

extension Date {
    func generateDates(startDate :Date?, addbyUnit:Calendar.Component, value : Int) -> [Date]
{
    let calendar = Calendar.current
    var datesArray: [Date] =  [Date] ()

    for i in 0 ... value {
        if let newDate = calendar.date(byAdding: addbyUnit, value: i + 1, to: startDate!) {
            datesArray.append(newDate)
        }
    }

    return datesArray
}
}


extension Date {
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate

        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
}

extension String {
   func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}


enum TimeFrame {
    case week, month, year, allTime
}



//
//func timeFrameFilterer(timeFrame: TimeFrame) -> {} {
//
//    if timeFrame == TimeFrame.week {
//        return "weekly"
//    } else if timeFrame == TimeFrame.month {
//        return "monthly"
//    } else if timeFrame == TimeFrame.year {
//        return "yearly"
//    } else if timeFrame == TimeFrame.total {
//        return "Total"
//    } else {
//        return "unidentified"
//    }
//
//
//}

func timeFrameStringGetter(_ timeFrame: TimeFrame) -> String {
    
    if timeFrame == TimeFrame.week {
        return "weekly"
    } else if timeFrame == TimeFrame.month {
        return "monthly"
    } else if timeFrame == TimeFrame.year {
        return "yearly"
    } else if timeFrame == TimeFrame.allTime {
        return "All-Time"
    } else {
        return "unidentified"
    }
    
}

enum Category {
    case category1, category2, category3, category4, all
}


func categoryStringGetter(_ category: Category) -> String {
    
    if category == Category.category1 {
        return "category1"
    } else if category == Category.category2 {
        return "category2"
    } else if category == Category.category3 {
        return "category3"
    } else if category == Category.category4 {
        return "category4"
    } else if category == Category.all {
        return "all"
    } else {
        return "unidentified"
    }
    
}

func dividBy(lhs: Float, rhs: Float) -> Float {
    if rhs == 0 {
        return 0
    }
    return lhs/rhs
}
