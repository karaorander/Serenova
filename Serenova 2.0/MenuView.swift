//
//  MenuView.swift
//  Serenova 2.0
//
//  Created by Ava Schrandt on 4/11/24.
//

import SwiftUI



/*
 To use add overlay to UI page:
 
 .overlay(alignment: .bottom, content: {
     
    MenuView()
     
 })
 
 */
struct MenuView: View {
    var body: some View {
        HStack (spacing: 40){
            NavigationLink(destination: SleepGraphView().navigationBarBackButtonHidden(true)) {
                
                Image(systemName: "chart.xyaxis.line")
                    .resizable()
                    .frame(width: 30, height: 35)
                    .foregroundColor(.white)
                
            }
        NavigationLink(destination: SleepLogView().navigationBarBackButtonHidden(true)) {

                Image(systemName: "zzz")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
            
        }
            NavigationLink(destination: SleepGoalsView().navigationBarBackButtonHidden(true)) {

                Image(systemName: "list.clipboard")
                    .resizable()
                    .frame(width: 30, height: 40)
                    .foregroundColor(.white)
            
        }
            NavigationLink(destination: ForumView().navigationBarBackButtonHidden(true)) {

                    Image(systemName: "person.2")
                        .resizable()
                        .frame(width: 45, height: 30)
                        .foregroundColor(.white)
                
            }
            NavigationLink(destination: JournalView().navigationBarBackButtonHidden(true)) {

                Image(systemName: "book.closed")
                    .resizable()
                    .frame(width: 30, height: 40)
                    .foregroundColor(.white)
            
        }
    }.padding()
    .hSpacing(.center)
    .background(Color.dreamyTwilightMidnightBlue)
        

    }
}

#Preview {
    MenuView()
}
