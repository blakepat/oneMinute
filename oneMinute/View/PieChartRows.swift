//
//  PieChartRows.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-08-03.
//

import SwiftUI

struct PieChartRows: View {
    
    var colors: [Color]
    var names: [String]
    var values: [String]
    var percents: [String]
    
    var body: some View {
        VStack{
            ForEach(0..<self.values.count) { i in
                HStack {
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(self.colors[i])
                        .frame(width: 20, height: 20)
                    Text(self.names[i])
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(self.values[i])
                        Text(self.percents[i])
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

//struct PieChartRows_Previews: PreviewProvider {
//    static var previews: some View {
//        PieChartRows()
//    }
//}
