//
//  JournalView.swift
//  Serenova 2.0
//
//  Created by Ava Schrandt on 3/21/24.
//



import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage



struct JournalView: View {
    @StateObject private var viewModel = GetNameModel()
    
    @State private var journalEntries: [Journal] = []
    @State private var queryNum: Int = 25
    @State private var lastEntry: DocumentSnapshot?
    @State private var privateView: Bool = true
    @State private var privacy: String = "Private"
    @State private var refreshing: Bool = true
    @State private var currentFriends: [String] = []
    
    
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
                    HStack {
                        // TODO: Make Dropdown Menu with different options (e.g. Home)
                        NavigationLink(destination: SleepGoalsView().navigationBarBackButtonHidden(true)) {
                            
                            Image(systemName: "chevron.backward")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                            
                        }
                            
                        Spacer()
                        
                        Text("Dream Journal")
                            .font(Font.custom("NovaSquareSlim-Bold", size: 35))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                       
                        
                    }
                    .padding()
                    .padding(.horizontal, 15)
                    
                    HStack {
                        Button( action: {
                            self.privateView = true
                            self.refreshing = true
                            Task {
                                journalEntries = []
                                lastEntry = nil
                                await queryJournal(NUM_ENTRIES: queryNum)
                            }
                            
                        }, label: {
                            Text("Your Journal")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .padding(.leading)
                            Image(systemName: "zzz")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                                .padding(.trailing)
                        })
                        
                            .background(privateView ? Color.tranquilMistMauve.opacity(0.5) : Color.clear)
                            .cornerRadius(2)
                        Button( action: {
                            self.privateView = false
                            self.refreshing = true
                            Task {
                                journalEntries = []
                                lastEntry = nil
                                await queryPublishedJournal(NUM_ENTRIES: queryNum)
                            }
                            
                            print("shared\n")
                           
                        }, label: {
                            Text("Dream Sharing")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.leading)
                                .padding(.vertical, 12)
                            Image(systemName: "rainbow")
                                .font(.system(size: 18))
                                .foregroundColor(.white)
                                .padding(.trailing)
                                })
                        
