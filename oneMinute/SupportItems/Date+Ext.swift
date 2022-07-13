//
//  Date+Extensions.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-08-26.
//

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


extension Date {
    func isSameDay(date: Date) -> Bool {
        let diff = Calendar.current.dateComponents([.month], from: self, to: date)
        if diff.day == 0 {
            return true
        } else {
            return false
        }
    }
}


extension Calendar {
    func isDayInCurrentWeek(date: Date) -> Bool? {
        
        
        let currentComponents = getCalendarForCorrectWeekday().dateComponents([.weekOfYear], from: Date())
        let dateComponents = getCalendarForCorrectWeekday().dateComponents([.weekOfYear], from: date)
        guard let currentWeekOfYear = currentComponents.weekOfYear, let dateWeekOfYear = dateComponents.weekOfYear else { return nil }
        return currentWeekOfYear == dateWeekOfYear
    }
}

extension Calendar {
    
    static let gregorian: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = UserDefaults.standard.bool(forKey: "startWeekOnMonday") ? 2 : 1
        return calendar
    }()
}


extension Date {
    func startOfWeek() -> Date {
        getCalendarForCorrectWeekday().date(from: getCalendarForCorrectWeekday().dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
    }
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var startOfMonth: Date {

        let calendar = getCalendarForCorrectWeekday()
        let components = calendar.dateComponents([.year, .month], from: self)
        return  calendar.date(from: components)!
    }
    
    var startOfYear: Date {

        let calendar = getCalendarForCorrectWeekday()
        let components = calendar.dateComponents([.year], from: self)

        return  calendar.date(from: components)!
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = 0
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return getCalendarForCorrectWeekday().date(byAdding: components, to: startOfMonth)!
    }
    
    var endOfYear: Date {

        let calendar = getCalendarForCorrectWeekday()
        var components = calendar.dateComponents([.year], from: self)
        components.year = 1
        components.second = -1
        return  getCalendarForCorrectWeekday().date(byAdding: components, to: startOfYear)!
    }
    
    var endOfWeek: Date {
        var components = DateComponents()
        components.weekOfYear = 1
        components.second = -1
        return getCalendarForCorrectWeekday().date(byAdding: components, to: startOfWeek())!
        
    }
    
    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
            calendar.isDate(self, equalTo: date, toGranularity: component)
        }
    
    func isInThisYear() -> Bool { isEqual(to: Date(), toGranularity: .year) }
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
