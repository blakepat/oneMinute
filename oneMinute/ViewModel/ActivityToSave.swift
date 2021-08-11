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
    
    @Published var activityName = "Select Activity..." { didSet { didChange.send() } }
    var hours: Float = 0 { didSet { didChange.send() } }
    var minutes: Float = 0 { didSet { didChange.send() } }
    @Published var category = "category0" { didSet { didChange.send() } }
    var notes = "" { didSet { didChange.send() } }
}

