//
//  CategoryNameEditAlert.swift
//  oneMinute
//
//  Created by Blake Patenaude on 2020-12-02.
//

import SwiftUI

struct CategoryNameEditAlert: View {
    
    @Binding var isShowing: Bool
    @State var categoryNames: [Binding<String>]
    
    let categories = ["category1", "category2", "category3", "category4"]
    
    var body: some View {
        
        let uneditedNames: [String] = [categoryNames[0].wrappedValue, categoryNames[1].wrappedValue, categoryNames[2].wrappedValue, categoryNames[3].wrappedValue]
        
        ZStack {
            
            //Background Color
            Color.black.edgesIgnoringSafeArea(.all)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            //Stack of Category Names
            VStack {
                
                //Title
                Text("Personalize Category Names")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .semibold))
                    .frame(alignment: .center)
                    .padding(.top)
                    .padding(.horizontal)
                
                
                //Category List
                ForEach(categories.indices, id: \.self) { index in
                    CategoryNamerCell(category: categories[index], categoryName: self.categoryNames[index])
                }
                
                Divider()
                    .background(Color(.gray))

                HStack {
                    Button(action: {
                        withAnimation {
                            categoryNames[0].wrappedValue = uneditedNames[0]
                            categoryNames[1].wrappedValue = uneditedNames[1]
                            categoryNames[2].wrappedValue = uneditedNames[2]
                            categoryNames[3].wrappedValue = uneditedNames[3]
                            self.isShowing.toggle()
                        }
                    }) {
                        Text("Dismiss")
                            .foregroundColor(.white)
                            .padding(.leading, 8)
                            .padding(.bottom, 4)
                    }
                    .frame(width: screen.size.width*0.3)
                    
                    Spacer()
                    Divider()
                        .background(Color(.gray))
                        .frame(height: screen.size.height*0.07)
                    Spacer()
                    
                    Button {
                        withAnimation {
                            UserDefaults.standard.setValue("\(categoryNames[0].wrappedValue)", forKey: "category1Name")
                            UserDefaults.standard.setValue("\(categoryNames[1].wrappedValue)", forKey: "category2Name")
                            UserDefaults.standard.setValue("\(categoryNames[2].wrappedValue)", forKey: "category3Name")
                            UserDefaults.standard.setValue("\(categoryNames[3].wrappedValue)", forKey: "category4Name")
                            self.isShowing.toggle()
                        }
                    } label: {
                        Text("Add")
                            .foregroundColor(.white)
                            .padding(.trailing, 8)
                            .padding(.bottom, 4)
                    }
                    .frame(width: screen.size.width*0.3)

                }
                
            }
        }
        .frame(width: screen.size.width * 0.74, height: screen.size.height * 0.4, alignment: .center)
    }
}


struct CategoryNamerCell: View {
    
    var category: String
    @Binding var categoryName: String
    
    var body: some View {
        
        HStack {
            
            Image(category).renderingMode(.template)
                .resizable()
                .scaledToFit()
                .padding()
                .frame(width: screen.width / 5, height: screen.width / 5, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .foregroundColor(.white)
                .background(Color(.black))
                .font(.system(size: 30))
                .clipShape(Circle())
                .padding(.leading, 6)
                .padding(.vertical, 4)
            
                
            TextField(categoryName, text: $categoryName)
                .foregroundColor(.white)
                .padding(.trailing, 4)
                .padding(.all, 4)
                .background(Color("grayBackground"))
                .padding(.trailing, 16)
       
            
        }
        .frame(width: screen.size.width*0.6)
        
    }
    
}

