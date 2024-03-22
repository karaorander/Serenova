//
//  ContentView.swift
//  preview temp
//
//  Created by Ava Schrandt on 3/22/24.
//


import SwiftUI
import HealthKit
import HealthKitUI

struct ForumHomeView: View {
    @State private var user = "" //TODO: - get user info viewUser()
    @State private var userName = "" //TODO: username
    @State private var showNewPostView: Bool = false
    @State private var forumCount: [String] = []
    var body: some View {
        
        NavigationView {
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [.nightfallHarmonySilverGray.opacity(0.9), .nightfallHarmonyRoyalPurple.opacity(0.5), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    Text("Nova Forum")
                        .font(Font.custom("NovaSquareSlim-Bold", size: 35))
                        .frame(width: .infinity)
                        .foregroundColor(.white)
                    Divider().frame(width: 350, height: 1).overlay(.gray)
                    
                    Spacer()
                    
                    //TODO: use UI from latest ForumView to loop through and display forums once backend is impemented
                    ScrollView(.vertical, showsIndicators:false){
                        VStack(spacing: 1) {
                            // TODO: Loop through forums that are
                            
                            ForEach(0...15, id: \.self) { _ in
                                NavigationLink(destination: ForumHomeView().navigationBarBackButtonHidden(true)) {
                                    ZStack {
                                        Rectangle()
                                            .fill(.white.opacity(0.7))
                                            .ignoresSafeArea()
                                            .frame(width: .infinity)
                                        HStack {
                                            
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
                                                    
                                                }
                                                
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
                    Spacer()
                    Button(action:{
                        //updateUserValues()
                        showNewPostView = true
                    }){
                        Text("New Forum").font(.system(size: 20)).fontWeight(.medium).frame(width: 275, height: 50).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(10)
                    }
                    NavigationLink ("", destination: CreateForumView().navigationBarBackButtonHidden(true), isActive: $showNewPostView)
                }
            }
        }
    }
}
    
    struct CreateForumView: View {
        @State private var forumTitle: String = ""
        @State private var forumDescription: String = ""
        
        @Environment(\.dismiss) private var dismiss
        @FocusState private var showkeyboard: Bool
        
        @State var tagOptions: [String] = ["None", "Questions", "Tips", "Hacks", "Support", "Goals", "Midnight Thoughts"]
        @State private var tagOption: Int = 0
        @State private var showTagOptions: Bool = false
        var body: some View {
            
            NavigationView {
                ZStack {
                    
                    LinearGradient(gradient: Gradient(colors: [.nightfallHarmonySilverGray.opacity(0.9), .nightfallHarmonyRoyalPurple.opacity(0.5), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                    VStack (spacing: 50){
                       
                        HStack {
                                Button("Cancel", role: .destructive) {
                                    dismiss()
                                }.padding()
                           
                            }.hSpacing(.trailing)
                        
                        Text("New Forum")
                            .font(Font.custom("NovaSquareSlim-Bold", size: 35))
                            .frame(width: .infinity)
                            .foregroundColor(.white)
                        
                        HStack {
                            Text("Title:")
                                .multilineTextAlignment(.center)
                                .font(.caption)
                                .opacity(0.8)
                                .padding()
                            ZStack {
                                TextField("name your forum",text: $forumTitle)
                            }
                        }.padding()
                            .frame(width: 325, height: 50)
                            .background(.white.opacity(0.15))
                            .cornerRadius(10)
                        HStack {
                            
                            TextField("add a description", text: $forumDescription, axis: .vertical)
                                .focused($showkeyboard).padding().vSpacing(.top)
                        }.padding()
                            .frame(width: 325, height: 250)
                            .background(.white.opacity(0.15))
                            .cornerRadius(10)
                        
                        //Tags
                        HStack {
                            Button {
                                showTagOptions.toggle()
                            } label: {
                                Text("Tags")
                                    .foregroundColor(Color.nightfallHarmonySilverGray)
                            }
                            .padding(.vertical, 12).padding(.horizontal, 22)
                            .background(Color.dreamyTwilightOrchid)
                            .cornerRadius(10)
                            .buttonStyle(NoStyle())
                            
                            if tagOption > 0 && tagOption <= tagOptions.endIndex {
                                HStack {
                                    Text(tagOptions[tagOption])
                                        .foregroundColor(Color.white.opacity(0.8))
                                    Button {
                                        tagOption = 0
                                    } label: {
                                        Image(systemName: "xmark")
                                            .resizable()
                                            .frame(width: 10, height: 10)
                                            .foregroundColor(Color.white.opacity(0.8))
                                    }
                                }
                                .padding(.vertical, 12).padding(.horizontal, 22)
                                .background(Color.dreamyTwilightOrchid)
                                .cornerRadius(10)
                                .buttonStyle(NoStyle())
                            }
                            Spacer()
                        }.sheet(isPresented: $showTagOptions, content: {
                            TagOptionsView(tagOption: $tagOption)
                                .padding(.horizontal, 25)
                                .presentationDetents([.fraction(0.55)])
                        })
                        .padding(.horizontal, 50)
                        
                        Button(action:{
                            // Save forum to firebase here
                            dismiss()
                        }){
                            Text("Create Forum").font(.system(size: 20)).fontWeight(.medium).frame(width: 275, height: 50).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(10)
                        }.vSpacing(.bottom)
                            .disabled(forumTitle == "" )
                            .opacity((forumTitle == "" ) ? 0.4 : 1)
                        
                    }
                }
            }
        
    }

  /*  func updateUserValues() {
        
        /* Update user values asynchronously */
        if let currUser = currUser {
            currUser.typicalSleepTime = selectedHours
            currUser.updateValues(newValues: ["typicalSleepTime" : currUser.typicalSleepTime])
        } else {
            print("ERROR! No account found (preview mode?)")
        }

    }*/
    
}
                           
struct NoStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
    }
}
struct TagOptionsView: View {
    
    @Binding var tagOption: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Sort")
                    .font(.system(size: 24))
                    .foregroundColor(.dreamyTwilightOrchid)
                
                Spacer()
            }
            
            Divider()
                .padding(.vertical, 12)
            
            // Filter Option Buttons
            ForEach(1...CreateForumView().tagOptions.count - 1, id: \.self) { number in
                Button {
                    withAnimation {
                        tagOption = number
                    }
                } label: {
                    HStack {
                        Image(systemName: tagOption == number ? "moon.fill":"moon")
                            .foregroundColor(.dreamyTwilightOrchid)
                            .transition(.scale)
                        Text(CreateForumView().tagOptions[number])
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .padding(.vertical, 10)
                    }
                }
                .buttonStyle(NoStyle())
                
            }
        }
    }
}


#Preview {
    ForumHomeView()
}

