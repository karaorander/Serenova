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

class ConversationViewModel: ObservableObject {
    
    func fetchUsername(completion: @escaping () -> Void) {
        let db = Database.database().reference()
        let id = Auth.auth().currentUser!.uid
        let ur = db.child("User").child(id)
        
        ur.observeSingleEvent(of: .value) { snapshot,arg  in
            guard let userData = snapshot.value as? [String: Any] else {
                print("Error fetching data")
                return
            }
            
            // TODO: Extract additional information based on your data structure
                                    
            self.objectWillChange.send()
                            
            // Call the completion closure to indicate that data fetching is completed
            completion()
            
        }
    }
}

struct NoConversationsView: View {
    var body: some View {
        VStack (alignment: .center){
            Spacer()
            Image(systemName: "moon.stars.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.white)
                .padding()
            Text("No Conversations Yet")
                .foregroundColor(.white)
                .font(.system(size: 30))
                .fontWeight(.semibold)
            Spacer()
        }
    }
}

struct ConversationListView: View {
    
    @StateObject private var viewModel = GoalViewModel()
    
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
                        
                        Text("These are your direct messages")
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
                        NoConversationsView()
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
            }.onAppear() {
                UIRefreshControl.appearance().tintColor = .white
                Task {
                    // Prevents crash but data will not be loaded
                    // Need to run in simulator
                    if currUser != nil {
                        //await queryPosts(NUM_POSTS: queryNum)
                    }
                }
            }
        }
    }
}
