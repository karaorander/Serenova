//
//  ForumView.swift
//  Serenova 2.0
//
//  Created by Cristina Corley on 2/27/24.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct ForumView: View {
    
    @State private var forumPosts: [Post] = []
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.nightfallHarmonyNavyBlue.opacity(0.8), .dreamyTwilightMidnightBlue.opacity(0.7),
                    .dreamyTwilightMidnightBlue.opacity(0.7),
                    .nightfallHarmonyNavyBlue.opacity(0.8)]),
                    startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        // TODO: Make Dropdown Menu with different options (e.g. Home)
                        NavigationLink(destination: SleepGoalsView().navigationBarBackButtonHidden(true)) {
                            
                            Image(systemName: "line.horizontal.3.decrease")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.white)
                            
                        }
                            
                        Spacer()
                        
                        Text("Nova Forum")
                            .font(Font.custom("NovaSquareSlim-Bold", size: 35))
                            .frame(width: .infinity)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .fontWeight(.semibold)
                            .frame(width: 25, height: 25)
                            .foregroundColor(.white)
                        
                    }
                    .padding()
                    .padding(.horizontal, 15)
                    .background{
                        Rectangle()
                        .fill(.white.opacity(0.1))
                        .ignoresSafeArea()
                    
                    }
                    ScrollView(.vertical, showsIndicators:false) {
                        VStack(spacing: 1) {
                            // TODO: Loop through posts that are queried
                            ForEach(0...15, id: \.self) { _ in
                                NavigationLink(destination: ForumView().navigationBarBackButtonHidden(true)) {
                                    ZStack {
                                        Rectangle()
                                            .fill(.white.opacity(0.7))
                                            .ignoresSafeArea()
                                            .frame(width: .infinity)
                                        HStack {
                                            
                                            // TODO: Include User profile photos
                                            VStack {
                                                Image(systemName: "moon.fill")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fill)
                                                    .frame(width: 35, height: 35)
                                                    .foregroundColor(Color.soothingNightLightGray)
                                                    .background(
                                                        Rectangle()
                                                            .fill(Color.nightfallHarmonyNavyBlue.opacity(0.7))
                                                            .ignoresSafeArea()
                                                            .frame(width: 60, height: 60)
                                                    )
                                                    .padding(.top, 15)
                                                Spacer()
                                            }
                                            Spacer()
                                            
                                            // Post preview content
                                            VStack(alignment: .leading) {
                                                Text("TITLE")
                                                    .font(Font.custom("NovaSquareSlim-Bold", size: 20))
                                                    .foregroundColor(Color.black)
                                                HStack {
                                                    Text("Author")
                                                        .font(.system(size: 15))
                                                        .fontWeight(.semibold)
                                                        .foregroundColor(Color.nightfallHarmonyNavyBlue)
                                                    Image(systemName: "circle.fill")
                                                        .resizable()
                                                        .frame(width: 5, height: 5)
                                                        .foregroundColor(Color.nightfallHarmonyNavyBlue)
                                                    Text("Date")
                                                        .font(.system(size: 15))
                                                        .fontWeight(.semibold)
                                                        .foregroundColor(Color.nightfallHarmonyNavyBlue)
                                                    // TODO: Add image here maybe?
                                                    
                                                }
                                                // Limit word count of preview to: 50 characters
                                                Text("Lorem ipsum dolor sit amet, consectetur adipiscing...")
                                                    .foregroundColor(.black)
                                                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                                                
                                            }
                                            .frame(maxWidth: 250)
                                            
                                            Spacer()
                                            
                                        }
                                        .padding()
                                        .padding(.horizontal, 10)
                                    }
                                }
                            }
                        }
                    }
                    HStack(alignment: .bottom, content: {
                        
                        //NavigationLink(destination: ForumPostView().navigationBarBackButtonHidden(true)) {
                        
                        Image(systemName: "bell.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                        
                        //}
                        
                        Spacer()
                        
                        NavigationLink(destination: ForumPostView().navigationBarBackButtonHidden(true)) {
                            
                            Image(systemName: "plus")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.nightfallHarmonyNavyBlue)
                                .frame(width: 55, height: 55)
                                .background(.white.shadow(.drop(color: .black.opacity(0.25), radius: 5, x: 10, y: 10)), in: .circle)
                        }
                        
                        Spacer()
                        
                        // TODO: Link to direct messages
                        //NavigationLink(destination: ForumPostView().navigationBarBackButtonHidden(true)) {
                        
                        Image(systemName: "text.bubble")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                        //}
                    })
                    .padding()
                    .padding(.horizontal, 15)
                    .hSpacing(.center)
                    .background{
                        Rectangle()
                            .fill(.white.opacity(0.1))
                            .ignoresSafeArea()
                    }
                }
            }
        }
    }
    
    /*
     * TODO: Retrieve posts from Firebase
     */
    func queryPosts () {
        return
    }
    
}

#Preview {
    ForumView()
}
