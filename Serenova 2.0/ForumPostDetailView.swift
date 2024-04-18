//
//  ForumPostDetailView.swift
//  Serenova 2.0
//
//  Created by Cristina Corley on 3/17/24.
//
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ForumPostDetailView: View {
   
    @Binding var post: Post
    @State private var isReplyWindowOpen = false
    @State var replies: [Reply] = []
    @State var reply: String = ""
    @State private var showError:Bool = false
    @State private var errorMess: String = ""
    @State private var queryNum: Int = 25
    @State private var lastReply: DocumentSnapshot?
    @State private var permission: Bool = false
    @State var deletedPost = false;
    
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
                        Text("Post")
                            .font(Font.custom("NovaSquareSlim-Bold", size: 35))
                            .foregroundColor(.white)
                            .padding(.trailing)
                        Spacer()
                        
                        
                        if checkPermissions() {
                            Button {
                                //Delete post and dismiss
                                deletePost(post : post)
                                deletedPost = true;
                            } label: {
                                Image(systemName: "trash")
                                    .resizable()
                                    .frame(width: 20, height: 25)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding()
                    .padding(.horizontal, 15)
                    List {
                        PostListingView(isFullView: true, post: $post)
                            .padding(5)
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.soothingNightDeepIndigo)
                            )
                        if replies.count > 0 {
                            ForEach(replies.indices, id: \.self) { index in
                                CommentView(commentReply: $replies[index])
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
                    }
                    .padding(8)
                    .listRowSpacing(5)
                    .listStyle(PlainListStyle())
                    .background(Color.clear)
                    .scrollIndicators(ScrollIndicatorVisibility.hidden)
                    .refreshable {
                        Task {
                            replies = []
                            lastReply = nil
                            await queryReplies(NUM_REPLIES: queryNum)
                        }
                    }
                    if replies.count == 0 {
                        NoRepliesView()
                    }
                    Spacer()
                    AddReplyView()
                }
            }
        }
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
        .background(
            NavigationLink(destination: ForumView().navigationBarBackButtonHidden(), isActive: $deletedPost) {
                ForumView()
            }
                .hidden()
        )
    }
    
    //error handling -> error alerts
    func errorAlerts(_ error: Error)async{
        await MainActor.run(body: {
            errorMess = error.localizedDescription
            showError.toggle()
        })
    }
    
    //error handling -> error alerts (String version)
    func errorAlerts(_ error: String)async{
        await MainActor.run(body: {
            errorMess = error
            showError.toggle()
        })
    }
    
    func checkPermissions() -> Bool {
        var userID: String = ""
        if ((Auth.auth().currentUser) != nil) {
            userID = Auth.auth().currentUser!.uid
        }
        
        if (userID == post.authorID) {
            return true
        } else {
            return false
        }
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
    
    /*
     * Function to create a reply for the post
     */
    func createReply() {
        Task {
            do {
                guard currUser != nil else { return }
                // Save post to Firebase
                let newReply = Reply(replyContent: reply, parentPostID: post.postID!)
                try await newReply.createReply()
                replies.append(newReply)
                reply = ""
            } catch {
                await errorAlerts(error)
            }
        }
    }
    
    /*
     * Retrieves replies from Firebase
     */
    func queryReplies(NUM_REPLIES: Int) async {
        // Database Reference
        let db = Firestore.firestore()
        
        do {
            // Check for nils
            guard post.postID != nil else { return }
            guard currUser != nil else { return }
            // Fetch batch of posts from Firestore
            var query: Query! = db.collection("Posts").document(post.postID!).collection("Replies")
                .order(by: "timeStamp", descending: false)
                .limit(to: NUM_REPLIES)
            
            if let lastReply = lastReply {
                query = query.start(afterDocument: lastReply)
            }
            
            // Retrieve documents
            let replyBatch = try await query.getDocuments()
            let newReplies = replyBatch.documents.compactMap { post -> Reply? in
                try? post.data(as: Reply.self)
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
    
    func deletePost(post: Post) {
        let db = Firestore.firestore()
           
           // Reference to the user's "friends" collection
        let postCollectionRef = db.collection("Posts").document(post.postID!)
           
           // Delete the friend document
           postCollectionRef.delete { error in
               if let error = error {
                   print("Error removing post from Firestore: \(error)")
               } else {
                   print("Post removed successfully from Firestore")
               }
           }
    }
}

struct NoRepliesView: View {
    var body: some View {
        VStack (alignment: .center){
            Spacer()
            Image(systemName: "moon.stars.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
                .padding()
            Text("No Replies Yet")
                .foregroundColor(.white)
                .font(.system(size: 20))
                .fontWeight(.semibold)
            Spacer()
            Spacer()
        }
    }
}

struct CommentView: View {
    
    // Parameter
    @Binding var commentReply: Reply
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
                    Text("@username")
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
                
                let postRef = Firestore.firestore().collection("Posts").document(commentReply.parentPostID!).collection("Replies")
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
            Firestore.firestore().collection("Posts").document(commentReply.parentPostID!).collection("Replies").document(commentReply.replyID!).updateData([
                "likedIDs": FieldValue.arrayRemove([currUser!.userID])
            ])
        } else {
            Firestore.firestore().collection("Posts").document(commentReply.parentPostID!).collection("Replies").document(commentReply.replyID!).updateData([
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
            Firestore.firestore().collection("Posts").document(commentReply.parentPostID!).collection("Replies").document(commentReply.replyID!).updateData([
                "dislikedIDs": FieldValue.arrayRemove([currUser!.userID])
            ])
        } else {
            Firestore.firestore().collection("Posts").document(commentReply.parentPostID!).collection("Replies").document(commentReply.replyID!).updateData([
                "dislikedIDs": FieldValue.arrayUnion([currUser!.userID]),
                "likedIDs": FieldValue.arrayRemove([currUser!.userID])
            ])
        }
    }
}

struct ForumPostDetailView_Preview: PreviewProvider {
    static var previews: some View {
        @State var samplePost = Post(title: "Sample Post",
                                     content: "Zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz\n" +
                                              "Zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz\n" +
                                              "Zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz\n" +
                                     "Zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz\n", userTags: [])
        
        samplePost.postID = "1"
        return ForumPostDetailView(post: $samplePost)
    }
}
