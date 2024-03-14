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
    
    @State var postText: String = ""
    @State var postTitle: String = ""
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
    
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView{
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [.nightfallHarmonySilverGray.opacity(0.9), .nightfallHarmonyRoyalPurple.opacity(0.5), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Menu {
                            Button("Delete Post", role: .destructive) {
                                dismiss()
                            }
                        } label: {
                            Text("Cancel").font(.callout).foregroundColor(Color.nightfallHarmonyNavyBlue)
                        }.hSpacing(.leading)
                        NavigationLink ("", destination: ForumView().navigationBarBackButtonHidden(true), isActive: $isPosted)
                        Button(action: {
                            createPost()
                            isCreatingPost = true
                        }) {
                            Text("Post").font(.callout)
                                .foregroundColor(.nightfallHarmonyNavyBlue)
                                .padding(.horizontal,20)
                                .padding(.vertical, 6)
                                .background(.white, in: Capsule())
                        }
                        .disabled(postText == "" || postTitle == "")
                        .opacity((postText == "" || postTitle == "") ? 0.4 : 1)
                    }.padding(.horizontal, 15).padding(.vertical, 10)
                        .background{
                            Rectangle()
                                .fill(.white.opacity(0.1))
                                .ignoresSafeArea()
                        }
                    ScrollView(.vertical, showsIndicators:false) {
                        VStack(spacing: 15){
                            HStack {
                                TextField("Title:", text: $postTitle)
                                    .fontWeight(.bold)
                                    
                                    .focused($showkeyboard)
                            }.padding()
                                .background(.gray.opacity(0.15))
                                .cornerRadius(10)
                            HStack {
                                TextField("Share sleep exeriences + tips!", text: $postText, axis: .vertical)
                                    .focused($showkeyboard)
                            }.padding()
                                .background(.gray.opacity(0.15))
                                .cornerRadius(10)
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
                                        
                                }.hSpacing(.center)
                                    .vSpacing(.center)
                                    
                                
                                    
                            }
                        }.padding(15)
                        
                    }
                    Divider()
                    HStack {
                        Button {
                            showImagePicker.toggle()
                        }label : {
                            Image(systemName: "photo.badge.plus")
                                .font( .title3)
                                .foregroundColor(.black)
                        }.hSpacing(.leading)
                        Button("Done") {
                            showkeyboard = false
                        }.foregroundColor(.white)
                    }.padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background{
                            Rectangle()
                                .fill(.white.opacity(0.1))
                                .ignoresSafeArea()
                        }
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
                
                guard let currUser = currUser else {
                    await errorAlerts("ERROR! Not signed in.")
                    return
                }
                
                // Create new Post Object
                //var newPost = Post(title: postTitle, content: postText
                                   //authorUsername: currUser.username,
                                   //authorID: currUser.userID,
                                   //authorProfilePhoto: currUser.profileURL)
                
                var newPost = Post(title: postTitle, content: postText)
                
                // Store Image & Get DownloadURL
                if let postImageData = postImageData {
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
            try await postImageRef.putDataAsync(postImageData)
            try await postImageURL = postImageRef.downloadURL()
        }
    }
}


#Preview {
    ForumPostView()
}
