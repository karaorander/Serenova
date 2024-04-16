//
//  JournalPostView.swift
//  Serenova 2.0
//
//  Created by Ava Schrandt on 3/21/24.
//


import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage

//Create New Post View
struct createJournalView: View {
    /// callback
    //var onPos: (Post)->()
    @State private var viewModel = GetNameModel()
    @State var journalText: String = ""
    @State var journalTitle: String = ""
    
    
    ///use app storage to get user data from firebase.  EX:
    //@AppStorage("userName") var userName: String = ""
    @State private var publishToggle:Bool = false
    @State private var isLoading:Bool = false
    @State private var showError:Bool = false
    @State private var errorMess: String = ""
    
    @FocusState private var showkeyboard: Bool
    
    @State private var isCreatingPost: Bool = false
    @State private var isPosted: Bool = false
    
    @State var tagOptions: [String] = ["None", "Questions", "Tips", "Hacks", "Support", "Goals", "Midnight Thoughts"]
    @State private var tagOption: Int = 0
    @State private var showTagOptions: Bool = false
    
    @State private var selectedFriends = Set<String>() 
    @State private var friendNames: [String: String] = [:]
    @State private var isDropdownOpen = false
    
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
                            Button("Delete Entry", role: .destructive) {
                                dismiss()
                            }
                        } label: {
                            Text("Cancel").font(.callout).foregroundColor(Color.dreamyTwilightOrchid)
                        }
                        NavigationLink ("", destination: ForumView().navigationBarBackButtonHidden(true), isActive: $isPosted)
                        Spacer()
                        Button(action: {
                            createJournal()
                            isCreatingPost = true
                            dismiss()
                        }) {
                            Text("Create Entry").font(.callout)
                                .foregroundColor(.dreamyTwilightOrchid)
                                .padding(.horizontal,20)
                                .padding(.vertical, 6)
                                .background(.white, in: Capsule())
                        }
                        .disabled(journalText == "")
                        .opacity((journalText == "") ? 0.4 : 1)
                    }.padding(.horizontal, 15).padding(.vertical, 10)
                    HStack {
                        Text("New Entry")
                            .font(Font.custom("NovaSquareSlim-Bold", size: 35))
                            .foregroundColor(.dreamyTwilightMidnightBlue)
                        Image(systemName: "moon.dust").font(.system(size: 35)).foregroundColor(.dreamyTwilightMidnightBlue)
                    }
                    //Notification Toggle
                    
                    ScrollView(.vertical, showsIndicators:false) {
                        VStack(spacing: 15){
                           
                           /* HStack {
                                Button(action: {
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
                            }.hSpacing(.leading) */
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
                                    .frame(height: 100)
                                    .border(Color.gray)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(10)
                                    .padding()
                                }
                            }
                                           
                                           Spacer()
                                       
                            HStack {
                                TextField("Title", text: $journalTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .focused($showkeyboard)
                            }.padding()
                                .background(Color.dreamyTwilightMidnightBlue.opacity(0.2))
                                .cornerRadius(10)
                            
                            
                            HStack {
                                TextField("What's on your mind?", text: $journalText, axis: .vertical)
                                    .foregroundColor(.white)
                                    .focused($showkeyboard)
                                    .frame(minHeight: 150, alignment: .top)
                                    
                            }.padding()
                                .background(Color.dreamyTwilightMidnightBlue.opacity(0.2))
                                .cornerRadius(10)
                        }.padding(15)
                        Toggle(isOn: $publishToggle, label: {Text ("Make Public")})
                            .toggleStyle(SwitchToggleStyle(tint: .moonlitSerenityCharcoalGray))
                            .hSpacing(.leading)
                            .padding().frame(width:200, height: 40)
                            .fontWeight(.medium)
                            .background(Color.tranquilMistAshGray.opacity(0.1)).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(5)
                        
                           
                            
                    }
                    
                    Divider()
                    
                }.vSpacing(.top)
                   
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
    
    func createJournal() {
        showkeyboard = false
        isLoading = true

        Task {
            do {
                // TESTING IN PREVIEW MODE:
                // Comment out the guard below and use
                // the second constructor for Post (uncomment it)
                
              /*  guard currUser != nil else {
                    await errorAlerts("ERROR! Not signed in.")
                    return
                }*/
                
                // Create new Post Object
                //var newPost = Post(title: postTitle, content: postText
                                   //authorUsername: currUser.username,
                                   //authorID: currUser.userID,
                                   //authorProfilePhoto: currUser.profileURL)
                
                let newEntry = Journal(journalTitle: journalTitle, journalContent: journalText)
                newEntry.journalPrivacyStatus = !publishToggle
                newEntry.journalTags = Array(selectedFriends)
                try await newEntry.addJournalEntry()
                
                // Store Image & Get DownloadURL
                
            } catch {
                await errorAlerts(error)
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


#Preview {
    createJournalView()
}
