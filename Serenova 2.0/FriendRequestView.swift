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

class RequestViewModel: ObservableObject {
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
                           
                           // Create a Friend object
                           let friend = Friend(friendID: friendID, requesterName: requesterName)
                           
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
        
        // Add friend to Firestore "friends" collection
        friendsCollectionRef.document(friend.friendID).setData([
            "name": friend.requesterName,
            "friendid" : friend.friendID
        ]) { error in
            if let error = error {
                print("Error adding friend: \(error)")
            } else {
                print("Friend added successfully to Firestore")
                
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
        .onAppear {
            viewModel.getRequests()
        }
    }
}

class Friend: Codable, Hashable {
    public var friendID: String = ""
    public var requesterName: String = ""
    
    init(friendID: String, requesterName: String) {
            self.friendID = friendID
            self.requesterName = requesterName
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
    var friendRequest: Friend
    
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                Text(friendRequest.requesterName)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color.nightfallHarmonyRoyalPurple.opacity(0.9))
                    .padding(.bottom, 2)
                    .brightness(0.5)
                    //.saturation(0.3)
                
                Spacer()
                HStack {
                    Button ("Approve", action: {
                        viewModel.addFriend(friend: friendRequest)
                    })
                    .font(.system(size: 15)).fontWeight(.medium).frame(width: 90, height: 30)
                    .background(Color.soothingNightLightGray.opacity(0.4).brightness(0.5))
                    .foregroundColor(.nightfallHarmonyRoyalPurple.opacity(1))
                    .cornerRadius(10)
                    
                    Button ("Deny", action: {
                        viewModel.deleteRequest(friend: friendRequest)
                    })
                    .font(.system(size: 15)).fontWeight(.medium).frame(width: 90, height: 30)
                    .background(Color.soothingNightLightGray.opacity(0.4).brightness(0.5))
                    .foregroundColor(.nightfallHarmonyRoyalPurple.opacity(1))
                    .cornerRadius(10)
                }
            }
        }
    }
}

#Preview {
    FriendRequestView()
}
