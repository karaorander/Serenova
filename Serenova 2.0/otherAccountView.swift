//
//  otherAccountView.swift
//  Serenova 2.0
//
//  Created by Ishwarya Samavedhi on 3/27/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

struct otherAccountView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    
    // Store new FriendRequest in FireStore for 'Friend'
    // STATUS: 0 (unanswered), 1 (Yes), 2 (No)
    func sendRequest(friend: Friend) {
        let db = Firestore.firestore()
        
        let recipientCollectionRef = db.collection("FriendRequests").document(friend.friendID).collection("Friends")
        
        recipientCollectionRef.document(friend.friendID).setData([
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
    }
}

#Preview {
    otherAccountView()
}