                        .background(!privateView ? Color.tranquilMistMauve.opacity(0.5) : Color.clear)
                        .cornerRadius(2)
                            
                    }.background(Color.clear)
                        .edgesIgnoringSafeArea(.horizontal)
                    
                        
                    
                    if journalEntries.count == 0 {
                        NoEntriesView1()
                    } else {
                        ZStack {
                            Color.tranquilMistAshGray
                            List {
                                if(privateView) {
                                    ForEach(journalEntries, id: \.id) { entry in
                                        JournalListingView(journal: entry)
                                            .onAppear {
                                                if lastEntry != nil {
                                                    Task {
                                                        await queryJournal(NUM_ENTRIES: queryNum)
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
                                } else {
                                    ForEach(journalEntries, id: \.id) { entry in
                                        // Check if the current user is friends with entry's userId

                                        // Only render the journal entry if it is public or the current user is friends with the userId
                                        if entry.journalPrivacyStatus == "Public" || (currentFriends.contains(entry.userId!) && entry.journalPrivacyStatus == "Friends") {
                                            JournalListingView2(journal: entry)
                                                .onAppear {
                                                    if lastEntry != nil {
                                                        Task {
                                                            await queryPublishedJournal(NUM_ENTRIES: queryNum)
                                                        }
                                                    }
                                                }
                                                .padding(5)
                                        }
                                    }
                                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                                    .padding(8)
                                    .listRowSpacing(10)
                                    .listStyle(PlainListStyle())
                                    .scrollIndicators(ScrollIndicatorVisibility.hidden)
                                    .listRowBackground(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.dreamyTwilightSlateGray.opacity(0.7)).padding()
                                            
                                    )
                                   
                                    
                                }
                                
                                
                            }
                           
                                .refreshable {
                                    if(privateView) {
                                        UIRefreshControl.appearance().tintColor = .white
                                        Task {
                                            journalEntries = []
                                            lastEntry = nil
                                            await queryJournal(NUM_ENTRIES: queryNum)
                                        }
                                    } else {
                                        Task {
                                            journalEntries = []
                                            lastEntry = nil
                                            await queryPublishedJournal(NUM_ENTRIES: queryNum)
                                        }
                                    }
                                }
                                
                                
                            
                                
                        }
                    }
                    
                }
            }
            .overlay(alignment: .bottom, content:  {
                VStack{
                    NavigationLink(destination: createJournalView().navigationBarBackButtonHidden(true)
                        .onDisappear {
                            if(privateView) {
                                UIRefreshControl.appearance().tintColor = .white
                                Task {
                                    journalEntries = []
                                    lastEntry = nil
                                    await queryJournal(NUM_ENTRIES: queryNum)
                                }
                            } else {
                                Task {
                                    journalEntries = []
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
                            if journalEntries.count == 0 {
                                await queryJournal(NUM_ENTRIES: queryNum)
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
    func queryJournal(NUM_ENTRIES: Int) async {
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
                .whereField("userId", isEqualTo: userId)
                .order(by: "timeStamp", descending: true)
                .limit(to: NUM_ENTRIES)
            if let lastEntry = lastEntry, let timestamp = lastEntry["timeStamp"] as? Timestamp {
                query = query.start(after: [timestamp])
            }
            
            // Retrieve documents
            let journalBatch = try await query.getDocuments()
            let newEntries = journalBatch.documents.compactMap { post -> Journal? in
                try? post.data(as: Journal.self)
            }
            
            await MainActor.run(body: {
                journalEntries += newEntries
                lastEntry = journalBatch.documents.last
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
            let newEntries = journalBatch.documents.compactMap { post -> Journal? in
                try? post.data(as: Journal.self)
            }
            
            await MainActor.run(body: {
                journalEntries += newEntries
                lastEntry = journalBatch.documents.last
            })
            
        } catch {
            print (error.localizedDescription)
        }
        refreshing = false
        return
    }
}

struct NoEntriesView1: View {
    
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
}


struct JournalListingView: View {
    
    let journal: Journal
    
    
    @State private var isClicked: Bool = false
    @State private var selectedJournal: Journal?
    var body: some View {
        Button (action: {isClicked.toggle()
            selectedJournal = journal}) {
            VStack(alignment: .leading) {
                HStack {
                
                    
                    VStack(alignment: .leading){
                        Text("\(journal.getRealTime())")
                            .font(.system(size: 13))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    }
                    
                    if(journal.journalPrivacyStatus == "Public") {
                        Text("Published").font(.system(size: 13))
                            .fontWeight(.semibold)
                            .foregroundColor(.dreamyTwilightLavenderPurple)
                            .multilineTextAlignment(.trailing)
                    }
                    if(journal.journalTags != []) {
                        Image(systemName: "person.2.fill")
                            .fontWeight(.semibold)
                            .foregroundColor(.moonlitSerenityCharcoalGray)
                            .multilineTextAlignment(.trailing)
                        
                    }
                }
                .padding(.vertical, 10)
            
                // Post preview content
                Text(journal.journalTitle)
                    .font(.custom("NovaSquareSlim-Bold", size: 20))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color.nightfallHarmonyRoyalPurple)
                    .padding(.bottom, 2)
                    .brightness(0.3)
                    .saturation(1.5)
                // Limit word count of preview to: 50 characters
                if journal.journalContent.count <= 55 {
                    Text(journal.journalContent)
                        .foregroundColor(.white)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .padding(.bottom, 8)
                } else {
                    Text(journal.journalContent.prefix(55) + "...")
                        .foregroundColor(.white)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .padding(.bottom, 8)
                }
                
                
                
                
            }
        }
        .buttonStyle(NoStyle1())
        .listRowSeparator(.hidden)
        .sheet(isPresented: $isClicked, content: {
            JournalDetailsView(journal: journal)
                .interactiveDismissDisabled()
                
                
        })
        
    }
    
    
}
struct JournalListingView2: View {
    
    let journal: Journal
    
    
    @State private var isClicked: Bool = false
    @State private var selectedJournal: Journal?
    @State var replies: [JournalReply] = []
    @State var reply: String = ""
    @State private var isReplying: Bool = false
    @State private var replyContent: String = ""
    @State private var showError:Bool = false
    @State private var errorMess: String = ""
    @State private var queryNum: Int = 25
    @State private var lastReply: DocumentSnapshot?
    var body: some View {
        Button (action: {isClicked.toggle()
            selectedJournal = journal}) {
            VStack(alignment: .leading) {
                HStack {
                
                    
                    VStack(alignment: .leading, spacing: 5){
                        NavigationLink(destination: OtherAccountView(userID: journal.userId ?? "").navigationBarBackButtonHidden(true)) {
                            Text("\(journal.username)")
                                .font(Font.custom("NovaSquareSlim-Bold", size: 20))
                                .shadow(radius: 20)
                                .fontWeight(.semibold)
                                .foregroundColor(Color.nightfallHarmonyNavyBlue)
                        }
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        Text("\(journal.getRealTime())")
                            .font(.system(size: 13))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.nightfallHarmonyNavyBlue)
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        
                    }
                    
                    
                }
                .padding(.vertical, 10)
            
                // Post preview content
                Text(journal.journalTitle)
                    .font(.system(size: 20))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color.nightfallHarmonyRoyalPurple)
                    .padding(.bottom, 2)
                    .brightness(0.3)
                    .saturation(1.5)
                // Limit word count of preview to: 50 characters
                if journal.journalContent.count <= 55 {
                    Text(journal.journalContent)
                        .foregroundColor(.white)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .padding(.bottom, 8)
                } else {
                    Text(journal.journalContent.prefix(55) + "...")
                        .foregroundColor(.white)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .padding(.bottom, 8)
                }
                if replies.count > 0 {
                    ForEach(replies.indices, id: \.self) { index in
                        JournalCommentView(commentReply: $replies[index], journ: journal)
                            .onAppear {
                                if index == replies.count - 1 && lastReply != nil {
                                    Task {
                                        await queryReplies(NUM_REPLIES: queryNum)
                                    }
                                }
                            }
                            .padding(5)
                    }
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.soothingNightDeepIndigo)
                    )
                }
                
                Button(action: {
                    isReplying.toggle()
                }) {
                    Text("Reply")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                if isReplying {
                    AddReplyView()
                        .padding()
                }
                
                
                
            }
        }
        .buttonStyle(NoStyle1())
        .listRowSeparator(.hidden)
        .sheet(isPresented: $isClicked, content: {
            PublishedDetailsView(journal: journal)
                .presentationDetents([.height(700)])
                .presentationCornerRadius(30)
                .background(Color.dreamyTwilightSlateGray)
                
                
        })
        .onAppear() {
            UIRefreshControl.appearance().tintColor = .white
            Task {
                // Prevents crash but data will not be loaded
                // Need to run in simulator
                if replies.count == 0 && currUser != nil {
                    await queryReplies(NUM_REPLIES: queryNum)
                }
            }
        }
        
        
    }
    
    func createReply() {
        print("tracking prog")
        Task {
            do {
                print("in the do")
                guard currUser != nil else {
                    print("nil")
                    return
                    
                }
                
               
                // Save post to Firebase
                let newReply = JournalReply(replyContent: reply, parentPostID: journal.journalId!)
                
                if (newReply.replyContent == "") {
                    return
                }

                try await newReply.createReply()
                replies.append(newReply)
                print("reply appened.")
                reply = ""
            } catch {
                print("error caugh \(error)")
               await errorAlerts(error)
            }
        }
        print("end")
    }
    
    func errorAlerts(_ error: Error)async{
        await MainActor.run(body: {
            errorMess = error.localizedDescription
            showError.toggle()
        })
    }
    
    func errorAlerts(_ error: String)async{
        await MainActor.run(body: {
            errorMess = error
            showError.toggle()
        })
    }
    
    
    func queryReplies(NUM_REPLIES: Int) async {
        print("this called?")
        // Database Reference
        let db = Firestore.firestore()
        
        do {
            // Check for nils
            guard journal.journalId != nil else { return }
            guard currUser != nil else { return }
            // Fetch batch of posts from Firestore
            var query: Query! = db.collection("Journal").document(journal.journalId!).collection("Replies")
                .order(by: "timeStamp", descending: false)
                .limit(to: NUM_REPLIES)
            
            if let lastReply = lastReply {
                query = query.start(afterDocument: lastReply)
            }
            
            // Retrieve documents
            let replyBatch = try await query.getDocuments()
            let newReplies = replyBatch.documents.compactMap { post -> JournalReply? in
                try? post.data(as: JournalReply.self)
            }
            
            await MainActor.run(body: {
                replies += newReplies
                lastReply = replyBatch.documents.last
            })
            
        } catch {
            print (error.localizedDescription)
        }
        return
    }
    
    @ViewBuilder
    func AddReplyView() -> some View {
        HStack(alignment: .bottom) {
            HStack(alignment: .bottom){
                TextField("Share your sleep thoughts...", text: $reply, axis: .vertical)
                    .padding(15)
                    .lineLimit(5)
                    .foregroundColor(Color.soothingNightDeepIndigo)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(20)
                    .submitLabel(.send)
                Button {
                    // Create reply
                    print("creating reply")
                    createReply()
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(Color.nightfallHarmonyRoyalPurple)
                        .brightness(0.3)
                        .saturation(1.5)
                        .disabled(reply.isEmpty)
                        .opacity(reply.isEmpty ? 0.4 : 1)
                }
                .padding(.horizontal, 5).padding(.vertical, 9)
            }
        }
        .padding()
        .cornerRadius(20)
    }
    
    
}

struct PublishedDetailsView: View {
    let journal: Journal
    //user data
    //TODO: add sleep attribute for date in Date extension for sleep object
    
    
    @State private var showPersonalAccount: Bool = false
    @State private var viewModel = GetNameModel()
    @State private var friendNames: [String: String] = [:]
    
    //dismiss currentenvironment
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView {
            
            VStack {
                
                ScrollView(.vertical, showsIndicators: false) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "x.square")
                            .font(.title)
                            .foregroundColor(.moonlitSerenityCharcoalGray)
                    }).position(x:340, y:40)
                    
                    
                    HStack (spacing: 5){
                        Image(systemName:"text.book.closed")
                            .font(.custom("NovaSquareSlim-Bold", size: 25)).foregroundColor(.tranquilMistMauve)
                        
                        Text(journal.journalTitle)
                            .font(.custom("NovaSquareSlim-Bold", size: 30))
                            .foregroundColor(.tranquilMistMauve)
                        
                    }.hSpacing(.leading)
                        .padding(.leading)
                        .padding(.top)
                    if currUser?.userID != journal.userId {
                        NavigationLink(destination: OtherAccountView(userID: journal.userId ?? "").navigationBarBackButtonHidden(true)) {
                            HStack {
                                Image(systemName:"person.fill")
                                    .font(.system(size: 20)).fontWeight(.medium).foregroundColor(.nightfallHarmonyNavyBlue)
                                
                                
                                Text(journal.username)
                                    .font(.system(size: 20)).fontWeight(.medium).foregroundColor(.nightfallHarmonyNavyBlue)
                                
                                
                            }
                            .hSpacing(.leading)
                            .padding(.leading)
                            .padding(.top)
                            .underline()
                        }
                    } else {
                        Button(action: {
                            showPersonalAccount.toggle()
                        }, label:{
                            HStack {
                                Image(systemName:"person.fill")
                                    .font(.system(size: 20)).fontWeight(.medium).foregroundColor(.nightfallHarmonyNavyBlue)
                                
                                
                                Text(journal.username)
                                    .font(.system(size: 20)).fontWeight(.medium).foregroundColor(.nightfallHarmonyNavyBlue)
                                
                                
                            }
                            .hSpacing(.leading)
                            .padding(.leading)
                            .padding(.top)
                            .underline()
                        })
                        
                    } 
                    HStack {
                        if !journal.journalTags.isEmpty {
                            Image(systemName: "tag.fill")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(Color.tranquilMistMauve.opacity(0.6))
                        }
                        
                        ForEach(journal.journalTags, id: \.self) { tag in
                            let ref = fetchUserData(userID: tag)
                                
                            if let friendName = friendNames[tag] {
                                if tag == currUser?.userID {
                                    Menu {
                                        Button("Remove tag?", role: .destructive) {
                                            journal.journalTags.removeAll(where: { $0 == tag })
                                            journal.updateValues(newValues: ["journalTags" : journal.journalTags]){_ in }
                                        }
                                    } label: {
                                        Text(friendName)
                                            .font(Font.custom("NovaSquareSlim-Bold", size: 20))
                                            .shadow(radius: 20)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color.tranquilMistMauve)
                                            .underline()
                                    }
                                } else {
                                    NavigationLink(destination: OtherAccountView(userID: tag).navigationBarBackButtonHidden(true)) {
                                        Text(friendName)
                                            .font(Font.custom("NovaSquareSlim-Bold", size: 20))
                                            .shadow(radius: 20)
                                            .fontWeight(.semibold)
                                            .foregroundColor(Color.tranquilMistMauve)
                                            .underline()
                                    }
                                }
                            } else {
                                Text("Loading...")
                            }
                                
                        }
                    }.hSpacing(.leading)
                    .padding()
                    
                    
                    Text(journal.journalContent)
                        .padding(.top)
                        .font(.system(size: 18)).fontWeight(.medium).foregroundColor(.moonlitSerenityCharcoalGray)
                        .padding(.leading)
                        .padding(.vertical)
                        .hSpacing(.leading)
                    
                    
                }.sheet(isPresented: $showPersonalAccount, content: {
                    AccountInfoView()
                        
                        
                        
                })
                
            }
        }
    }
    func fetchUserData(userID: String) {
        var ref: DatabaseReference = Database.database().reference().child("User")
                DispatchQueue.main.async {
                ref.child(userID).observeSingleEvent(of: .value, with: { snapshot in
                    guard let value = snapshot.value as? [String: Any] else {
                        print("Error: Could not find user")
                        return
                    }
                    if let friendName = value["name"] as? String {
                        friendNames[userID] = friendName
                    }
                
                    
                }) { error in
                    print(error.localizedDescription)
                }
                    
            }
        }

}

