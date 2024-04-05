//
//  ConversationListView.swift
//  Serenova 2.0
//
//  Created by Wilson, Caitlin Vail on 4/4/24.
// The UI so a user can see a list of their conversations

import Foundation
import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseDatabaseSwift

struct ConversationListView: View {
    
    @State var conversationList: [Conversation] = []
    @State private var queryNum: Int = 25
    @State private var lastConversation: DocumentSnapshot?
    
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
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        NavigationLink(destination: SearchForumView().navigationBarBackButtonHidden(true)) {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .fontWeight(.semibold)
                                .frame(width: 25, height: 25)
                                .foregroundColor(.white)
                        }
                        
                    }
                    .padding()
                    .padding(.horizontal, 15)
                        
                    if conversationList.count == 0 {
                        NoPostsView()
                    } else {
                        List {
                            ForEach(conversationList.indices, id: \.self) { index in
                                ZStack {
                                    /*
                                    NavigationLink(destination: ForumPostDetailView(post: $conversationList[index]).navigationBarBackButtonHidden(true)) {
                                        EmptyView()
                                    }
                                    .opacity(0)
                                     
                                    PostListingView(isFullView: false, post: $conversationList[index])
                                        .onAppear {
                                            if index == conversationList.count - 1 && lastConversation != nil {
                                                Task {
                                                    //await queryConversations(NUM_POSTS: queryNum)
                                                }
                                            }
                                        }
                                        .padding(5)
                                     */
                                }
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.soothingNightDeepIndigo)
                            )
                        }
                        .padding(8)
                        .listRowSpacing(5)
                        .listStyle(PlainListStyle())
                        .scrollIndicators(ScrollIndicatorVisibility.hidden)
                        .refreshable {
                            Task {
                                conversationList = []
                                lastConversation = nil
                                //await queryConversations(NUM_POSTS: queryNum)
                            }
                        }
                    }

                    HStack(content: {
                        NavigationLink(destination: NotificationsView().navigationBarBackButtonHidden(true)) {
                            Image(systemName: "bell.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                        }.isDetailLink(false)
                        
                        Spacer()
                        
                        NavigationLink(destination: ForumPostView().navigationBarBackButtonHidden(true)) {
                            Image(systemName: "plus")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.dreamyTwilightOrchid)
                                .frame(width: 50, height: 50)
                                .background(.white, in: .circle)
                        }.isDetailLink(false)
                        
                        Spacer()
                        
                        // TODO: Link to direct messages
                        //NavigationLink(destination: ForumPostView().navigationBarBackButtonHidden(true)) {
                        Image(systemName: "text.bubble.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                        //}.isDetailLink(false
                    })
                    .padding()
                    .padding(.horizontal, 15)
                    .hSpacing(.center)
                }
            }
        }
    }
}
