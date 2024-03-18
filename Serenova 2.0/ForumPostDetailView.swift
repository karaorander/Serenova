//
//  ForumPostDetailView.swift
//  Serenova 2.0
//
//  Created by Cristina Corley on 3/17/24.
//
/*
import SwiftUI

struct ForumPostDetailView: View {
    
    let post: Post
    
    @State private var reply: String = ""
    
    @State private var isReplyWindowOpen = false
    
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView {
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [
                    .nightfallHarmonyRoyalPurple.opacity(0.7),
                    .dreamyTwilightMidnightBlue.opacity(0.7),
                    .dreamyTwilightOrchid]),
                     startPoint: .topLeading, endPoint: .bottomLeading)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Button {
                           dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .resizable()
                                .frame(width: 15, height: 25)
                                .foregroundColor(.white)
                        }
                            
                        Spacer()
                        

                    }
                    .padding()
                    .padding(.horizontal, 15)
                    
                    Spacer()

                    HStack {
                        TextField("Share your sleep thoughts...", text: $reply, axis: .vertical)
                            .lineLimit(5)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.white.opacity(0.5))
                            .cornerRadius(20)
                        Button {
                            // Action
                        } label: {
                            Text("Reply")
                                .font(.callout)
                                .foregroundColor(Color.nightfallHarmonyRoyalPurple.opacity(1))
                                .padding(.leading, 5)
                        }
                    }
                }
            }
        }
    }
}

struct ForumPostDetailView_Preview: PreviewProvider {
    static var previews: some View {
        let samplePost = Post(title: "Sample Post",
                              content: "Zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz\n" +
                                       "Zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz\n" +
                                       "Zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz\n" +
                                       "Zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz\n")
        
        return ForumPostDetailView(post: samplePost)
    }
}*/
