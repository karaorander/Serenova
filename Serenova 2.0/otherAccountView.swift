//
//  otherAccountView.swift
//  Serenova 2.0
//
//  Created by Ishwarya Samavedhi on 3/27/24.
//

import Foundation
import Firebase
import FirebaseDatabase
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

class OtherAccountViewModel: ObservableObject {
    @Published var userID: String = ""
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var fullName: String = ""
    @Published var moonCount: Int = 0
    @Published var bio: String = ""
    @Published var hasInsomnia: Bool = false
    @Published var areFriends: Bool = false
    @Published var isBlocked: Bool = false

        // New method to check if the two users are friends
        func checkIfFriends(with friendID: String) {
            guard let currentUserID = Auth.auth().currentUser?.uid else {
                print("No authenticated user found")
                return
            }

            let db = Firestore.firestore()
            let userFriendsRef = db.collection("FriendRequests").document(currentUserID).collection("Friends")

            // Check if the friendID exists in the current user's "Friends" collection
            userFriendsRef.document(friendID).getDocument { (document, error) in
                DispatchQueue.main.async {
                    if let document = document, document.exists {
                        print("true")
                        self.areFriends = true
                    } else {
                        print("false")
                        self.areFriends = false
                    }
                }
            }
        }
    
    func unblockUser(blockedUserID: String) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No authenticated user found")
            return
        }

        let db = Firestore.firestore()
        let userBlockedRef = db.collection("Users").document(currentUserID).collection("BlockedUsers")

        // Remove the blockedUserID from the current user's "BlockedUsers" collection
        userBlockedRef.document(blockedUserID).delete() { error in
            if let error = error {
                print("Error unblocking user: \(error)")
            } else {
                print("User successfully unblocked")
                DispatchQueue.main.async {
                    self.isBlocked = false // Update isBlocked to false
                    // Additional UI updates as necessary, e.g., showing an alert
                }
            }
        }
    }
    
    func checkIfBlocked(by userID: String) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No authenticated user found")
            return
        }

        let db = Firestore.firestore()
        let userBlockedRef = db.collection("Users").document(currentUserID).collection("BlockedUsers")

        // Check if the current user's ID exists in the userID's "BlockedUsers" collection
        userBlockedRef.document(userID).getDocument { [weak self] (document, error) in
            DispatchQueue.main.async {
                if let document = document, document.exists {
                    print("Blocked: true")
                    self?.isBlocked = true
                } else {
                    print("Blocked: false")
                    self?.isBlocked = false
                }
            }
        }
    }

    private var ref: DatabaseReference = Database.database().reference().child("User")
    
    func blockUser(blockedUserID: String) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No authenticated user found")
            return
        }

        let db = Firestore.firestore()
        let userBlockedRef = db.collection("Users").document(currentUserID).collection("BlockedUsers")

        // Add the blockedUserID to the current user's "BlockedUsers" collection
        userBlockedRef.document(blockedUserID).setData(["blockedid": blockedUserID]) { error in
            if let error = error {
                print("Error blocking user: \(error)")
            } else {
                print("User successfully blocked")
                DispatchQueue.main.async {
                    self.isBlocked = true
                            }

            }
        }
    }

    // Function to fetch user data based on userID
    func fetchUserData(userID: String) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("No authenticated user found")
            return
        }

        let db = Firestore.firestore()
        let blockedRef = db.collection("Users").document(userID).collection("BlockedUsers")

        blockedRef.document(currentUserID).getDocument { [weak self] (document, error) in
            DispatchQueue.main.async {
                if let document = document, document.exists {
                    self?.isBlocked = true // Current user is blocked by this user
                } else {
                    self?.isBlocked = false // Current user is not blocked, proceed to fetch user data
                    self?.ref.child(userID).observeSingleEvent(of: .value, with: { snapshot in
                        guard let value = snapshot.value as? [String: Any] else {
                            print("Error: Could not find user")
                            return
                        }
                        self?.parseUserData(userData: value)
                    }) { error in
                        print(error.localizedDescription)
                    }
                }
            }
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

struct OtherAccountView: View {
    var userID: String // Accepting userID as a parameter

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject private var viewModel = OtherAccountViewModel()
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack {
            if viewModel.isBlocked {
                        // Show "Blocked User" message
                        Spacer()
                        Text("Blocked User")
                            .font(.largeTitle)
                            .foregroundColor(.red)
                        Spacer()
                Button(action: {
                        viewModel.unblockUser(blockedUserID: userID)
                        print("User unblocked.")
                    }) {
                        Text("Unblock User")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue) // Choose an appropriate color
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
            } else {
                
                Spacer().frame(height: 60)
                VStack(spacing: 20) {
                    
                    // Profile Picture
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 90, height: 85)
                        .clipShape(Circle())
                        .padding()
                    
                    // Username
                    Text("Email: \(viewModel.email)")
                        .font(.system(size: 25))
                        .fontWeight(.medium)
                    
                    
                    if viewModel.areFriends {
                        Text("Friends")
                            .font(.system(size: 17))
                            .fontWeight(.medium)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                            .multilineTextAlignment(.center)
                    }
                    
                    // Full Name
                    Text("Name: \(viewModel.fullName)")
                        .font(.system(size: 17))
                        .fontWeight(.medium)
                        .padding()
                        .frame(width: 300, height: 40, alignment: .leading)
                        .background(Color.tranquilMistAshGray)
                        .foregroundColor(.nightfallHarmonyNavyBlue)
                        .cornerRadius(5)
                    
                    // Moon Count
                    if viewModel.areFriends {
                        HStack {
                            Image(systemName: "moon.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("Moon Count: \(viewModel.moonCount)")
                                .font(.system(size: 17))
                                .fontWeight(.medium)
                        }
                        .padding()
                        .frame(width: 300, height: 40, alignment: .leading)
                        .background(Color.tranquilMistAshGray)
                        .foregroundColor(.nightfallHarmonyNavyBlue)
                        .cornerRadius(5)
                    }
                    
                    // Bio
                    Text("Bio: \(viewModel.bio)")
                        .font(.system(size: 17))
                        .fontWeight(.medium)
                        .padding()
                        .frame(width: 300, height: 40, alignment: .leading)
                        .background(Color.tranquilMistAshGray)
                        .foregroundColor(.nightfallHarmonyNavyBlue)
                        .cornerRadius(5)
                    
                    // Insomnia Status
                    Text("Insomnia: \(viewModel.hasInsomnia ? "Yes" : "No")")
                        .font(.system(size: 17))
                        .fontWeight(.medium)
                        .padding()
                        .frame(width: 300, height: 40, alignment: .leading)
                        .background(Color.tranquilMistAshGray)
                        .foregroundColor(.nightfallHarmonyNavyBlue)
                        .cornerRadius(5)
                    
                    
                }
                
                
                
                Spacer() // Pushes everything up
                
                // Add Friend Button
                Button(action: {
                    if viewModel.areFriends {
                        DispatchQueue.main.async {
                                        self.alertMessage = "You are already friends with this user!"
                                        self.showAlert = true
                                    }
                    }
                    else {
                        print("My ID..  : \(currUser?.userID)")
                        sendRequest(userID: userID)
                        print("Add Friend tapped for userID: \(userID)")
                        if let user = currUser {
                            print("helllooo")
                            user.updateMoons(rewardCount: 25)
                            user.hasMedication = true;
                            user.updateValues(newValues: ["hasMedication" :
                                                            user.hasMedication])
                            user.addNotification("25 Moons Added!")
                            
                            //user.sleepGoalReached = true
                        }
                    }
                }) {
                    Text("Add Friend")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.nightfallHarmonyNavyBlue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                // Block Button
                Button(action: {
                    viewModel.blockUser(blockedUserID: userID)
                    print("user block.")
                    DispatchQueue.main.async {
                                    self.alertMessage = "User Blocked."
                                    self.showAlert = true
                                }

                    // Optionally dismiss the view after blocking
                }) {
                    HStack {
                        Text("Block User")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    .foregroundColor(.blue)
                    .padding()
                }
            }
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [.dreamyTwilightMidnightBlue.opacity(0.2), .nightfallHarmonyNavyBlue.opacity(0.6)]), startPoint: .top, endPoint: .bottom))
        .ignoresSafeArea()
        .navigationTitle("Other Account")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchUserData(userID: userID)
            viewModel.checkIfFriends(with: userID)
            viewModel.checkIfBlocked(by: userID)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Friend Request"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Image(systemName: "arrow.left") // Customize as needed
                        Text("Back") // Customize as needed
                    }
                })
    }


    
    
    // Store new FriendRequest in FireStore for 'Friend'
    // Store new ownRequest in Firestore for currUser
    // STATUS: 0 (Unanswered), 1 (Yes), 2 (No)
    func sendRequest(userID: String) {
        let db = Firestore.firestore()
        let currentUserID = Auth.auth().currentUser!.uid
        
        let recipientCollectionRef = db.collection("FriendRequests").document(userID).collection("friendRequests")
        
        let userCollectionRef = db.collection("FriendRequests").document(currentUserID).collection("ownRequests")
        
        // Update friendRequest
        recipientCollectionRef.document(currUser!.userID).setData([
            "friendid" : currUser?.userID,
            "requesterName": currUser?.username,
            "status" : 0

        ]) { error in
            if let error = error {
                print("Error adding friend: \(error)")
            } else {
                print("Friend added successfully to Firestore")
                DispatchQueue.main.async {
                                self.alertMessage = "Sent Friend Request!"
                                self.showAlert = true
                            }
            }
        }
        
        // Update ownRequests
        userCollectionRef.document(userID).setData([
            "friendid" : userID
        ]) { error in
            if let error = error {
                print("Error adding friend: \(error)")
            } else {
                print("Friend added successfully to Firestore")
                DispatchQueue.main.async {
                                self.alertMessage = "Sent Friend Request!"
                                self.showAlert = true
                            }
            }
        }
    }

}




#Preview {
    OtherAccountView(userID: "a0eji7VVfHgn5ZBX4BJDUuhMaFn1")
}
//add
