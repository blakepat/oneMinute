//
//  ContentView.swift
//  WatchMinutes Watch App
//
//  Created by Blake Patenaude on 2022-12-06.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var addedActivity: ActivityToSave
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
