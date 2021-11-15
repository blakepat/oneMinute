//
//  OnboardView.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-11-14.
//

import SwiftUI

struct OnboardView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var showOnboardView: Bool
    
    var body: some View {
        ZStack {
            
            Color.minutesBackgroundCharcoal
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                HStack {
                    
                    Spacer()
                    XDismissButton()
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                    }
                }
                
                Spacer()
                
                VStack(alignment: .center) {
                    Text("The Minutes App")
                        .foregroundColor(.minutesYellow)
                        .font(.title)
                        .bold()
                        .padding(.bottom, 6)
                    
                    Text("The app built to help people live healthy balanced lives. See the productive time you accumlate to reach your goals!")
                        .bold()
                        .font(.title3)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                .padding(.bottom)
                
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 16) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.minutesYellow)
                        
                        VStack(alignment: .leading) {
                            Text("Track Your Productivity")
                                .foregroundColor(.minutesYellow)
                            Text("Record custom activities using categories that suit your balanced life goals")
                                .foregroundColor(.white)
                        }
                    }
                    
                    HStack(spacing: 16) {
                        Image(systemName: "book.circle.fill")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.minutesYellow)
                        
                        VStack(alignment: .leading) {
                            Text("Review Activity History")
                                .foregroundColor(.minutesYellow)
                            Text("Filter and search logged activities to see: Frequency, last time logged, and notes")
                                .foregroundColor(.white)
                        }
                    }
                    
                    HStack(spacing: 16) {
                        Image(systemName: "chart.bar.doc.horizontal")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.minutesYellow)
                        
                        VStack(alignment: .leading) {
                            Text("Productivity Stats")
                                .foregroundColor(.minutesYellow)
                            Text("Stay motivated by visually seeing all the time you have accumulated!")
                                .foregroundColor(.white)
                        }
                    }
                }
                
                Spacer()
                
            }
            .frame(width: screen.width - 42)
        }
    }
}

struct OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardView(showOnboardView: .constant(true))
    }
}
