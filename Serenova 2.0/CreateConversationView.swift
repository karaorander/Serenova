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
    @Published var userID = ""
    @Published var userIDs: [String] = []
    @Published var usernames: [String] = []
    
    @Published var isBlocked: Bool = false
 
        
        // Function to fetch usernames from the database
        func fetchUserIDs(completion: @escaping () -> Void) {
            let db = Database.database().reference().child("User")
            db.observeSingleEvent(of: .value) { snapshot in
                guard let usersData = snapshot.value as? [String: Any] else {
                    print("Error fetching user data")
                    return
                }
                self.userIDs = Array(usersData.keys)
                
                          
                completion()
            }
            
        }
    
    func fetchUsernames(completion: @escaping () -> Void) {
        let db = Database.database().reference().child("User")
        db.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let usersData = snapshot.value as? [String: [String: Any]] else {
                print("Error fetching user data")
                return
            }

            let currentUserID = Auth.auth().currentUser?.uid

            // Use a dispatch group to wait for all blocking checks to complete
            let dispatchGroup = DispatchGroup()
            var tempUsernames: [String] = []
            var tempUserIDs: [String] = []

            for (userID, userInfo) in usersData {
                guard let name = userInfo["name"] as? String else {
                    continue
                }

                dispatchGroup.enter() // Enter the dispatch group

                // Check if the current user has blocked the user and vice versa
                self?.checkIfBlocked(by: userID) { blockedByCurrentUser in
                    self?.checkIfCurrUserBlocked(by: userID) { currentUserBlockedByUser in
                        if !blockedByCurrentUser && !currentUserBlockedByUser {
                            tempUsernames.append(name)
                            tempUserIDs.append(userID)
                        }

                        // Leave the dispatch group
                        dispatchGroup.leave()
                    }
                }
            }

            // Wait for all checks to complete
            dispatchGroup.notify(queue: .main) {
                self?.usernames = tempUsernames
                self?.userIDs = tempUserIDs
                completion()
            }
        }
    }
    
    func fetchUsername(/*completion: @escaping () -> Void*/) {
        let db = Database.database().reference()
        let id = Auth.auth().currentUser!.uid
        let ur = db.child("User").child(id)
                
        //self.userID = id
        
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
            if let userID = userData["userID"] as? String {
                self.userID = userID
            }
            
            self.objectWillChange.send()
            
            // Call the completion closure to indicate that data fetching is completed
            //completion()
        }
    }
    
    func checkIfBlocked(by userID: String, completion: @escaping (Bool) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No authenticated user found")
            completion(false)
            return
        }

        let db = Firestore.firestore()
        let userBlockedRef = db.collection("Users").document(currentUserID).collection("BlockedUsers")

        // Check if the current user's ID exists in the userID's "BlockedUsers" collection
        userBlockedRef.document(userID).getDocument { [weak self] (document, error) in
            DispatchQueue.main.async {
                if let document = document, document.exists {
                    print("Blocked: true")
                    completion(true)
                } else {
                    print("Blocked: false")
                    completion(false)
                }
            }
        }
    }
    
    func checkIfCurrUserBlocked(by userID: String, completion: @escaping (Bool) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No authenticated user found")
            completion(false)
            return
        }
        
        let db = Firestore.firestore()
        let userBlockedRef = db.collection("Users").document(userID).collection("BlockedUsers")
        
        // Check if the current user's ID exists in the userID's "BlockedUsers" collection
        userBlockedRef.document(currentUserID).getDocument { [weak self] (document, error) in
            DispatchQueue.main.async {
                if let document = document, document.exists {
                    print("CurrUserBlocked: true")
                    completion(true)
                } else {
                    print("CurrUserBlocked: false")
                    completion(false)
                }
            }
        }
    }
    
    
}

struct CreateConversationView: View {
    @StateObject var viewModel = CreateConvoViewModel()
    @State private var messageReceiver: String = ""
    @State private var messageText: String = ""
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedUsernameIndex = 0
        
        // Add a property to store the selected username
        var selectedUsername: String {
            viewModel.usernames[selectedUsernameIndex]
        }
    
