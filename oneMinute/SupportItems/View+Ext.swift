//
//  View+Ext.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2021-08-26.
//

import SwiftUI
import CoreData

extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}

extension View {

    func notesTextFieldAlert(isShowing: Binding<Bool>,
                        text: Binding<String>,
                             saveActivity: Binding<Bool>,
                        title: String) -> some View {
        NotesTextFieldAlert(isShowing: isShowing,
                            text: text, saveActivity: saveActivity,
                       presenting: self,
                            title: title
                            )
    }

}

//extention to change placeholder text on textfields
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
