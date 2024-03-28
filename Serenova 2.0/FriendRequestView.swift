//
//  FriendRequestView.swift
//  Serenova 2.0
//
//  Created by Kara Orander on 3/24/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage


class GetNameModel: ObservableObject {
    @Published var userID: String = ""
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var fullName: String = ""
    @Published var moonCount: Int = 0
    @Published var bio: String = ""
    @Published var hasInsomnia: Bool = false

    private var ref: DatabaseReference = Database.database().reference().child("User")

    // Function to fetch user data based on userID
    func fetchUserData(userID: String) {
        ref.child(userID).observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                print("Error: Could not find user")
                return
            }
            self.parseUserData(userData: value)
        }) { error in
            print(error.localizedDescription)
        }
    }

    private func parseUserData(userData: [String: Any]) {
        DispatchQueue.main.async {
            self.userID = userData["userData"] as? String ?? ""
            self.username = userData["username"] as? String ?? ""
            self.email = userData["email"] as? String ?? ""
            self.fullName = userData["name"] as? String ?? ""
            self.moonCount = userData["moonCount"] as? Int ?? 0
            self.bio = userData["bio"] as? String ?? ""
            self.hasInsomnia = userData["hasInsomnia"] as? Bool ?? false
        }
    }
}

class RequestViewModel: ObservableObject {
    @StateObject private var viewModel = GetNameModel()
    @Published var friendRequestsArray = [Friend]()

       func getRequests() {
           if let currentUser = Auth.auth().currentUser {
               let db = Firestore.firestore()
               let currentUserID = Auth.auth().currentUser!.uid
               
               // Reference to the "FriendRequests" collection for the current user
               let friendRequestsCollectionRef = db.collection("FriendRequests").document(currentUserID)
               
               // Fetch all documents from the "friendRequests" subcollection
               friendRequestsCollectionRef.collection("friendRequests").getDocuments { (querySnapshot, error) in
                   if let error = error {
                       print("Error getting documents: \(error)")
                   } else {
                       var tempArray = [Friend]()
                       
                       // Iterate through each document in the "friendRequests" subcollection
                       for document in querySnapshot!.documents {
                           let data = document.data()
                           let friendID = data["friendid"] as? String ?? ""
                           let requesterName = data["requesterName"] as? String ?? ""
                           let requesterEmail = data["requesterEmail"] as? String ?? ""
                           
                           // Create a Friend object
                           let friend = Friend(friendID: friendID, requesterName: requesterName, requesterEmail: requesterEmail)
                           
                           // Append to the temporary array
                           tempArray.append(friend)
                       }
                       
                       // Update the published property on the main queue
                       DispatchQueue.main.async {
                           self.friendRequestsArray = tempArray
                       }
                   }
               }
           }
       }
    
    func addFriend(friend: Friend) {

        // Add friendID to the users "Friend" Array in User class as well
        if let friendID = friend.friendID as? String {
            currUser?.addFriend(friendID)
        } else {
            print("Error: friendID is not a string")
        }
        
        let db = Firestore.firestore()
        let currentUserID = Auth.auth().currentUser!.uid
        
        // Reference to the user's "friends" collection
        let friendsCollectionRef = db.collection("FriendRequests").document(currentUserID).collection("Friends")
        
        let requesterCollectionRef = db.collection("FriendRequests").document(friend.friendID).collection("Friends")
        
        let requesterOwnref = db.collection("FriendRequests").document(friend.friendID).collection("ownRequests")
        
        // Add friend to Firestore "friends" collection
        friendsCollectionRef.document(friend.friendID).setData([
            "email": friend.requesterEmail,
            "name": friend.requesterName,
            "friendid" : friend.friendID
        ], merge: true) { error in
            if let error = error {
                print("Error adding friend: \(error)")
            } else {
                print("Friend added successfully to Firestore1: \(friend.friendID)")
                
                // Remove friend from Firestore "friendRequests" collection
                            let friendRequestsCollectionRef = db.collection("FriendRequests").document(currentUserID).collection("friendRequests")
                            friendRequestsCollectionRef.document(friend.friendID).delete { error in
                                if let error = error {
                                    print("Error removing friend request from Firestore: \(error)")
                                } else {
                                    print("Friend request removed successfully from Firestore")
                                    
                                    // Remove friend from friendRequestsArray
                                    if let index = self.friendRequestsArray.firstIndex(of: friend) {
                                        self.friendRequestsArray.remove(at: index)
                                    }
                                }
                            }
            }
        }
        
        // Add friend to Firestore "Friends" collection
        requesterCollectionRef.document(currentUserID).setData([
            "name": currUser?.username,
            "friendid" : currUser?.userID
        ], merge: true) { error in
            if let error = error {
                print("Error adding friend: \(error)")
            } else {
                print("Friend added successfully to Firestore2: \(friend.friendID)")
            }
        }
        
        requesterOwnref.document(currentUserID).delete { error in
            if let error = error {
                print("Error removing friend request from Firestore: \(error)")
            } else {
                print("Friend request removed successfully from Firestore")
            }
        }
        
        let friendNotifications = db.collection("FriendRequests").document(friend.friendID).collection("notifications")
        
        // Add friend to Firestore "Friends" collection
        //if let username = currUser?.username {
        friendNotifications.document().setData([
            "message": "New Accepted friend request"
        ], merge: true) { error in
            if let error = error {
                print("Error adding notification: \(error)")
            } else {
                print("Notification added successfully to Firestore2: \(friend.friendID)")
            }
        }
        //}
    }
    
