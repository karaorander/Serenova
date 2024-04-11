//
//  CreateConversationView.swift
//  Serenova 2.0
//
//  Created by Wilson, Caitlin Vail on 4/10/24.
//

import Foundation
import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage


class CreateConvoViewModel: ObservableObject  {
    @Published var fullname = ""
    @Published var username = ""

    func fetchUsername(completion: @escaping () -> Void) {
        let db = Database.database().reference()
        let id = Auth.auth().currentUser!.uid
        let ur = db.child("User").child(id)
        
        ur.observe(.value) { snapshot,arg  in
            guard let userData = snapshot.value as? [String: Any] else {
                print("Error fetching data")
                return
            }
            
            // Extract additional information based on your data structure
            if let fullname = userData["name"] as? String {
                self.fullname = fullname
            }
            if let username = userData["username"] as? String {
                self.username = username
            }
     
            self.objectWillChange.send()
                            
                            // Call the completion closure to indicate that data fetching is completed
                            completion()
        }
    }
}

private var viewModel = AccountInfoViewModel()

//Create New Conversation View
struct CreateConversationView: View {
    /// callback
    //var onPos: (Post)->()
    

        
    @State var messageText: String = ""
    @State var messageReceiver: String = ""
    @State var messageImageData: Data?
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
    

    @State private var tagOption: Int = 0
    @State private var showTagOptions: Bool = false
    
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
                            Button("Delete Conversation", role: .destructive) {
                                dismiss()
                            }
                        } label: {
                            Text("Cancel").font(.callout).foregroundColor(Color.dreamyTwilightOrchid)
                        }
                        NavigationLink ("", destination: ConversationListView().navigationBarBackButtonHidden(true))
                        Spacer()
                        Button(action: {
                            //createPost()
                            createConversation()
                            //isCreatingPost = true
                        }) {
                            Text("Send").font(.callout)
                                .foregroundColor(.dreamyTwilightOrchid)
                                .padding(.horizontal,20)
                                .padding(.vertical, 6)
                                .background(.white, in: Capsule())
                        }
                        .disabled(messageText == "" || messageReceiver == "")
                        .opacity((messageText == "" || messageReceiver == "") ? 0.4 : 1)
                    }.padding(.horizontal, 15).padding(.vertical, 10)
                    ScrollView(.vertical, showsIndicators:false) {
                        VStack(spacing: 15){
                            HStack {
                                TextField("To: ", text: $messageReceiver)
                                    .fontWeight(.bold)
                                    .focused($showkeyboard)
                            }.padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                            HStack {
                                TextField("Let's chat!", text: $messageText, axis: .vertical)
                                    .focused($showkeyboard)
                                    .frame(minHeight: 150, alignment: .top)
                            }.padding()
                                .foregroundColor(.black)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                        }.padding(15)
                            if let messageImageData, let image = UIImage(data: messageImageData) {
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
                                                    self.messageImageData = nil
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
                                        messageImageData = compressedImageData
                                        selectedPhoto = nil
                                    })
                                }
                            }
                        }
                    }
                    //.alert(errorMess, isPresented: $showImagePicker, actions: {})
                    .alert(
                        "Conversation Creation Failure",
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
    
    func createConversation() {
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
                var allParticipants: [String] = []
                
                allParticipants.append(viewModel.username)
                //allParticipants.append(<#T##newElement: Any##Any#>)
                let newConversation = Conversation(participants: allParticipants)
                
                // Store Image & Get DownloadURL
                if messageImageData != nil {
                    // Completion block for uploading image
                    try await storeImage()
                    
                    // Set imageURL of Post
                    guard let postImageURL = postImageURL else {
                        await errorAlerts("Failed to upload photo.")
                        return
                    }
                    //newMessage.imageURL = postImageURL
                            
                    // Save post to Firebase (media)
                    //try await newMessage.createPost()
                    //isPosted = true
                } else {
                    // Save post to Firebase (no media)
                    //try await newMessage.createPost()
                    //isPosted = true
                }
                
            } catch {
                await errorAlerts(error)
            }
        }
        
    }
    
    /*
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
                
                let newMessage = Post(title: messageReceiver, content: messageText)
                
                // Store Image & Get DownloadURL
                if messageImageData != nil {
                    // Completion block for uploading image
                    try await storeImage()
                    
                    // Set imageURL of Post
                    guard let postImageURL = postImageURL else {
                        await errorAlerts("Failed to upload photo.")
                        return
                    }
                    newMessage.imageURL = postImageURL
                            
                    // Save post to Firebase (media)
                    try await newMessage.createPost()
                    isPosted = true
                } else {
                    // Save post to Firebase (no media)
                    try await newMessage.createPost()
                    isPosted = true
                }
                
            } catch {
                await errorAlerts(error)
            }
        }
    }
    */
    
    /*
     * Function to store image in Firebase Storage
     */
    func storeImage() async throws {
        //Create reference to postMedia bucket
        let storageRef = Storage.storage().reference()
        
        // Create a reference to the file you want to upload
        let messageImageRef = storageRef.child("postMedia/\(UUID().uuidString).jpg")

        // Upload image
        if let messageImage = messageImageData {
            let _ = try await messageImageRef.putDataAsync(messageImage)
            try await postImageURL = messageImageRef.downloadURL()
        }
    }
    
}


#Preview {
    ForumPostView()
}
