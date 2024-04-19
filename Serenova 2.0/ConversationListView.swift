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
    @State var participants: [String] = []
    
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
            
            if let participants = userData["participants"] as? [String] {
                self.participants = participants
            }
                                    
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

struct IndividualConversation: View {
    // Parameter
    @Binding var conversation: Conversation
    @State private var names: [String] = []
    @State private var previewListener: ListenerRegistration?
    @State private var hasChanged: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if conversation.numParticipants == 2 {
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color.white)
                        .foregroundColor(.clear)
                        .padding(.horizontal)
                } else if conversation.numParticipants > 2 {
                    Image(systemName: "person.3.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35, height: 40)
                        .foregroundColor(Color.white)
                        .padding(.horizontal)
                }
                VStack(alignment: .leading){
                    Text("\(names.joined(separator: ", "))")
                        .font(.system(size: 13))
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .padding(.bottom, 5)
                    if conversation.mostRecentMessage != "" {
                        Text("\(conversation.mostRecentMessage)")
                            .font(.system(size: 13))
                            .fontWeight(.semibold)
                            .foregroundColor(.moonlitSerenityLilac)
                            .multilineTextAlignment(.leading)
                    } else {
                        Text("Start chatting now!")
                            .font(.system(size: 13))
                            .fontWeight(.semibold)
                            .foregroundColor(.moonlitSerenityLilac)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                Image(systemName: "circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 5, height: 5)
                    .foregroundColor(Color.white)
                    .padding(.leading)
            }
            .padding(.vertical, 8).padding(.horizontal, 10)
        }
        .onAppear() {
            names = []
            fetchUsernames()
            
            if previewListener == nil {
                guard let convoID = conversation.convoId else {
                    return
                }
                let convoRef = Firestore.firestore().collection("Conversations")
                previewListener = convoRef.document(convoID).addSnapshotListener { documentSnapshot, error in
                    print("UPDATE!")
                    if let error = error {
                        print("Error retreiving collection: \(error)")
                    }
                    guard let document = documentSnapshot else {
                        print("Error fetching document: \(error!)")
                        return
                    }
                    guard let data = document.data() else {
                        print("Document data was empty.")
                        return
                    }
                    // Update preview
                    if let mostRecentMessage = data["mostRecentMessage"] as? String {
                        conversation.mostRecentMessage = mostRecentMessage
                    }
                    if let mostRecentTimestamp = data["mostRecentTimestamp"] as? Double {
                        conversation.mostRecentTimestamp = mostRecentTimestamp
                    }
                    hasChanged.toggle()
                }
            }
        }
    }
    
    func fetchUsernames() {
        
        let db = Database.database().reference()
        let id = Auth.auth().currentUser!.uid
        let ur = db.child("User")
        
        for participant in conversation.participants {
            if participant == Auth.auth().currentUser?.uid {
                continue
            }
            let currRef = ur.child(participant)
            currRef.observeSingleEvent(of: .value) { snapshot,arg  in
                guard let userData = snapshot.value as? [String: Any] else {
                    print("Error fetching data")
                    return
                }
                if let name = userData["name"] as? String {
                    names.append(name)
                }
            }
        }
    }
}

struct ConversationListView: View {
    
    @StateObject private var viewModel = ConversationViewModel()
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
                        NavigationLink(destination: ForumView().navigationBarBackButtonHidden(true)) {
                            Image(systemName: "line.horizontal.3.decrease")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Text("Messages")
                            .font(Font.custom("NovaSquareSlim-Bold", size: 35))
                            .foregroundColor(.white)
                        Spacer()
                        NavigationLink(destination: ChooseConversationOptionView().navigationBarBackButtonHidden(true)) {
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                        }.isDetailLink(false)
                    }
                    .padding()
                    .padding(.horizontal, 15)
                        
