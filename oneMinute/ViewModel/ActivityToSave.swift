//
//  SelectedActivity.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2020-11-11.
//

import SwiftUI
import Combine

class ActivityToSave: ObservableObject {
    
    var didChange = PassthroughSubject<Void, Never>()
    
    var activityName = "Select Activity" { didSet { didChange.send() } }
    var hours: Float = 0 { didSet { didChange.send() } }
    var minutes: Float = 0 { didSet { didChange.send() } }
    var category = "fitness" { didSet { didChange.send() } }
    var notes = "" { didSet { didChange.send() } }
}

