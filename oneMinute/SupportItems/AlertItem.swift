//
//  AlertItem.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2022-07-06.
//

import SwiftUI


struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}
