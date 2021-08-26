//
//  SupportItems.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-04-06.
//

import Foundation
import SwiftUI




//Mark: - Universal Variables
let categories = ["category1", "category2", "category3", "category4"]
let screen = UIScreen.main.bounds


//Mark: - Data Types/Functions
//Data type for tab bar
enum ActiveSheet: Identifiable {
    case first, second, third, fourth, fifth
    
    var id: Int {
        hashValue
    }
}

//Time frame for filter functions
enum TimeFrame {
    case week, month, year, allTime
}

enum TimeUnits {
    case minutes, hours
}

//Convert time to minutes or hours
func timeConverter(time: Float, timeUnitIsHours: Bool) -> Float {
    
    if time == 0 {
        return 0
    } else if timeUnitIsHours == false {
        return time
    } else {
        return time / 60
    }
    
}

//Get string for current time unit
func timeUnitName(isHours: Bool) -> String {
    if isHours {
        return "hours"
    } else {
        return "minutes"
    }
}

//Show decimal places depending on time units
func decimalsToShow(isHours: Bool) -> String {
    
    if isHours {
        return "%.2f"
    } else {
        return "%.0f"
    }
    
}

//Time frame string getter
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

struct dayOfWeek: Identifiable {
    
    var id = UUID()
    var nameOfDay: String
    var dateOfDay: Int
    var month: String
    var category1: Int
    var category2: Int
    var category3: Int
    var category4: Int
    
}


//Category filter functions
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

//Helper function
func dividBy(lhs: Float, rhs: Float) -> Float {
    if rhs == 0 {
        return 0
    }
    return lhs/rhs
}



