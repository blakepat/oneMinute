//
//  AlertView.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2020-11-06.
//

import SwiftUI
import CoreData

struct NotesTextFieldAlert<Presenting>: View where Presenting: View {
    

    @Binding var isShowing: Bool
    @Binding var text: String
    @Binding var saveActivity: Bool
    let presenting: Presenting
    let title: String

    var body: some View {
        GeometryReader { (deviceSize: GeometryProxy) in
            ZStack {
                self.presenting
                    .disabled(isShowing)
                VStack {
                    Text(self.title)
                        .foregroundColor(.minutesBackgroundBlack)
                    TextField("notes...", text: self.$text)
                        .placeholder(when: text.isEmpty, placeholder: {
                            Text("notes...").foregroundColor(.gray)
                        })
                        .foregroundColor(.minutesBackgroundBlack)
                    Divider()
                    HStack {
                        Button {
                            //save
                            saveActivity = true
                            self.isShowing.toggle()
                        } label: {
                            Text("Save")
                                .fontWeight(.semibold)
                                .frame(width: 100)
                                .offset(x: -10)
                        }
                        
                        
                        Divider()
                            .frame(height: 50)
                        

                        Button(action: {
                            withAnimation {
                                self.text = ""
                                self.isShowing.toggle()
                            }
                        }) {
                            Text("Dismiss")
                                .fontWeight(.semibold)
                                .frame(width: 100)
                                .offset(x: 10)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .frame(
                    width: deviceSize.size.width*0.7,
                    height: deviceSize.size.height*0.7
                )
                .shadow(radius: 1)
                .opacity(self.isShowing ? 1 : 0)
            }
        }
    }
}
//    struct NotesTextFieldAlert_Previews: PreviewProvider {
//        static var previews: some View {
//
//            VStack {
//                Text("Hi")
//                    .notesTextFieldAlert(isShowing: .constant(true), text: .constant(""), saveActivity: .constant(false), title: "Title")
//            }
//
//
//
//            NotesTextFieldAlert(isShowing: .constant(true), text: .constant(""), saveActivity: .constant(false), title: "Title")
//                .previewLayout(.sizeThatFits)
//                .preferredColorScheme(.light)
//        }
//    }

