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

class OtherAccountViewModel: ObservableObject {
    @Published var username: String = ""
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
            self.username = userData["username"] as? String ?? ""
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
                    .frame(width: 100, height: 100)
                    .padding()

                // Username
                Text(viewModel.username)
                    .font(.title2)
                    .fontWeight(.bold)

                // Full Name
                Text(viewModel.fullName)
                    .font(.title3)

                // Moon Count
                HStack {
                    Image(systemName: "moon.fill") // Moon icon
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text("Moon Count: \(viewModel.moonCount)")
                        .font(.body)
                }

                // Bio
                Text(viewModel.bio)
                    .font(.body)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)

                // Insomnia Status
                Text("Insomnia: \(viewModel.hasInsomnia ? "Yes" : "No")")
                    .font(.body)
                    .fontWeight(.semibold)
            }

            Spacer() // Pushes everything up

            // Add Friend Button
            Button(action: {
                // Implement the action to add a friend here
                print("Add Friend tapped for userID: \(userID)")
            }) {
                Text("Add Friend")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)

            // Block Button
            Button(action: {
                // Implement the block user action here
                print("Block User tapped for userID: \(userID)")
            }) {
                Text("Block User")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom, 20) // Add some padding at the bottom
        }
        .navigationTitle("Other Account")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchUserData(userID: userID)
        }
    }
}




#Preview {
    OtherAccountView(userID: "y09Ua7K0OHThPKH9b1vGgXAJBPm1")
}
//add
