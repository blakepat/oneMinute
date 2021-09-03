//
//  ActivitySelectorView.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-09-01.
//

import SwiftUI

struct ActivityNameView: View {
    
    @ObservedObject var activityToSave: ActivityToSave
    
    var body: some View {
        Text(self.activityToSave.activityName)
            .frame(width: screen.width - 50, height: 40, alignment: .leading)
            .padding(.leading, 4)
            .padding(.horizontal, 6)
            .background(Color(.black))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .foregroundColor(Color.getCategoryColor(activityToSave.category))
            .font(.system(size: 26))
    }
}
