//
//  PostPermissionsTests.swift
//  Serenova 2.0Tests
//
//  Created by Ishwarya Samavedhi on 3/29/24.
//

import XCTest
@testable import Serenova_2_0
import Firebase

protocol FirestoreManaging {
    func addDocument(data: [String: Any], completion: @escaping (Error?) -> Void)
}

protocol AuthManaging {
    var currentUserUID: String? { get }
}

class FirestoreManager: FirestoreManaging {
    func addDocument(data: [String: Any], completion: @escaping (Error?) -> Void) {
        Firestore.firestore().collection("Posts").addDocument(data: data) { error in
            completion(error)
        }
    }
}

class AuthManager: AuthManaging {
    var currentUserUID: String? {
        return Auth.auth().currentUser?.uid
    }
}

class Post2 {
    var firestoreManager: FirestoreManaging?
    var authManager: AuthManaging?

    var title: String
    var content: String
    var authorID: String  // Make sure this property exists

    // Updated initializer to include `authorID`
    init(title: String, content: String, authorID: String, firestoreManager: FirestoreManaging? = nil, authManager: AuthManaging? = nil) {
        self.title = title
        self.content = content
        self.authorID = authorID  // Initialize authorID
        self.firestoreManager = firestoreManager
        self.authManager = authManager
    }

    func createPost(completion: @escaping (Error?) -> Void) {
        guard let firestoreManager = firestoreManager else { return }
        let data = ["title": title, "content": content, "authorID": authorID /* Include authorID in the data dictionary if needed */]
        firestoreManager.addDocument(data: data, completion: completion)
    }

    func canCurrentUserDelete() -> Bool {
        return authManager?.currentUserUID == authorID
    }
}


class MockFirestoreManager: FirestoreManaging {
    var addDocumentCalled = false

    func addDocument(data: [String: Any], completion: @escaping (Error?) -> Void) {
        addDocumentCalled = true
        completion(nil)  // Simulate successful addition with no error
    }
}

class MockAuthManager: AuthManaging {
    var mockCurrentUserUID: String? = "testUID"

    var currentUserUID: String? {
        return mockCurrentUserUID
    }
}

class ForumTests: XCTestCase {
    func testUserPermissionToDeletePost() {
        let mockAuthManager = MockAuthManager()
        mockAuthManager.mockCurrentUserUID = "YUwFRQM46NUlSpKvs0DRfyw0ON93"
        let post = Post2(title: "Test", content: "Test content", authorID: "YUwFRQM46NUlSpKvs0DRfyw0ON93", firestoreManager: nil, authManager: mockAuthManager)

        XCTAssertTrue(post.canCurrentUserDelete(), "The current user should have permission to delete the post since they are the author")
    }
    
    func testDifferentUserPermissionToDeletePost() {
        let mockAuthManager = MockAuthManager()
        mockAuthManager.mockCurrentUserUID = "YUwFRQM46NUlSpKvs0DRfyw0ON93"
        let post = Post2(title: "Test", content: "Test content", authorID: "QTtHOTNo0qazEobpeMzfRZbxgQv1", firestoreManager: nil, authManager: mockAuthManager)

        XCTAssertFalse(post.canCurrentUserDelete(), "The current user should NOT have permission to delete the post since they are not the author")
    }
}


