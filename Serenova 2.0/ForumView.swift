//
//  ForumView.swift
//  Serenova 2.0
//
//  Created by Cristina Corley on 2/27/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

struct ForumView: View {
    
    @State private var forumPosts: [Post] = []
    @State private var queryNum: Int = 25
    @State private var lastPost: DocumentSnapshot?
    
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
                        
                    if forumPosts.count == 0 {
                        NoPostsView()
                    } else {
                        List {
                            ForEach(forumPosts.indices, id: \.self) { index in
                                PostListingView(post: forumPosts[index])
                                    .onAppear {
                                        if index == forumPosts.count - 1 && lastPost != nil {
                                            Task {
                                                await queryPosts(NUM_POSTS: queryNum)
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
                        .padding(8)
                        .listRowSpacing(5)
                        .listStyle(PlainListStyle())
                        .scrollIndicators(ScrollIndicatorVisibility.hidden)
                        .refreshable {
                            Task {
                                forumPosts = []
                                lastPost = nil
                                await queryPosts(NUM_POSTS: queryNum)
                            }
                        }
                    }

                    HStack(content: {
                        //NavigationLink(destination: NotificationsView().navigationBarBackButtonHidden(true)) {
                            Image(systemName: "bell.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                        //}.isDetailLink(false)
                        
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
            .onAppear() {
                UIRefreshControl.appearance().tintColor = .white
                Task {
                    if forumPosts.count == 0 {
                        //await queryPosts(NUM_POSTS: queryNum)
                    }
                }
            }
        }
    }
    
    /*
     * Retrieves posts from Firebase
     */
    func queryPosts(NUM_POSTS: Int) async {
        // Database Reference
        let db = Firestore.firestore()
        
        do {
            // Fetch batch of posts from Firestore
            var query: Query! = db.collection("Posts")
                .order(by: "timeStamp", descending: true)
                .limit(to: NUM_POSTS)
            
            if let lastPost = lastPost {
                query = query.start(afterDocument: lastPost)
            }
            
            // Retrieve documents
            let postBatch = try await query.getDocuments()
            let newPosts = postBatch.documents.compactMap { post -> Post? in
                try? post.data(as: Post.self)
            }
            
            await MainActor.run(body: {
                forumPosts += newPosts
                lastPost = postBatch.documents.last
            })
            
        } catch {
            print (error.localizedDescription)
        }
        return
    }
}

struct NoPostsView: View {
    
    var body: some View {
        VStack (alignment: .center){
            Spacer()
            Image(systemName: "moon.stars.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.white)
                .padding()
            Text("No Posts Yet")
                .foregroundColor(.white)
                .font(.system(size: 30))
                .fontWeight(.semibold)
            Spacer()
        }
    }
}

struct PostListingView: View {
    
    let post: Post
    
    @State private var postImage: UIImage?
    @State private var isClicked: Bool = false

    var body: some View {
        Button (action: {isClicked = true}) {
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
                        Text("\(post.getRelativeTime())")
                            .font(.system(size: 13))
                            .fontWeight(.semibold)
                            .foregroundColor(.dreamyTwilightSlateGray)
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    }
                }
                .padding(.vertical, 10)
            
                // Post preview content
                Text(post.title)
                    .font(.custom("NovaSquareSlim-Bold", size: 20))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color.nightfallHarmonyRoyalPurple)
                    .padding(.bottom, 2)
                    .brightness(0.3)
                    .saturation(1.5)
                // Limit word count of preview to: 50 characters
                if post.content.count <= 55 {
                    Text(post.content)
                        .foregroundColor(.white)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .padding(.bottom, 8)
                } else {
                    Text(post.content.prefix(55) + "...")
                        .foregroundColor(.white)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .padding(.bottom, 8)
                }
                
                if let imageURL = post.imageURL {
                    let _ = self.loadImage(imageURL: imageURL)
                    
                    if let postImage = postImage {
                        Image(uiImage: postImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 330, height: 250)
                            .cornerRadius(10)
                            .padding(.horizontal, 0).padding(.bottom, 8)
                            .clipped()
                    } else {
                        Image(systemName: "rectangle.fill")
                            .resizable()
                            .frame(width: 330, height: 250)
                            .foregroundColor(Color.white.opacity(0.1))
                            .cornerRadius(10)
                            .padding(.horizontal, 0).padding(.bottom, 8)
                    }
                }
                
                // Upvote & Downvote, Replies, Edit
                HStack {
                    HStack {
                        Image(systemName: "arrow.up.circle.fill")
                            .fontWeight(.bold)
                        Text("4.6k")
                            .font(.system(size: 15))
                        Image(systemName: "arrow.down.circle.fill")
                            .fontWeight(.bold)
                    }
                    .padding(.trailing, 10)
                    
                    Image(systemName: "arrowshape.turn.up.right.fill")
                    Text("2.3k")
                        .font(.system(size: 15))
                    
                    Spacer()
                    
                    // TODO: Implement dropdown menu for options
                    Image(systemName: "ellipsis")
                }
                .padding(.bottom, 8)
            }
        }
        .buttonStyle(NoStyle())
        .listRowSeparator(.hidden)
        // TODO: Link to Post page
        //NavigationLink(destination: ForumPostView().navigationBarBackButtonHidden(true))
    }
    
    /*
     * Function to load images from Firebase Storage
     */
    func loadImage(imageURL: URL) {
        let storageRef = Storage.storage().reference(forURL: imageURL.absoluteString)
        
        // Create a reference to the file you want to upload
        //let postImageRef = storageRef.child(forURL: imageURL.absoluteString)

        // Fetch image
        storageRef.getData(maxSize: Int64(5 * 1024 * 1024)) { data, error in
            if let error = error {
                print(error)
                return
            } else {
                let retrievedImage = UIImage(data: data!)
                DispatchQueue.main.async {
                    postImage = retrievedImage
                }
            }
        }
    }
}

struct NoStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
    }
}

#Preview {
    ForumView()
}