    var body: some View {
        VStack {
            VStack {
                        // Add a picker view to select a username
                        Picker("Select User", selection: $selectedUsernameIndex) {
                            ForEach(0..<viewModel.userIDs.count, id: \.self) { index in
                                Text(viewModel.usernames[index])
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .padding()
                        
                        
                    }
                    .onAppear {
                        // Fetch usernames when the view appears
                      //  viewModel.fetchUsernames { }
                        viewModel.fetchUsernames {}
                    }
            
            
            TextField("Message", text: $messageText)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal)
            
            Button(action: {
                // Validate input and create conversation
                createConversation()
                print("CREATING....")
                dismiss()
               // dismiss()
            }) {
                Text("Send")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding()
        }
        .navigationTitle("New Conversation")
    }
    
    func createConversation() {
        guard !messageText.isEmpty else {
            // Show an alert indicating that both fields are required
            return
        }
        
        // Check if the recipient exists and is not blocked
        //viewModel.checkIfBlocked(by: viewModel.userIDs[selectedUsernameIndex]) {}
            
            viewModel.fetchUsername() //{
                Task {
                    do {
                        
                        /*if viewModel.username.isEmpty {
                         // Show an alert indicating that the recipient does not exist
                         } else
                         } else {*/
                        print("CREATING MESSAGE")
                        // Create a new conversation
                        let message = Message(senderID: Auth.auth().currentUser!.uid, content: messageText)
                        let newConversation = Conversation(participants: [Auth.auth().currentUser!.uid, viewModel.userIDs[selectedUsernameIndex]])
                        newConversation.addMessage(message)
                        /*viewModel.checkIfCurrUserBlocked(by: viewModel.userIDs[selectedUsernameIndex])
                        if viewModel.isBlocked {
                            // TODO: Show an alert indicating that the recipient is blocked
                            print("user is blocked")
                        }*/
                        try await newConversation.createConversation()
                        // Save the conversation to Firestore or your backend database
                        
                        //}
                    } catch {
                        
                    }
                }
            //}
    }
}

private var viewModel = CreateConvoViewModel()

//Create New Conversation View
struct CreateBrandNewConversationView: View {
    /// callback
    //var onPos: (Post)->()
    @State var messageText: String = ""
    @State var messageReceiver: String = ""
    @State var messageImageData: Data?
    @State var matchedUsers: [[String:Any]] = []
    
    @State private var newConvo: Conversation?
    @State private var hasClicked: Bool = false
    
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
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .fontWeight(.semibold)
                                .foregroundColor(.dreamyTwilightOrchid)
                            TextField("Search users...", text: $messageReceiver)
                                .foregroundColor(.black)
                                .onSubmit {
                                    matchedUsers = []
                                    getUsers()
                                }
                                .submitLabel(.search)
                            if !messageText.isEmpty {
                                Button(action:{messageText = ""}){
                                    Image(systemName: "multiply.circle.fill")
                                        .resizable()
                                        .frame(width: 18, height: 18)
                                        .foregroundColor(.dreamyTwilightOrchid)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(20)
                        
                        // Cancel Button
                        Button {
                            dismiss()
                        } label: {
                            Text("Cancel")
                                .font(.callout)
                                .foregroundColor(Color.dreamyTwilightOrchid)
                                .padding(.leading, 5)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal)
                    List {
                        ForEach(matchedUsers.indices, id: \.self) { index in
                            VStack {
                                Button {
                                    // TODO: Create new chat
                                    createConversation(participants: [(matchedUsers[index]["key"] as? String)].compactMap { $0 })
                                    hasClicked = true
                                } label: {
                                    MatchedUsersView(user: matchedUsers[index])
                                        .padding(10)
                                }
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.soothingNightDeepIndigo)
                        )
                    }
                    .padding(8)
                    .listRowSpacing(2)
                    .listStyle(PlainListStyle())
                    .scrollIndicators(ScrollIndicatorVisibility.hidden)
                    
                    if let newConvo = newConvo {
                        NavigationLink ("", destination: MessagingView(convoID: newConvo.convoId!).navigationBarBackButtonHidden(false), isActive: $hasClicked)
                    }

                }.vSpacing(.top)
                    .alert(
                        "Conversation Creation Failure",
                        isPresented: $showError
                    ) {
                        Button("OK") {}
                    } message: {
                        Text(errorMess)
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

    func getUsers() {
        let db = Database.database().reference().child("User")
        db.queryOrdered(byChild: "name").queryEqual(toValue: messageReceiver).observeSingleEvent(of:.value) { snapshots, arg in
            for snapshot in snapshots.children.allObjects as! [DataSnapshot] {
                guard var userData = snapshot.value as? [String: Any] else {
                    print("Error fetching data")
                    return
                }
                userData["key"] = snapshot.key
                // TODO: Check if blocked
                matchedUsers.append(userData);
                print("HERE IS THE COUNT: ")
                print(matchedUsers.count)
            }
        }
    }

    func createConversation(participants: [String]) {
        // Check if the recipient exists and is not blocked
        //viewModel.checkIfBlocked(by: viewModel.userIDs[selectedUsernameIndex]) {}
        viewModel.fetchUsername() //{
            Task {
                do {
                    /*if viewModel.username.isEmpty {
                     // Show an alert indicating that the recipient does not exist
                     } else
                     } else {*/
                    print("CREATING MESSAGE")
                    // Create a new conversation
                    //let message = Message(senderID: Auth.auth().currentUser!.uid, content: messageText)
                    newConvo = Conversation(participants: participants)
                    //newConversation.addMessage(message)
                    /*viewModel.checkIfCurrUserBlocked(by: viewModel.userIDs[selectedUsernameIndex])
                    if viewModel.isBlocked {
                        // TODO: Show an alert indicating that the recipient is blocked
                        print("user is blocked")
                    }*/
                    try await newConvo!.createConversation()
                    // Save the conversation to Firestore or your backend database
                    
                    //}
                } catch {
                    
                }
            }
    }
}

//Create New Conversation View
struct CreateGroupConversationView: View {
    /// callback
    //var onPos: (Post)->()
    

        
    @State var messageText: String = ""
    @State var messageReceiver: String = ""
    @State var messageImageData: Data?
    @State var postImageURL: URL?
    @State var matchedUsers: [[String:Any]] = []
    @State var groupUsers: [[String:Any]] = []
    
    @State private var hasClicked: Bool = false
    @State private var newConvo: Conversation?
    
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
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .fontWeight(.semibold)
                                .foregroundColor(.dreamyTwilightOrchid)
                            TextField("Search users...", text: $messageReceiver)
                                .foregroundColor(.black)
                                .onSubmit {
                                    matchedUsers = []
                                    getUsers()
                                }
                                .submitLabel(.search)
                            if !messageText.isEmpty {
                                Button(action:{messageText = ""}){
                                    Image(systemName: "multiply.circle.fill")
                                        .resizable()
                                        .frame(width: 18, height: 18)
                                        .foregroundColor(.dreamyTwilightOrchid)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(20)
                        
                        // Cancel Button
                        Button {
                            dismiss()
                        } label: {
                            Text("Cancel")
                                .font(.callout)
                                .foregroundColor(Color.dreamyTwilightOrchid)
                                .padding(.leading, 5)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators:false) {
                        HStack {
                            Text("Users:")
                                .font(.system(size: 20))
                                .fontWeight(.semibold)
                                .foregroundColor(Color.dreamyTwilightOrchid)
                                .padding(.horizontal).padding(.vertical, 10)
                            ForEach(groupUsers.indices, id: \.self) { index in
                                HStack {
                                    Text("\(groupUsers[index]["name"] as! String)")
                                        .foregroundColor(Color.dreamyTwilightOrchid)
                                    Button {
                                        groupUsers.remove(at: index)
                                    } label: {
                                        Image(systemName: "xmark")
                                            .resizable()
                                            .frame(width: 10, height: 10)
                                            .foregroundColor(Color.dreamyTwilightOrchid)
                                    }
                                }
                                .padding(.vertical, 12).padding(.horizontal, 22)
                                .background(Color.moonlitSerenityLilac)
                                .cornerRadius(10)
                                .buttonStyle(NoStyle())
                            }
                        }
                    }
                    .padding(.vertical).padding(.horizontal, 10)
                    
                    List {
                        ForEach(matchedUsers.indices, id: \.self) { index in
                            VStack {
                                Button {
                                    print(matchedUsers[index])
                                    // Check if user is ALREADY THERE!
                                    if !groupUsers.contains(where: {($0["email"] as? String) == (matchedUsers[index]["email"] as? String)}) {
                                        groupUsers.append(matchedUsers[index])
                                    }
                                } label: {
                                    MatchedUsersView(user: matchedUsers[index])
                                        .padding(10)
                                }
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.soothingNightDeepIndigo)
                        )
                    }
                    .padding(8)
                    .listRowSpacing(2)
                    .listStyle(PlainListStyle())
                    .scrollIndicators(ScrollIndicatorVisibility.hidden)
                    
                    Button {
                        if groupUsers.count != 0 {
                            createConversation(participants: groupUsers.compactMap { $0["key"] as? String })
                            hasClicked = true
                        }
                    } label: {
                        Text("Create Group")
                            .foregroundColor(Color.soothingNightDeepIndigo)
                            .frame(width: 313, height: 40)
                    }
                    .padding(.vertical, 12).padding(.horizontal, 22)
                    .background(Color.moonlitSerenityLilac)
                    .cornerRadius(20)
                    .buttonStyle(NoStyle())
                    
                    if let newConvo = newConvo {
                        NavigationLink ("", destination: MessagingView(convoID: newConvo.convoId!).navigationBarBackButtonHidden(false), isActive: $hasClicked)
                    }
                }.vSpacing(.top)
                    .alert(
                        "Conversation Creation Failure",
                        isPresented: $showError
                    ) {
                        Button("OK") {}
                    } message: {
                        Text(errorMess)
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
    
    func getUsers() {
        let db = Database.database().reference().child("User")
        db.queryOrdered(byChild: "name").queryEqual(toValue: messageReceiver).observeSingleEvent(of:.value) { snapshots, arg in
            for snapshot in snapshots.children.allObjects as! [DataSnapshot] {
                guard var userData = snapshot.value as? [String: Any] else {
                    print("Error fetching data")
                    return
                }
                userData["key"] = snapshot.key
                // TODO: Check if blocked
                matchedUsers.append(userData);
                print("HERE IS THE COUNT: ")
                print(matchedUsers.count)
            }
        }
    }

    func createConversation(participants: [String]) {
        // Check if the recipient exists and is not blocked
        //viewModel.checkIfBlocked(by: viewModel.userIDs[selectedUsernameIndex]) {}
        viewModel.fetchUsername() //{
        Task {
            do {
                /*if viewModel.username.isEmpty {
                 // Show an alert indicating that the recipient does not exist
                 } else
                 } else {*/
                print("CREATING MESSAGE")
                // Create a new conversation
                //let message = Message(senderID: Auth.auth().currentUser!.uid, content: messageText)
                newConvo = Conversation(participants: participants)
                //newConversation.addMessage(message)
                /*viewModel.checkIfCurrUserBlocked(by: viewModel.userIDs[selectedUsernameIndex])
                 if viewModel.isBlocked {
                 // TODO: Show an alert indicating that the recipient is blocked
                 print("user is blocked")
                 }*/
                try await newConvo!.createConversation()
                // Save the conversation to Firestore or your backend database
                //}
            } catch {
                
            }
        }
    }
}

struct MatchedUsersView: View {
    var user: [String: Any]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 45, height: 45)
                    .foregroundColor(Color.white)
                    .foregroundColor(.clear)
                    .padding(.trailing)
                VStack(alignment: .leading) {
                    Text("\(user["name"]!)")
                        .font(.system(size: 17))
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    Text("\(user["email"]!)")
                        .font(.system(size: 17))
                        .fontWeight(.semibold)
                        .foregroundColor(.moonlitSerenityLilac)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                }
            }
            .padding(.vertical, 8)
        }
    }
}

struct ChooseConversationOptionView: View {
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
                VStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "line.horizontal.3.decrease")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Spacer()
                        Text("Choose Type")
                            .font(Font.custom("NovaSquareSlim-Bold", size: 35))
                            .foregroundColor(.white)
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                    .padding().padding(.horizontal, 15)
                    //Option 1
                    NavigationLink(destination: CreateBrandNewConversationView().navigationBarBackButtonHidden(true)) {
                        Text("Create One-on-One Chat")
                            .font(Font.custom("NovaSquareSlim-Bold", size: 20))
                            .foregroundColor(.white)
                            .padding(50)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.dreamyTwilightOrchid)
                                    .frame(width: 375)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    //Option 2
                    NavigationLink(destination: CreateGroupConversationView().navigationBarBackButtonHidden(true)) {
                        Text("Create Group Chat")
                            .font(Font.custom("NovaSquareSlim-Bold", size: 20))
                            .foregroundColor(.white)
                            .padding(50)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.dreamyTwilightOrchid)
                                    .frame(width: 375)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    ChooseConversationOptionView()
}

