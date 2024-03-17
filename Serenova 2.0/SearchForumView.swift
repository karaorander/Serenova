//
//  SearchForumView.swift
//  Serenova 2.0
//
//  Created by Cristina Corley on 3/14/24.
//

import SwiftUI

struct SearchForumView: View {
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.nightfallHarmonySilverGray.opacity(0.9), .nightfallHarmonyRoyalPurple.opacity(0.5), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        NavigationLink(destination: ForumView().navigationBarBackButtonHidden(true)) {
                            Image(systemName: "arrow.left")
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal)
                        
                        TextField("Search", text: $searchText)
                            //.frame(width: 300)
                            .padding()
                            .background(.gray.opacity(0.25))
                            .cornerRadius(10)
                    }
                    .padding()
                    .padding(.horizontal, 15)
                    .background{
                        Rectangle()
                            .fill(Color.nightfallHarmonySilverGray.opacity(0.1))
                            .ignoresSafeArea()
                    
                    }
                    
                    Spacer()
                    
                    HStack {
                        NavigationLink(destination: ForumView().navigationBarBackButtonHidden(true)) {
                            Image(systemName: "arrow.left")
                        }
                        .foregroundColor(.black)
                        .transition(.slide)
                        
                        TextField("Search", text: $searchText)
                            .frame(width: 300)
                    }

                }
            }
        }
    }
}

#Preview {
    SearchForumView()
}