    func deleteRequest(friend: Friend) {
        let db = Firestore.firestore()
        let currentUserID = Auth.auth().currentUser!.uid
           
           // Reference to the user's "friends" collection
        let friendsCollectionRef = db.collection("FriendRequests").document(currentUserID).collection("friendRequests")
           
           // Reference to the specific friend document
        let friendDocumentRef = friendsCollectionRef.document(friend.friendID)
           
           // Delete the friend document
           friendDocumentRef.delete { error in
               if let error = error {
                   print("Error removing friend from Firestore: \(error)")
               } else {
                   print("Friend removed successfully from Firestore")
               }
           }
        
        // Remove friend from friendRequestsArray
        if let index = self.friendRequestsArray.firstIndex(of: friend) {
            self.friendRequestsArray.remove(at: index)
        }
        
        let requesterOwnref = db.collection("FriendRequests").document(friend.friendID).collection("ownRequests")
        
        requesterOwnref.document(currentUserID).delete { error in
            if let error = error {
                print("Error removing friend request from Firestore: \(error)")
            } else {
                print("Friend request removed successfully from Firestore")
            }
        }
        
        // Add notification to other user (friend's) notifications
        let friendNotifications = db.collection("FriendRequests").document(friend.friendID).collection("notifications")
        
        // Add friend to Firestore "Friends" collection
        friendNotifications.document().setData([
            "message": "New Denied friend request"
        ], merge: true) { error in
            if let error = error {
                print("Error adding notification: \(error)")
            } else {
                print("notification added successfully to Firestore2: \(friend.friendID)")
            }
        }
    }
}

struct FriendRequestView: View {
    @StateObject private var viewModel = RequestViewModel()
    var body: some View {
        NavigationView {
            ZStack {
                // Color gradient
                LinearGradient(gradient: Gradient(colors: [.nightfallHarmonySilverGray.opacity(0.8), .nightfallHarmonyRoyalPurple.opacity(0.4), .dreamyTwilightMidnightBlue.opacity(0.6), .nightfallHarmonyNavyBlue.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                            
                        Spacer()
                        
                        Text("Friend Requests")
                            .font(Font.custom("NovaSquareSlim-Bold", size: 35))
                            .foregroundColor(.white)
                        
                        Spacer()
                        // TODO: This is the search for when a user wants to search for a request to follow another user
                        /*
                        NavigationLink(destination: SearchForumView().navigationBarBackButtonHidden(true)) {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .fontWeight(.semibold)
                                .frame(width: 25, height: 25)
                                .foregroundColor(.white)
                        }*/
                        
                    }
                    .padding()
                    .padding(.horizontal, 15)
                    
                            if viewModel.friendRequestsArray.isEmpty {
                                NoRequestsView()
                            } else {
                                List {
                                    ForEach(viewModel.friendRequestsArray, id: \.self) { friendRequest in
                                        requestView(friendRequest: friendRequest)
                                            .padding(5)
                                    }
                                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                                    .listRowBackground(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.soothingNightDeepIndigo.opacity(0.5))
                                    )
                                }
                                .padding(8)
                                .listRowSpacing(5)
                                .listStyle(PlainListStyle())
                                .scrollIndicators(ScrollIndicatorVisibility.hidden)
                            }
                        }
            }
        }
        .onReceive(viewModel.$friendRequestsArray) { _ in
                        // Reload the list whenever friendRequestsArray changes
                        viewModel.getRequests()
                    }
        .onAppear {
            viewModel.getRequests()
        }

    }
}

class Friend: Codable, Hashable {
    public var friendID: String = ""
    public var requesterName: String = ""
    public var requesterEmail: String = ""
    
    init(friendID: String, requesterName: String, requesterEmail: String) {
            self.friendID = friendID
            self.requesterName = requesterName
            self.requesterEmail = requesterEmail
        }

    // Implementing Hashable protocol
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendID)
    }

    static func == (lhs: Friend, rhs: Friend) -> Bool {
        return lhs.friendID == rhs.friendID
    }
}

struct NoRequestsView: View {
    var body: some View {
        VStack (alignment: .center){
            Spacer()
            Image(systemName: "moon.stars.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.white)
                .padding()
            Text("No Requests")
                .foregroundColor(.white)
                .font(.system(size: 30))
                .fontWeight(.semibold)
            Spacer()
        }
    }
}

struct requestView: View {
    @StateObject private var viewModel = RequestViewModel()
    @StateObject private var viewModel2 = OtherAccountViewModel()
    var friendRequest: Friend
    
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                Text("Request From: \(viewModel2.fullName)")
                    .foregroundColor(Color.nightfallHarmonyRoyalPurple.opacity(0.9))
                    .padding(.bottom, 2)
                    .brightness(0.5)
                    //.saturation(0.3)
                
                Spacer()
                HStack {
                    Button ("Approve", action: {
                        viewModel.addFriend(friend: friendRequest)
                        viewModel.getRequests()
                    })
                    .font(.system(size: 15)).fontWeight(.medium).frame(width: 90, height: 30)
                    .background(Color.soothingNightLightGray.opacity(0.4).brightness(0.5))
                    .foregroundColor(.nightfallHarmonyRoyalPurple.opacity(1))
                    .cornerRadius(10)
                    
                    Button ("Deny", action: {
                        viewModel.deleteRequest(friend: friendRequest)
                        viewModel.getRequests()
                    })
                    .font(.system(size: 15)).fontWeight(.medium).frame(width: 90, height: 30)
                    .background(Color.soothingNightLightGray.opacity(0.4).brightness(0.5))
                    .foregroundColor(.nightfallHarmonyRoyalPurple.opacity(1))
                    .cornerRadius(10)
                }
            }
        }
        .onAppear {
            viewModel2.fetchUserData(userID: friendRequest.friendID)
        }
    }
}

#Preview {
    FriendRequestView()
}
