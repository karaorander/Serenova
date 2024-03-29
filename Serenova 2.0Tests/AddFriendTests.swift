//
//  AddFriendTests.swift
//  Serenova 2.0Tests
//
//  Created by Ishwarya Samavedhi on 3/29/24.
//

import XCTest
import Firebase
@testable import Serenova_2_0

protocol FirestoreFriendServiceProtocol {
    func addFriend(currentUserID: String, friendID: String, completion: @escaping (Error?) -> Void)
    // Add other necessary methods here
}

class RequestViewModel: ObservableObject {
    var firestoreService: FirestoreFriendServiceProtocol

    init(firestoreService: FirestoreFriendServiceProtocol) {
        self.firestoreService = firestoreService
    }

    func addFriend(friend: Friend) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Error: No authenticated user found")
            return
        }

        firestoreService.addFriend(currentUserID: currentUserID, friendID: friend.friendID) { error in
            if let error = error {
                print("Error adding friend: \(error.localizedDescription)")
            } else {
                print("Friend added successfully")
                // Update any necessary local state here
            }
        }
    }
}

class MockFirestoreFriendService: FirestoreFriendServiceProtocol {
    var didCallAddFriend = false
    var lastFriendID: String?

    func addFriend(currentUserID: String, friendID: String, completion: @escaping (Error?) -> Void) {
        didCallAddFriend = true
        lastFriendID = friendID
        completion(nil) // Simulate success
    }
}

class FirestoreFriendService: FirestoreFriendServiceProtocol {
    func addFriend(currentUserID: String, friendID: String, completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let friendsCollectionRef = db.collection("FriendRequests").document(currentUserID).collection("Friends")
        
        friendsCollectionRef.document(friendID).setData(["friendid": friendID]) { error in
            completion(error)
        }
    }
}



class RequestViewModelTests: XCTestCase {
    var viewModel: RequestViewModel!
    var mockFirestoreService: MockFirestoreFriendService!

    override func setUp() {
        super.setUp()
        mockFirestoreService = MockFirestoreFriendService()
        viewModel = RequestViewModel(firestoreService: mockFirestoreService)
    }

    func testAddFriend() {
        let friend = Friend(friendID: "QTtHOTNo0qazEobpeMzfRZbxgQv1", requesterName: "Isha", requesterEmail: "Push@example.com")

        viewModel.addFriend(friend: friend)

        XCTAssertTrue(mockFirestoreService.didCallAddFriend, "addFriend should be called on the mock Firestore service.")
        XCTAssertEqual(mockFirestoreService.lastFriendID, friend.friendID, "The correct friend ID should be passed to addFriend.")
    }
}

