//
//  DateView.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-08-26.
//

import SwiftUI

struct DateView: View {
    
    let dateFormatter: DateFormatter = {
        var df = DateFormatter()
        df.dateFormat = "EEEE, MMM, d, yyyy"
        return df
    }()
    
    var body: some View {
        HStack {
            Text("\(Date(), formatter: dateFormatter)")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .semibold))
            Spacer()
        }
        .padding(.horizontal)
    }
}