                    if conversationList.count == 0 {
                        NoConversationsView()
                    } else {
                        List {
                            ForEach(conversationList.indices, id: \.self) { index in
                                ZStack {
                                        ForEach(conversationList, id: \.convoId) { conversation in
                                                /*
                                                VStack(alignment: .leading, spacing: 5) {
                                                    Text("\(conversation.messages[0])")
                                                        .font(.headline)
                                                        .fontWeight(.semibold)
                                                        .foregroundColor(.white) // Adjust text color as needed
                                                        .lineLimit(2) // Limit title to 2 lines
                                                }
                                                .padding()
                                                .background(Color.moonlitSerenityLilac.opacity(0.1)) // Set background color
                                                .cornerRadius(10)
                                                .shadow(radius: 2)
                                                 */
                                        }
                                    
                                    NavigationLink(destination: MessagingView(convoID: conversationList[index].convoId!).navigationBarBackButtonHidden(false)) {
                                        EmptyView()
                                    }
                                    .opacity(0)
                                    IndividualConversation(conversation: $conversationList[index])
                                        .padding(.vertical, 15)
                                        .onAppear {
                                            if index == conversationList.count - 1 && lastConversation != nil {
                                                Task {
                                                    await queryChats(NUM_CHATS: queryNum)
                                                }
                                            }
                                        }
                                        .padding(5)
                                }
                            }
                            .onDelete { indexSet in
                                
                                if let index = indexSet.first {
                                    deleteConversation(conversation: conversationList[index])
                                }
                                
                                conversationList.remove(atOffsets: indexSet)
                                
                                
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.dreamyTwilightOrchid)
                            )
                        }
                        .padding(8)
                        .listRowSpacing(2)
                        .listStyle(PlainListStyle())
                        .scrollIndicators(ScrollIndicatorVisibility.hidden)
                    }
                    HStack(content: {
                        NavigationLink(destination: NotificationsView().navigationBarBackButtonHidden(true)) {
                            Image(systemName: "bell.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                        }.isDetailLink(false)
                        
                        Spacer()
                        
                        NavigationLink(destination: CreateConversationView().navigationBarBackButtonHidden(true)) {
                            Image(systemName: "plus")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.dreamyTwilightOrchid)
                                .frame(width: 50, height: 50)
                                .background(.white, in: .circle)
                        }.isDetailLink(false)
                        
                        Spacer()
                        
                        NavigationLink(destination: ForumPostView(postText: "", postTitle: "").navigationBarBackButtonHidden(true)) {
                            Image(systemName: "person.2")
                                .resizable()
                                .frame(width: 45, height: 30)
                                .foregroundColor(.white)
                        }
                    })
                    .padding()
                    .padding(.horizontal, 15)
                    .hSpacing(.center)
                }
                
            }.onAppear() {
                Task {
                    // Prevents crash but data will not be loaded
                    // Need to run in simulator
                    if conversationList.count == 0 && currUser != nil {
                        await queryChats(NUM_CHATS: queryNum)
                    }
                }
            }
        }
    }
    
    func deleteConversation(conversation: Conversation) {
        let db = Firestore.firestore()
        
//        let currentUserID = Auth.auth().currentUser!.uid
           
           // Reference to the particular "conversation" collection
        let convoCollectionRef = db.collection("Conversations").document(conversation.convoId!)
//           
//           // Delete the userID from conversation
//        var newParticipants = viewModel.participants
//        
//        if let index = newParticipants.firstIndex(of: currentUserID) {
//            newParticipants.remove(at: index)
//        }
        conversation.numParticipants -= 1
        convoCollectionRef.updateData([
            "participants": FieldValue.arrayRemove([currUser!.userID])
        ])
        // REMOVE FROM LIST
        conversationList.removeAll(where: {$0.convoId == conversation.convoId})
    }
    
    /*
     * Retrieves posts from Firebase
     */
    func queryChats(NUM_CHATS: Int) async {
        // Database Reference
        let db = Firestore.firestore()
        
        do {
            // Fetch batch of posts from Firestore
            var query: Query! = db.collection("Conversations")
                .whereField("participants", arrayContains: Auth.auth().currentUser!.uid)
                .limit(to: NUM_CHATS)
            
            if let lastConversation = lastConversation {
                query = query.start(afterDocument: lastConversation)
            }
            
            // Retrieve documents
            let chatBatch = try await query.getDocuments()
            let newChats = chatBatch.documents.compactMap { convo -> Conversation? in
                try? convo.data(as: Conversation.self)
            }
            
            await MainActor.run(body: {
                conversationList += newChats
                print(conversationList)
                lastConversation = chatBatch.documents.last
            })
            
        } catch {
            print (error.localizedDescription)
        }
        return
    }
}

struct ConversationListView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationListView()
    }
}

