//
//  SearchBar.swift
//  oneWeek
//
//  Created by Blake Patenaude on 2020-11-03.
//

import Foundation
import SwiftUI

//Function to Hide Keyboard
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}



struct SearchBar: UIViewRepresentable {
    
    @Binding var text: String
    
    class Coordinator: NSObject, UISearchBarDelegate {
        
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            UIApplication.shared.endEditing()
        }
        
    
    }
    
    func makeCoordinator() -> Coordinator {
    
        return Coordinator(text: $text)
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.returnKeyType = .done
        searchBar.enablesReturnKeyAutomatically = false
        
        return searchBar
    }
    
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
        
    }
    
}
