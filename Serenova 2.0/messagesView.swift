//
//  messagesView.swift
//  Serenova 2.0
//
//  Created by Wilson, Caitlin Vail on 4/17/24.
//
/*
import Foundation


import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage



struct messagesView: View {
    @StateObject private var viewModel = GetNameModel()
    
    @State private var messages: [Message] = []
    @State private var queryNum: Int = 25
    @State private var lastEntry: DocumentSnapshot?
    @State private var privateView: Bool = true
    @State private var privacy: String = "Private"
    @State private var refreshing: Bool = true
    @State private var currentFriends: [String] = []
    
    @State public var currentConvo: Conversation
    
    var body: some View {
        NavigationView {
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [
                    .moonlitSerenitySteelBlue.opacity(0.7),
                    .dreamyTwilightMidnightBlue.opacity(0.7),
                    .dreamyTwilightMidnightBlue]),
                     startPoint: .topLeading, endPoint: .bottomLeading)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {

                    ForEach(messages, id: \.senderID) { entry in
                     messageListingView(message: entry)
                            .onAppear {
                                
                                if lastEntry != nil {
                                    Task {
                                        await queryMessages(NUM_ENTRIES: queryNum)
                                    }
                                }
                                 
                            }
                            .padding(5)
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .padding(8)
                    .listRowSpacing(10)
                    .listStyle(PlainListStyle())
                    .scrollIndicators(ScrollIndicatorVisibility.hidden)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.dreamyTwilightMidnightBlue).padding()
                    )
                    
                }
            }
            .overlay(alignment: .bottom, content:  {
                VStack{
                    NavigationLink(destination: createJournalView().navigationBarBackButtonHidden(true)
                        .onDisappear {
                            if(privateView) {
                                UIRefreshControl.appearance().tintColor = .white
                                Task {
                                    messages = []
                                    lastEntry = nil
                                    await queryMessages(NUM_ENTRIES: queryNum)
                                }
                            } else {
                                Task {
                                    messages = []
                                    lastEntry = nil
                                    await queryPublishedJournal(NUM_ENTRIES: queryNum)
                                }
                            }
                        }) {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.dreamyTwilightMidnightBlue)
                            .frame(width: 50, height: 50)
                            .background(.white, in: .circle)
                            .padding()
                    }.isDetailLink(false)
                    MenuView()}})
            .onAppear() {
                checkIfFriends()
                Task {
                        UIRefreshControl.appearance().tintColor = .white
                        Task {
                            if messages.count == 0 {
                                await queryMessages(NUM_ENTRIES: queryNum)
                            }
                        }
                   
                    
                }
            }
        }
    }

    /* Load friends in for privacy */
    func checkIfFriends() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No authenticated user found")
            return
        }

        let db = Firestore.firestore()
        let userFriendsRef = db.collection("FriendRequests").document(currentUserID).collection("Friends")

        // Fetch all documents from the Friends subcollection
        userFriendsRef.getDocuments { (querySnapshot, error) in
            DispatchQueue.main.async {
                if let documents = querySnapshot?.documents {
                    // Clear the currentFriends array first to avoid duplicates
                    currentFriends.removeAll()
                    
                    // Append each document's ID to the currentFriends array
                    for document in documents {
                        currentFriends.append(document.documentID)
                    }
                    
                    // Print the number of friends added (optional)
                    print("Added \(currentFriends.count) friends to the array.")
                } else {
                    print("Failed to fetch friends: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }
    
    /*
     * Retrieves posts from Firebase
     */
    func queryMessages(NUM_ENTRIES: Int) async {
        // Database Reference
        let db = Firestore.firestore()
        
        do {
            var userId: String = ""
            if let user = Auth.auth().currentUser {
                // User is signed in
                userId = user.uid
                
               // print("User ID:", userId)
            } else {
                // No user is signed in
                print("No user signed in")
            }
            
            var query: Query! = db.collection("Conversation")
                .whereField("senderID", isEqualTo: userId)
                .order(by: "timeStamp", descending: true)
                .limit(to: NUM_ENTRIES)
            if let lastEntry = lastEntry, let timestamp = lastEntry["timeStamp"] as? Timestamp {
                query = query.start(after: [timestamp])
            }
            
            // Retrieve documents
            let messageBatch = try await query.getDocuments()
            let newEntries = messageBatch.documents.compactMap { Conversation -> Message? in
                do {
                    // try? Message.data(as: Conversation.self)
                    let messageData = try Conversation.data(as: Message.self)
                    return messageData
                }
                catch {
                    print("error decoded")
                    return nil
                }
            }
            
            await MainActor.run(body: {
                messages += newEntries
                lastEntry = messageBatch.documents.last
            })
            
        } catch {
            print (error.localizedDescription)
        }
        refreshing = false
        return
    }
    func queryPublishedJournal(NUM_ENTRIES: Int) async {
        print("PUBLISHED JOURNALS\n")
        // Database Reference
        let db = Firestore.firestore()
        
        do {
            var userId: String = ""
            if let user = Auth.auth().currentUser {
                // User is signed in
                userId = user.uid
                
               // print("User ID:", userId)
            } else {
                // No user is signed in
                print("No user signed in")
            }
            
            var query: Query! = db.collection("Journal")
                //.whereField("journalPrivacyStatus", isEqualTo: false)
                .order(by: "timeStamp", descending: true)
                .limit(to: NUM_ENTRIES)
            if let lastEntry = lastEntry, let timestamp = lastEntry["timeStamp"] as? Timestamp {
                query = query.start(after: [timestamp])
            }
            
            // Retrieve documents
            let journalBatch = try await query.getDocuments()
            let newEntries = journalBatch.documents.compactMap { post -> Message? in
                try? post.data(as: Message.self)
            }
            
            await MainActor.run(body: {
                messages += newEntries
                lastEntry = journalBatch.documents.last
            })
            
        } catch {
            print (error.localizedDescription)
        }
        refreshing = false
        return
    }
}

/*struct NoMessagesView: View {
    
    var body: some View {
        VStack (alignment: .center){
            Spacer()
            Image(systemName: "moon.zzz.fill")
                .resizable()
                .frame(width: 55, height: 60)
                .foregroundColor(.white)
                .padding()
            Text("Get started with your journal")
                .foregroundColor(.white)
                .font(.system(size: 25))
                .fontWeight(.semibold)
            Spacer()
            
        }
    }
}*/


struct messageListingView: View {
    
    let message: Message
    
    
    @State private var isClicked: Bool = false
    @State private var selectedJournal: Journal?
    var body: some View {
            VStack(alignment: .leading) {
               
                    Text(message.content)
                        .foregroundColor(.white)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .padding(.bottom, 8)
                
                Text(message.senderID)
                    .foregroundColor(.white)
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    .padding(.bottom, 8)
                
                Text("\(message.timeStamp)")
                    .font(.system(size: 13))
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                
            }
        
    }
    
    
}

#Preview {
    let conversation = Conversation(participants: [])
    conversation.messages = [Message(senderID: Auth.auth().currentUser!.uid, content: "Hi")]
    conversation.numParticipants = 3
    return messagesView(currentConvo: conversation)
}*/
