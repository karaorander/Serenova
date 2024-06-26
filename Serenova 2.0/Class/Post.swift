//
//  Post.swift
//  Serenova 2.0
//
//  Created by Caitlin Wilson on 2/19/24.
//
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseDatabase

class Post: Codable, Identifiable {
    @DocumentID var postID: String?
    public var title: String = ""
    public var titleAsArray: [String] = []
    public var content: String = ""
    public var timeStamp: Double = Date().timeIntervalSince1970
    public var imageURL: URL?
    public var tag: String?
    public var userTags: [String] = []
    public var numReplies: Int = 0
    public var likedIDs: [String] = []
    public var dislikedIDs: [String] = []
    public var authorID: String = ""
    public var authorUsername: String = ""
    public var authorProfilePhoto: URL?

    /*
     * Constructor for Post
     * TODO: Fill in other details! (i.e authorID, authorUsername, authorProfilePicture)
     */
    init(title: String, content: String, tag: String? = nil, userTags: [String]) {
        self.title = title
        self.titleAsArray = title.lowercased().split(separator: " ").map { String($0) }
        self.content = content
        if tag != nil {
            self.tag = tag
        }
        self.userTags = userTags
    }
    
    /*
     * Function to write new post to Firebase
     */
    func createPost() async throws{
        if ((Auth.auth().currentUser) != nil) {
            let db = Database.database().reference()
            self.authorID = Auth.auth().currentUser!.uid
            let ur = db.child("User").child(self.authorID)
            
            ur.observeSingleEvent(of: .value) { snapshot in
                guard let userData = snapshot.value as? [String: Any] else {
                    print("Error fetching data")
                    return
                }
                
                // Extract additional information based on your data structure
                if let username = userData["name"] as? String {
                    self.authorUsername = username
                }
            }
        }
        // Create Firestore document ref
        let ref = Firestore.firestore().collection("Posts")
        // Write new Post object to Database
        try ref.addDocument(from: self)
    }
    
    func updateValues(newValues: [String: Any], completion: @escaping (Error?) -> Void) {
            guard let postID = postID else {
                completion(PostError.missingPostID)
                return
            }
            
            let db = Firestore.firestore()
            let postRef = db.collection("Posts").document(postID)
            
            // Update values in Firestore
            postRef.updateData(newValues) { error in
                if let error = error {
                    // Handle error
                    completion(error)
                } else {
                    
                    for (key, value) in newValues {
                        // Update each property individually
                        switch key {
                        case "title":
                            self.title = value as? String ?? ""
                        case "content":
                            self.content = value as? String ?? ""
                        case "tag":
                            self.tag = value as? String
                        case "userTags":
                            self.userTags = value as? [String] ?? []
                        case "numReplies":
                            self.numReplies = value as? Int ?? 0
                        default:
                            break
                        }
                    }
                    completion(nil)
                }
            }
        }
    
    enum PostError: Error {
        case missingPostID
    }
    
    /*
     * Function to get relative date
     */
    func getRelativeTime() -> String {
        let dateFormatter = RelativeDateTimeFormatter()
        return dateFormatter.localizedString(for: Date(timeIntervalSince1970: TimeInterval(timeStamp)), relativeTo: Date())
    }
    
    /*
     * Function to get date
     */
    func getRealTime() -> String {
        let dateFormatter = DateFormatter()
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timeStamp)))
    }
    
}

class Reply: Codable, Identifiable {
    @DocumentID var replyID: String?
    public var parentPostID: String?
    public var replyContent: String = ""
    public var timeStamp: Double = Date().timeIntervalSince1970
    public var likedIDs: [String] = []
    public var dislikedIDs: [String] = []
    public var authorID: String = ""
    public var authorUsername: String = ""
    public var authorProfilePhoto: URL?
    
    /*
     * Constructor for Reply
     * TODO: Fill in other details! (i.e authorID, authorUsername, authorProfilePicture)
     */
    init(replyContent: String, parentPostID: String) {
        self.replyContent = replyContent
        self.parentPostID = parentPostID
    }
    
    /*
     * Function to write new post to Firebase
     */
    func createReply() async throws {
        // Create Firestore document ref
        let ref = Firestore.firestore().collection("Posts")
        // Write new Post object to Database
        let documentRef = ref.document(self.parentPostID!).collection("Replies").document()
        try documentRef.setData(from: self)
        // Update replyID
        self.replyID = documentRef.documentID
        // Increment parent post's number of replies
        try await ref.document(self.parentPostID!).updateData([
            "numReplies" : FieldValue.increment(Int64(1))
        ]);

    }
    
    /*
     * Function to get relative date
     */
    func getRelativeTime() -> String {
        let dateFormatter = RelativeDateTimeFormatter()
        return dateFormatter.localizedString(for: Date(timeIntervalSince1970: TimeInterval(timeStamp)), relativeTo: Date())
    }
    
    /*
     * Function to get date
     */
    func getRealTime() -> String {
        let dateFormatter = DateFormatter()
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timeStamp)))
    }
}

