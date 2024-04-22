//
//  MessagingView.swift
//  Serenova 2.0
//
//  Created by Ishwarya Samavedhi on 4/19/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import _PhotosUI_SwiftUI

struct MessagingView: View {
    
    let convoID: String
    
    @State private var selectedJournal: Journal?
    @State var replies: [MessageReply] = []
    @State var reply: String = ""
    @State private var isReplying: Bool = false
    @State private var replyContent: String = ""
    @State private var showError: Bool = false
    @State private var errorMess: String = ""
    @State private var queryNum: Int = 25
    @State private var lastReply: DocumentSnapshot?
    @State private var imageURL: URL?
    @State private var imageData: Data?
    @State var selectedPhoto: PhotosPickerItem?
   
    @State private var showImagePicker: Bool = false
    
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(gradient: Gradient(colors: [.nightfallHarmonySilverGray.opacity(0.9), .nightfallHarmonyRoyalPurple.opacity(0.5), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    ScrollView(.vertical, showsIndicators: false) {
                    HStack {
                        NavigationLink(destination: ConversationListView().navigationBarBackButtonHidden(true)) {
                            
                            Image(systemName: "chevron.backward")
                               
                               
                                .foregroundColor(.white)
                            
                        }.padding(.leading)
                        Text("Chat") // Title
                            .font(.custom("NovaSquare-Bold", size: 30)) // Set custom font
                            .foregroundColor(.white)
                            .padding(.top, 20)
                            .padding(.bottom, 10)
                            
                            .hSpacing(.center)
                    }.vSpacing(.top)
                    
                        if replies.count > 0 {
                            ForEach(replies.indices, id: \.self) { index in
                                MessageCommentView(commentReply: $replies[index])
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
                    
                    Button(action: {
                        isReplying.toggle()
                    }) {
                        Text("Message")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding()
                    }
                    if isReplying {
                        AddReplyView()
                            .padding()
                    }
                }
                .onAppear() {
                    UIRefreshControl.appearance().tintColor = .white
                    Task {
                        print("in here???")
                        // Prevents crash but data will not be loaded
                        // Need to run in simulator
                        if replies.count == 0 && currUser != nil {
                            print("in HERE???")
                            await queryReplies(NUM_REPLIES: queryNum)
                        }
                    }
                }
            }
        }
    }
    
    
    func createReply() {
        print("tracking prog444")
        Task {
            do {
                print("in the do")
                guard currUser != nil else {
                    print("nil")
                    return
                    
                }
                // Save post to Firebase
                if let user = currUser {
                    let newReply = MessageReply(replyContent: reply, otherID: convoID, authorID: user.name, writerID: user.userID)
                    
                    print("content: \(reply) and \(newReply.authorID)")
                    if (newReply.replyContent == "" && imageData == nil) {
                        return
                    }
                    
                    if imageData != nil {
                        // Completion block for uploading image
                        try await storeImage()
                        
                        // Set imageURL of Post
                        guard let imageURL = imageURL else {
                            await errorAlerts("Failed to upload photo.")
                            return
                        }
                        newReply.imageURL = imageURL
                        
                        // Save post to Firebase (media)
                        try await newReply.createReply()
                        // UPDATE PREVIEW
                        let convoCollectionRef = Firestore.firestore().collection("Conversations").document(convoID)
                        try await convoCollectionRef.updateData([
                            "mostRecentMessage": newReply.replyContent,
                            "mostRecentTimestamp": newReply.timeStamp
                        ])
                        replies.append(newReply)
                        print("reply appenededed.")
                        reply = ""
                        self.imageData = nil
                        //isPosted = true
                    } else {
                        // Save post to Firebase (no media)
                        try await newReply.createReply()
                        // UPDATE PREVIEW
                        let convoCollectionRef = Firestore.firestore().collection("Conversations").document(convoID)
                        try await convoCollectionRef.updateData([
                            "mostRecentMessage": newReply.replyContent,
                            "mostRecentTimestamp": newReply.timeStamp
                        ])
                        replies.append(newReply)
                        print("reply appenededed.")
                        reply = ""
                    }
                }
            } catch {
                print("error caugh \(error)")
                await errorAlerts(error)
            }
        }
        print("end")
        
    }
    func storeImage() async throws {
        //Create reference to postMedia bucket
        let storageRef = Storage.storage().reference()
        
        // Create a reference to the file you want to upload
        let messageImageRef = storageRef.child("postMedia/\(UUID().uuidString).jpg")

        // Upload image
        if let imageData = imageData {
            let _ = try await messageImageRef.putDataAsync(imageData)
            try await imageURL = messageImageRef.downloadURL()
        }
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
        print("this called?4444")
        // Database Reference
        let db = Firestore.firestore()
        
        do {
            // Check for nils
            guard convoID != "" else { return }
            guard currUser != nil else { return }
            // Fetch batch of posts from Firestore
            var query: Query! = db.collection("Conversations").document(convoID).collection("Replies")
                .order(by: "timeStamp", descending: false)
                .limit(to: NUM_REPLIES)
            
            if let lastReply = lastReply {
                query = query.start(afterDocument: lastReply)
            }
            
            // Retrieve documents
            let replyBatch = try await query.getDocuments()
            let newReplies = replyBatch.documents.compactMap { post -> MessageReply? in
                try? post.data(as: MessageReply.self)
            }
            
            await MainActor.run(body: {
                replies += newReplies
                lastReply = replyBatch.documents.last
            })
            
        } catch {
            print ("errorrr: \(error.localizedDescription)")
        }
        return
    }
    
    @ViewBuilder
    func AddReplyView() -> some View {
        

        VStack {
            HStack(alignment: .bottom) {
                TextField("Write your message here...", text: $reply, axis: .vertical)
                    .padding(15)
                    .lineLimit(5)
                    .foregroundColor(Color.soothingNightDeepIndigo)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(20)
                    .submitLabel(.send)
                if let imageData, let image = UIImage(data:imageData) {
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
                                        self.imageData = nil
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
                    
                    Button {
                        // Present image picker
                        showImagePicker.toggle()
                    } label: {
                        Image(systemName: "photo")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(Color.nightfallHarmonyRoyalPurple)
                    }
                    .padding(.horizontal, 5).padding(.vertical, 9)
                }
            }
            
          /*  if let image = imageURL {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .padding()
            }*/
            Spacer()
            Button(action: {
                // Create reply
                print("creating reply")
                createReply()
                
            }) {
                Image(systemName: "paperplane.fill")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color.blue)
                    .padding()
            }
        }
        .padding()
        .cornerRadius(20)
        .photosPicker(isPresented: $showImagePicker, selection: $selectedPhoto)
        .onChange(of: selectedPhoto) { newValue in
            if let newValue {
                Task{
                    if let rawImageData = try? await newValue.loadTransferable(type: Data.self), let image = UIImage(data: rawImageData), let compressedImageData = image.jpegData(compressionQuality: 0.5) {
                        await MainActor.run(body: {
                            imageData = compressedImageData
                            selectedPhoto = nil
                        })
                    }
                }
            }
        }
    }
}

struct MessageCommentView: View {
    
    // Parameter
    @Binding var commentReply: MessageReply
    @State private var postImage: UIImage?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color.white)
                
                VStack(alignment: .leading){
                    
                    /*ForEach(0..<viewModel.userIDs.count, id: \.self) { index in
                        if (
                        Text(viewModel.usernames[index])
                    }*/
                    
                    Text("@\(commentReply.authorID)")
                        .font(.system(size: 13))
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                    
                    Text("\(commentReply.getRelativeTime())")
                        .font(.system(size: 13))
                        .fontWeight(.semibold)
                        .foregroundColor(.dreamyTwilightSlateGray)
                }
                
                Spacer()
            }
            if let imageURL = commentReply.imageURL {
                let _ = self.loadImage(imageURL: imageURL)
                if let postImage = postImage {
                    Image(uiImage: postImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 230, height: 150)
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
            
            Text("\(commentReply.replyContent)")
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color.soothingNightDeepIndigo))
        .listRowSeparator(.hidden)
    }
    
    func loadImage(imageURL: URL) {
        let storageRef = Storage.storage().reference(forURL: imageURL.absoluteString)
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



#Preview {
    MessagingView(convoID: "01pIM0ERt9KdsgXgruTT")
}


 
