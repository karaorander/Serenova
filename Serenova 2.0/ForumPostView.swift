//
//  ForumPostView.swift
//  Serenova 2.0
//
//  Created by Ava Schrandt on 2/24/24.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage

//Create New Post View
struct ForumPostView: View {
    /// callback
    //var onPos: (Post)->()
    

        
    @State var postText: String
    @State var postTitle: String
    @State var postImageData: Data?
    @State var postImageURL: URL?
    
    ///use app storage to get user data from firebase.  EX:
    //@AppStorage("userName") var userName: String = ""
    @State private var isLoading:Bool = false
    @State private var showError:Bool = false
    @State private var showCamera:Bool = false
    @State private var errorMess: String = ""
    @State private var showImagePicker: Bool = false
    @State private var selectedPhoto: PhotosPickerItem?
    @FocusState private var showkeyboard: Bool
    
    @State private var isCreatingPost: Bool = false
    @State private var isPosted: Bool = false
    
    @State var tagOptions: [String] = ["None", "Questions", "Tips", "Hacks", "Support", "Goals", "Midnight Thoughts"]
    @State private var tagOption: Int = 0
    @State private var showTagOptions: Bool = false
    
    @State private var isDropdownOpen:Bool = false
    @State private var selectedFriends = Set<String>()
    @State private var friendNames: [String: String] = [:]
    
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView{
            ZStack {
                LinearGradient(gradient: Gradient(colors: [
                    .nightfallHarmonyRoyalPurple.opacity(0.7),
                    .dreamyTwilightMidnightBlue.opacity(0.7),
                    .dreamyTwilightOrchid]),
                     startPoint: .topLeading, endPoint: .bottomLeading)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Menu {
                            Button("Delete Post", role: .destructive) {
                                dismiss()
                            }
                        } label: {
                            Text("Cancel").font(.callout).foregroundColor(Color.dreamyTwilightOrchid)
                        }
                        NavigationLink ("", destination: ForumView().navigationBarBackButtonHidden(true), isActive: $isPosted)
                        Spacer()
                        Button(action: {
                            createPost()
                            isCreatingPost = true
                        }) {
                            Text("Post").font(.callout)
                                .foregroundColor(.dreamyTwilightOrchid)
                                .padding(.horizontal,20)
                                .padding(.vertical, 6)
                                .background(.white, in: Capsule())
                        }
                        .disabled(postText == "" || postTitle == "")
                        .opacity((postText == "" || postTitle == "") ? 0.4 : 1)
                    }.padding(.horizontal, 15).padding(.vertical, 10)
                    ScrollView(.vertical, showsIndicators:false) {
                        VStack(spacing: 15){
                            HStack {
                                TextField("Title", text: $postTitle)
                                    .fontWeight(.bold)
                                    .focused($showkeyboard)
                            }.padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                            // Tags
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
                            }
                            HStack {
                                Button(action: {
                                    isDropdownOpen.toggle() // toggle the dropdown
                                }, label: {
                                    HStack {
                                        Image(systemName: "tag.fill")
                                            .font(.system(size: 20, weight: .medium))
                                            .foregroundColor(.tranquilMistMauve.opacity(0.6))
                                        Text("Tag Friends")
                                            .font(.system(size: 20, weight: .medium))
                                            .foregroundColor(.tranquilMistMauve.opacity(0.6))
                                    }
                                })
                            }.hSpacing(.leading)
                            .padding()
                                
                                           
                            if isDropdownOpen {
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
                            HStack {
                                TextField("Share sleep exeriences + tips!", text: $postText, axis: .vertical)
                                    .focused($showkeyboard)
                                    .frame(minHeight: 150, alignment: .top)
                            }.padding()
                                .foregroundColor(.black)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                        }.padding(15)
                            if let postImageData, let image = UIImage(data: postImageData) {
                                GeometryReader{
                                    let size = $0.size
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width:size.width, height: size.height)
                                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                        .overlay(alignment: .topTrailing) {
                                            Button {
                                                withAnimation(.easeInOut(duration:0.25)) {
                                                    self.postImageData = nil
                                                }
                                            } label: {
                                                Image(systemName: "trash").font(.system(size: 20, weight: .bold))
                                                    .foregroundColor(.red)
                                                    .background(.white.opacity(0.5)).cornerRadius(5)
                                            }
                                            .padding(10)
                                        }
                                    
                                }.clipped()
                                    .frame(height: 220)
                            } else {
                                Spacer()
                                Button {
                                    showImagePicker.toggle()
                                }label : {
                                    Image(systemName: "photo")
                                        .foregroundColor(.soothingNightLightGray)
                                        .font(.system(size: 200))
                                        .background(.white.opacity(0.1))
                                        .cornerRadius(10)
                                        
                                }.hSpacing(.center).vSpacing(.center)
                                
                            }
                    }
                    .sheet(isPresented: $showTagOptions, content: {
                        TagOptionsView(tagOption: $tagOption)
                            .padding(.horizontal, 25)
                            .presentationDetents([.fraction(0.55)])
                    })
                    Divider()
                    HStack {
                        Button {
                            showImagePicker.toggle()
                        }label : {
                            Image(systemName: "photo.badge.plus")
                                .font( .title3)
                                .foregroundColor(.white)
                        }.hSpacing(.leading)
                        Button("Done") {
                            showkeyboard = false
                        }.foregroundColor(.white)
                    }.padding(.horizontal, 15).padding(.vertical, 10)
                }.vSpacing(.top)
                    .photosPicker(isPresented: $showImagePicker, selection: $selectedPhoto)
                    .onChange(of: selectedPhoto) { newValue in
                        if let newValue {
                            Task{
                                if let rawImageData = try? await newValue.loadTransferable(type: Data.self), let image = UIImage(data: rawImageData), let compressedImageData = image.jpegData(compressionQuality: 0.5) {
                                    await MainActor.run(body: {
                                        postImageData = compressedImageData
                                        selectedPhoto = nil
                                    })
                                }
                            }
                        }
                    }
                    //.alert(errorMess, isPresented: $showImagePicker, actions: {})
                    .alert(
                        "Post Creation Failure",
                        isPresented: $showError
                    ) {
                        Button("OK") {}
                    } message: {
                        Text(errorMess)
                    }
                /*
                    if isCreatingPost {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .tint(.white)
                            .scaleEffect(2)
                    }
                 */
                }

        }.onAppear {
            fetchAllFriendIDs { friendIDs, error in
                if let error = error {
                    // Handle error
                    print("Error fetching friend IDs: \(error.localizedDescription)")
                    return
                }
                
                if let friendIDs = friendIDs {
                    currUser?.friends = friendIDs
                    print("Friend IDs retrieved successfully: \(friendIDs)")
                }
            }

        }
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
    
    func createPost() {
        showkeyboard = false
        isLoading = true

        Task {
            do {
                // TESTING IN PREVIEW MODE:
                // Comment out the guard below and use
                // the second constructor for Post (uncomment it)
                
                guard currUser != nil else {
                    await errorAlerts("ERROR! Not signed in.")
                    return
                }
                

                // Create new Post Object
                //var newPost = Post(title: postTitle, content: postText
                                   //authorUsername: currUser.username,
                                   //authorID: currUser.userID,
                                   //authorProfilePhoto: currUser.profileURL)
                
                let newPost = Post(title: postTitle, content: postText, tag: tagOptions[tagOption], userTags: Array(selectedFriends))
                
                // Store Image & Get DownloadURL
                if postImageData != nil {
                    // Completion block for uploading image
                    try await storeImage()
                    
                    // Set imageURL of Post
                    guard let postImageURL = postImageURL else {
                        await errorAlerts("Failed to upload photo.")
                        return
                    }
                    newPost.imageURL = postImageURL
                            
                    // Save post to Firebase (media)
                    try await newPost.createPost()
                    isPosted = true
                } else {
                    // Save post to Firebase (no media)
                    try await newPost.createPost()
                    isPosted = true
                }
                
            } catch {
                await errorAlerts(error)
            }
        }
    }
    
    /*
     * Function to store image in Firebase Storage
     */
    func storeImage() async throws {
        //Create reference to postMedia bucket
        let storageRef = Storage.storage().reference()
        
        // Create a reference to the file you want to upload
        let postImageRef = storageRef.child("postMedia/\(UUID().uuidString).jpg")

        // Upload image
        if let postImageData = postImageData {
            let _ = try await postImageRef.putDataAsync(postImageData)
            try await postImageURL = postImageRef.downloadURL()
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


#Preview {
    ForumPostView(postText: "", postTitle: "")
}
