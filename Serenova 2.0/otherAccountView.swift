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

struct OtherAccountView: View {
    var userID: String // Accepting userID as a parameter

    @StateObject private var viewModel = OtherAccountViewModel()

    var body: some View {
        VStack {
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
                print("My ID..  : \(currUser?.userID)")
                sendRequest(userID: userID)
                print("Add Friend tapped for userID: \(userID)")
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
                // Action for blocking a user
                print("Block User tapped for userID: \(userID)")
            }) {
                Text("Block User")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom, 20) // Add some padding at the bottom
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [.dreamyTwilightMidnightBlue.opacity(0.2), .nightfallHarmonyNavyBlue.opacity(0.6)]), startPoint: .top, endPoint: .bottom))
        .ignoresSafeArea()
        .navigationTitle("Other Account")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchUserData(userID: userID)
        }
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
        recipientCollectionRef.document(userID).setData([
            "friendid" : currUser?.userID,
            "requesterName": currUser?.username,
            "status" : 0

        ]) { error in
            if let error = error {
                print("Error adding friend: \(error)")
            } else {
                print("Friend added successfully to Firestore")
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
            }
        }
    }
}




#Preview {
    OtherAccountView(userID: "KgU9NVyNbJXG44kdiFEtf5E3reu1")
}
//add
