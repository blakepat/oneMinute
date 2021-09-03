//
//  Color+Ext.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-08-26.
//

import SwiftUI

extension Color {
    static let minutesYellow = Color("category0Color")
    static let minutesRed = Color("category1Color")
    static let minutesPurple = Color("category2Color")
    static let minutesGreen = Color("category3Color")
    static let minutesBlue = Color("category4Color")
    static let minutesBackgroundCharcoal = Color("charcoalColor")
    static let minutesBackgroundBlack = Color(#colorLiteral(red: 0.08235294118, green: 0.1058823529, blue: 0.1215686275, alpha: 1))
}


extension Color {
    
    static func getCategoryColor(_ category: String) -> Color {
        Color("\(category)Color")
    }
    
}