struct JournalDetailsView: View {
    let journal:Journal
    
    @State private var viewModel = GetNameModel()
    @State var isPublished: Bool = false
    @State var isFriends: Bool = false
    
    @State private var editedContent: String = ""
    @State private var editedTitle: String = ""
    @State private var tags: [String] = []
    
    @State private var isEditing: Bool = false
    @Environment(\.dismiss) private var dismiss
    @State private var showError: Bool = false
    @State private var publishedListener: ListenerRegistration?
    
    @State private var isDropdownOpen:Bool = false
    @State private var selectedFriends = Set<String>()
    @State private var friendNames: [String: String] = [:]



    private var journalRef: DocumentReference {
            Firestore.firestore().collection("Journal").document(journal.journalId ?? "")
        }
    
    var body: some View {
        NavigationView {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [
                .dreamyTwilightMidnightBlue,
                .dreamyTwilightMidnightBlue]),
                           startPoint: .topLeading, endPoint: .bottomLeading)
            .ignoresSafeArea()
            
                VStack {
                    HStack {
                        Button{ dismiss()
                        } label: {
                            Image(systemName:
                                    "chevron.left").hSpacing(.leading).foregroundColor(.white)
                        }.padding()
                        if !isEditing {
                            
                            Button(action:{
                                editedContent = journal.journalContent
                                editedTitle = journal.journalTitle
                                isEditing = true
                            }, label: {
                                Text("Edit").foregroundColor(.white).font(.system(size: 16, weight: .medium))
                                
                            })
                            .padding()
                            
                            Menu {
                                Button("Delete Entry", role: .destructive) {
                                    journal.deleteJournal()
                                    dismiss()
                                }
                            } label: {
                                Image(systemName: "trash").foregroundColor(.red).padding()
                            }
                            Menu {
                                Button(action: {
                                    if(journal.journalPrivacyStatus == "Private"){
                                        journal.updateValues(newValues: ["journalPrivacyStatus" : "Public"]) {_ in
                                            journal.journalPrivacyStatus = "Public"
                                        }
                                    }else {
                                        journal.updateValues(newValues: ["journalPrivacyStatus" : "Private"]) {_ in
                                            journal.journalPrivacyStatus = "Private"
                                        }
                                    }
                                }){
                                    if(!isPublished) {
                                        Text("Unpublish").font(.callout).foregroundColor(Color.red)
                                    } else {
                                        Text("Publish").font(.callout).foregroundColor(Color.black)
                                    }
                                }
                            } label : {
                                Image(systemName: "arrowshape.turn.up.right.fill").foregroundColor(.tranquilMistMauve).padding(.trailing)
                                
                            }
                            
                        } else {
                            Button("Cancel") {
                                isEditing = false
                            }
                            .padding().foregroundColor(.white)
                        }
                    }
                    Spacer()
                    ScrollView(.vertical, showsIndicators: false) {
                        if(!isPublished) {
                            Text("Published").foregroundColor(.white).font(.system(size: 12, weight: .bold))
                            
                                .padding(.leading)
                                .padding(.bottom)
                                .hSpacing(.leading)
                            
                        }
                        Text("Journal Details")
                            .font(Font.custom("NovaSquareSlim-Bold", size: 35))
                            .foregroundColor(.tranquilMistMauve)
                            .padding(.leading)
                            .hSpacing(.leading)
                        
                        
                       
                            HStack {
                                if !journal.journalTags.isEmpty {
                                    Image(systemName: "tag.fill")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(Color.tranquilMistMauve.opacity(0.6))
                                }
                                
                                ForEach(journal.journalTags, id: \.self) { tag in
                                       
                                    let ref = fetchUserData(userID: tag)
                                        
                                    if let friendName = friendNames[tag] {
                                        NavigationLink(destination: OtherAccountView(userID: tag).navigationBarBackButtonHidden(true)) {
                                            Text(friendName)
                                                .font(Font.custom("NovaSquareSlim-Bold", size: 20))
                                                .shadow(radius: 20)
                                                .fontWeight(.semibold)
                                                .foregroundColor(Color.tranquilMistMauve)
                                                .underline()
                                        }
                                    } else {
                                        Text("Loading...")
                                    }
                                    
                                    
                                }
                            }.hSpacing(.leading)
                            .padding()
                        
                        
                        if isEditing {
                            ScrollView(.vertical, showsIndicators:false) {
                                List {
                                    if currUser?.friends == [] {
                                        Text("No friends yet!")
                                    } else {
                                        ForEach(currUser?.friends ?? [], id: \.self) { friend in
                                            Button(action: {
                                                if selectedFriends.contains(friend) {
                                                    selectedFriends.remove(friend)
                                                } else {
                                                    selectedFriends.insert(friend)
                                                }
                                            }, label: {
                                                HStack {
                                                    if let friendName = friendNames[friend] {
                                                        Text(friendName)
                                                    } else {
                                                        Text("Loading...")
                                                    }
                                                    Spacer()
                                                    if selectedFriends.contains(friend) {
                                                        Image(systemName: "checkmark")
                                                    }
                                                }
                                            }).onAppear {
                                                fetchUserData(userID: friend)
                                            }
                                        }
                                    }
                                }
                                .frame(height: 100)
                                .border(Color.gray)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                                .padding()
                            }
                        }
                    

                        
                        if !isEditing {
                            TextField(journal.journalTitle, text: $editedTitle)
                                .font(.system(size: 20)).fontWeight(.bold).foregroundColor(.white)
                                .padding(.top)
                                .disabled(!isEditing)
                                .padding(.leading)
                            TextField(journal.journalContent, text: $editedContent, axis: .vertical)
                                .padding(.top)
                                .font(.system(size: 18)).fontWeight(.medium).foregroundColor(.white)
                                .disabled(!isEditing)
                                .padding(.leading)
                        } else {
                            
                            TextField(journal.journalTitle, text: $editedTitle)
                                .font(.system(size: 25)).fontWeight(.bold).foregroundColor(.white)
                                .padding()
                                .disabled(!isEditing)
                                .padding(.horizontal, 30)
                                .background(.white.opacity(0.15)).cornerRadius(10).padding()
                            
                            TextField(journal.journalContent, text: $editedContent, axis: .vertical)
                                .font(.system(size: 18)).fontWeight(.medium).foregroundColor(.white)
                                .padding()
                                .disabled(!isEditing)
                                .padding(.horizontal, 30)
                                .background(.white.opacity(0.15)).cornerRadius(10).padding()
                        }
                        
                    }
                    
                    Spacer()
                    
                    // Display editable text field only when editing mode is enabled
                    if isEditing {
                        
                        // Save button to update the journal content
                        Button("Save") {
                            journal.updateValues(newValues: ["journalTitle" : editedTitle,
                                                             "journalContent" : editedContent,
                                                             "journalTags" : Array(selectedFriends)
                                                            ]) {_ in
                                journal.journalContent = editedContent
                                journal.journalTitle = editedTitle
                                journal.journalTags = Array(selectedFriends)
                            }
                            
                            isEditing = false
                        }
                        .padding().foregroundColor(.white)
                        .buttonStyle(NoStyle1())
                        
                        
                        
                        
                        
                        
                    } else {
                        // Save button to update the journal content
                        Button("") {
                            
                        }
                        .padding()
                        
                        
                        
                    }
                    Spacer()
                }.onAppear {
                    editedContent = journal.journalContent
                    editedTitle = journal.journalTitle
                    fetchPrivacyStatus()
                    listenForPrivacyChanges()
                    fetchAllFriendIDs { friendIDs, error in
                        if let error = error {
                            // Handle error
                            print("Error fetching friend IDs: \(error.localizedDescription)")
                            return
                        }
                        
                        if let friendIDs = friendIDs {
                            currUser?.friends = friendIDs
                            
                        }
                    }
                    selectedFriends = Set(journal.journalTags)
                    
                    
                }
                .onDisappear {
                    publishedListener?.remove()
                    
                }
            }
        }
    }
    
    func fetchUserData(userID: String) {
        var ref: DatabaseReference = Database.database().reference().child("User")
                DispatchQueue.main.async {
                ref.child(userID).observeSingleEvent(of: .value, with: { snapshot in
                    guard let value = snapshot.value as? [String: Any] else {
                        print("Error: Could not find user")
                        return
                    }
                    if let friendName = value["name"] as? String {
                        friendNames[userID] = friendName
                    }
                
                    
                }) { error in
                    print(error.localizedDescription)
                }
                    
            }
        }
    private func listenForPrivacyChanges() {
        // Listener for privacy status of journal to get updates in real time
            publishedListener = journalRef.addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                
                DispatchQueue.main.async {
                            isPublished = data["journalPrivacyStatus"] as? Bool ?? false
                    selectedFriends = Set(data["journalTags"] as? [String] ?? [])
                        }
            }
        }
    private func fetchPrivacyStatus() {
            journalRef.getDocument { document, error in
                if let document = document, document.exists {
                    let data = document.data()
                    isPublished = data?["journalPrivacyStatus"] as? Bool ?? false
                } else {
                    print("Document does not exist")
                }
            }
        }
    
    func fetchAllFriendIDs(completion: @escaping ([String]?, Error?) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No authenticated user found")
            completion(nil, NSError(domain: "Auth", code: 401, userInfo: [NSLocalizedDescriptionKey: "No authenticated user found"]))
            return
        }

        let db = Firestore.firestore()
        let userFriendsRef = db.collection("FriendRequests").document(currentUserID).collection("Friends")

        // Retrieve all documents from the "Friends" collection
        userFriendsRef.getDocuments { (snapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            var friendIDs: [String] = []
            for document in snapshot!.documents {
                let friendID = document.documentID
                friendIDs.append(friendID)
            }

            completion(friendIDs, nil)
        }
    }
}


