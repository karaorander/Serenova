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
    @State private var queryNum: Int = 3
    @State private var lastPostID: String?
    
    @State private var isInitialized: Bool = false
    
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
                            .foregroundColor(.white)
                        
                        Spacer(
                        )
                        
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
                        
                    if forumPosts.count == 0 {
                        NoPostsView()
                    } else {
                        ScrollView(.vertical, showsIndicators:false) {
                            LazyVStack(spacing: 1) {
                                ForEach(forumPosts.indices.reversed(), id: \.self) { index in
                                    PostListingView(post: forumPosts[index])
                                }
                            }
                        }
                        .refreshable {
                            //await queryPosts(NUM_POSTS: queryNum)
                        }
                    }


                    HStack(content: {
                        
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
                        }.isDetailLink(false)
                        
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
            .onAppear() {
                UIRefreshControl.appearance().tintColor = .white
                Task {
                    await queryPosts(NUM_POSTS: queryNum)
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
        
        let initialQuery =  db.collection("Posts")
            .order(by: "timeStamp")
            .limit(toLast: NUM_POSTS)
        
        initialQuery.addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error retreving cities: \(error.debugDescription)")
                return
            }

            guard let lastSnapshot = snapshot.documents.last else {
                // The collection is empty.
                return
            }
            
            print(forumPosts)

            // Handle changes
            snapshot.documentChanges.forEach { diff in
                
                if (diff.type == .added) {
                    print("ADDED")
                    do {
                        let newPost = try diff.document.data(as: Post.self)
                        forumPosts.append(newPost)
                        print(forumPosts)
                    } catch {
                        print(error)
                        return
                    }
                    
                }
                if (diff.type == .modified) {
                    print("MODIFIED")
                    do {
                        let modifiedPost = try diff.document.data(as: Post.self)
                        if let index = forumPosts.firstIndex(where: {$0.postID == diff.document.documentID}) {
                            forumPosts[index] = try diff.document.data(as: Post.self)
                        }
                    } catch {
                        print(error)
                        return
                    }
                }
                if (diff.type == .removed) {
                    print("REMOVED")
                    forumPosts.removeAll { $0.postID == diff.document.documentID }
                }
            }
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
    
    @State private var hearted: Bool = false
    @State private var postImage: UIImage?
    
    @State private var isClicked: Bool = false

    var body: some View {
        Button (action: {isClicked = true}) {
            ZStack {
                Rectangle()
                    .fill(Color.white)
                    .ignoresSafeArea()
                    .padding(.horizontal, 10).padding(.vertical, 2)
                HStack(alignment: .top) {
                    // TODO: Include User profile photos
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color.white)
                        .background(
                            Circle()
                                .fill(Color.nightfallHarmonyRoyalPurple.opacity(1))
                                .ignoresSafeArea()
                                .frame(width: 40, height: 40)
                                .cornerRadius(10)
                        )
                        .padding(.top, 10).padding(.horizontal, 5)
                    
                    Spacer()
                    
                    // Post preview content
                    VStack(alignment: .leading) {
                        
                        HStack {
                            Text(post.title)
                                .font(.custom("NovaSquareSlim-Bold", size: 20))
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .foregroundColor(Color.black)
                                .frame(width: 250, alignment: .leading)
                            Button(action:{hearted.toggle()}){
                                Image(systemName: hearted ? "heart.fill" : "heart")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(hearted ? Color.red : Color.nightfallHarmonyRoyalPurple)
                            }
                        }
                        
                        HStack(){
                            Text("@username")
                                .font(.system(size: 13))
                                .fontWeight(.semibold)
                                .foregroundColor(Color.nightfallHarmonyRoyalPurple)
                                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 5, height: 5)
                                .foregroundColor(Color.nightfallHarmonyRoyalPurple)
                            Text("\(post.getRelativeTime())")
                                .font(.system(size: 13))
                                .fontWeight(.semibold)
                                .foregroundColor(Color.nightfallHarmonyRoyalPurple)
                                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        }
                        
                        // Limit word count of preview to: 50 characters
                        if post.content.count <= 55 {
                            Text(post.content)
                                .foregroundColor(.black)
                                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        } else {
                            Text(post.content.prefix(55) + "...")
                                .foregroundColor(.black)
                                .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        }
                        
                        if let imageURL = post.imageURL {
                            let _ = self.loadImage(imageURL: imageURL)
                            
                            if let postImage = postImage {
                                Image(uiImage: postImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: .infinity)
                                    .cornerRadius(10)
                            }
                        }
                        
                    }
                    .padding(.trailing)
                    .frame(width: 290)
                    .fixedSize(horizontal: false, vertical: true)
                    
                    //Spacer()
                    
                }
                .padding()
                .padding(.horizontal, 10)
                
                //Spacer()
            }
            .background(Color.clear)
        }
        .buttonStyle(NoStyle())
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