struct JournalCommentView: View {
    
    // Parameter
    @Binding var commentReply: JournalReply
    var journ: Journal
    @State private var likesListener: ListenerRegistration?
    @State private var hasChanged: Bool = false  // Change to activate change in view
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color.white)
                    .foregroundColor(.clear)
                VStack(alignment: .leading){
                    Text("@\(commentReply.authorID)")
                        .font(.system(size: 13))
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    Text("\(commentReply.getRelativeTime())")
                        .font(.system(size: 13))
                        .fontWeight(.semibold)
                        .foregroundColor(.dreamyTwilightSlateGray)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                }
                Spacer()
                Text("REPLY")
                    .foregroundColor(Color.nightfallHarmonyRoyalPurple)
                    .brightness(0.3)
                    .saturation(1.5)
            }
            .padding(.vertical, 10)
            Text("\(commentReply.replyContent)")
                .foregroundColor(.white)
                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                .padding(.bottom, 8)
            
            // Upvote & Downvote, Replies, Edit
            HStack {
                // Like Dislikes System
                HStack {
                    Button {
                        withAnimation {
                            handleLikes()
                        }
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .fontWeight(.bold)
                            .foregroundColor(commentReply.likedIDs.contains(currUser!.userID)  ? .nightfallHarmonyRoyalPurple : .white)
                            .brightness(0.3)
                            .saturation(1.5)
                    }
                    Text("\(commentReply.likedIDs.count - commentReply.dislikedIDs.count)")
                        .font(.system(size: 15))
                        .foregroundColor(.white)
                    Button {
                        withAnimation {
                            handleDislikes()
                        }
                    } label: {
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(commentReply.dislikedIDs.contains(currUser!.userID)  ? .nightfallHarmonyRoyalPurple : .white)
                            .brightness(0.3)
                            .saturation(1.5)
                            .fontWeight(.bold)
                    }
                }
                .padding(.trailing, 10)
                Spacer()
                // TODO: Implement dropdown menu for options (delete and edit)
                Image(systemName: "ellipsis")
                    .foregroundColor(.white)
            }
            .padding(.bottom, 8)
            
        }
        .listRowSeparator(.hidden)
        .onAppear {
            if likesListener == nil {
                guard commentReply.replyID != nil else { return }
                guard commentReply.parentPostID != nil else { return }
                guard currUser != nil else { return }
                print("post id: \(journ.journalId!)")
                let postRef = Firestore.firestore().collection("Journal").document(journ.journalId!).collection("Replies")
                
                /*Firestore.firestore().collection("Journal").document(journ.journalId!).collection("Replies").getDocuments { (snapshot, error) in
                    if let error = error {
                        print("Error checking Replies collection: \(error)")
                        return
                    }
                    
                    if snapshot?.isEmpty ?? true {
                        // "Replies" collection does not exist, create it by adding a dummy document
                        Firestore.firestore().collection("Journal").document(journ.journalId!).collection("Replies").addDocument(data: ["dummy": "data"]) { error in
                            if let error = error {
                                print("Error creating Replies collection: \(error)")
                                return
                            }
                            
                            // Successfully created "Replies" collection
                            print("Replies collection created successfully")
                        }
                    } else {
                        // "Replies" collection already exists
                        print("Replies collection already exists")
                    }
                }*/
                
                likesListener = postRef.document(commentReply.replyID!).addSnapshotListener { documentSnapshot, error in
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
                    // Update likes and dislikes
                    if let likes = data["likedIDs"] as? [String] {
                        commentReply.likedIDs = likes
                    }
                    if let dislikes = data["dislikedIDs"] as? [String] {
                        commentReply.dislikedIDs = dislikes
                    }
                    hasChanged.toggle()
                }
            }
        }
        .onDisappear {
            likesListener?.remove()
            likesListener = nil
        }
    }
    
    /*
     * Handle logic for likes
     */
    func handleLikes() {
        print("going in hereee??")
        guard commentReply.replyID != nil else { return }
        guard commentReply.parentPostID != nil else { return }
        guard currUser != nil else { return }
        
        if commentReply.likedIDs.contains(currUser!.userID) {
            Firestore.firestore().collection("Journal").document(commentReply.parentPostID!).collection("Replies").document(commentReply.replyID!).updateData([
                "likedIDs": FieldValue.arrayRemove([currUser!.userID])
            ])
        } else {
            Firestore.firestore().collection("Journal").document(commentReply.parentPostID!).collection("Replies").document(commentReply.replyID!).updateData([
                "likedIDs": FieldValue.arrayUnion([currUser!.userID]),
                "dislikedIDs": FieldValue.arrayRemove([currUser!.userID])
            ])
        }
    }
    
    /*
     * Handle logic for dislikes
     */
    func handleDislikes() {
        print("going in hereee??")
        guard commentReply.replyID != nil else { return }
        guard commentReply.parentPostID != nil else { return }
        guard currUser != nil else { return }
        
        if commentReply.dislikedIDs.contains(currUser!.userID) {
            Firestore.firestore().collection("Journal").document(commentReply.parentPostID!).collection("Replies").document(commentReply.replyID!).updateData([
                "dislikedIDs": FieldValue.arrayRemove([currUser!.userID])
            ])
        } else {
            Firestore.firestore().collection("Journal").document(commentReply.parentPostID!).collection("Replies").document(commentReply.replyID!).updateData([
                "dislikedIDs": FieldValue.arrayUnion([currUser!.userID]),
                "likedIDs": FieldValue.arrayRemove([currUser!.userID])
            ])
        }
    }
}


struct NoStyle1: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
    }
}

#Preview {
    JournalView()
}


 
