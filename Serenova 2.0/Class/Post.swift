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
    public var content: String = ""
    @ServerTimestamp public var timeStamp: Timestamp?
    public var imageURL: URL?
    public var authorID: String = ""
    public var authorUsername: String = ""
    public var authorProfilePhoto: URL?
    public var likeIDs: [String] = []

    /*
     * Constructor for creating new post
     * TODO: Add authorUsername
     */
    /*
    init(title: String, content: String, authorID: String) {
        self.title = title
        self.content = content
        self.authorID = authorID
    }
    */
    /*
     * TEMP CONSTRUCTOR FOR PREVIEW MODE (REMOVE LATER)
     */
    init(title: String, content: String) {
        self.title = title
        self.content = content
    }
    
    /*
     * Function to write new post to Firebase
     */
    func createPost() async throws{
        // Create Firestore document ref
        let ref = Firestore.firestore().collection("Posts")
        // Write new Post object to Database
        try ref.addDocument(from: self)
    }
    
    /*
     * Function to get relative date
     */
    func getRelativeTime() -> String {
        guard let timeStamp = self.timeStamp else {
            return "0 seconds ago"
        }
        
        let dateFormatter = RelativeDateTimeFormatter()
        return dateFormatter.localizedString(for: Date(timeIntervalSince1970: TimeInterval(timeStamp.seconds)), relativeTo: Date())
    }
    
    /*
     * Function to get date
     */
    func getRealTime() -> String {
        guard let timeStamp = self.timeStamp else {
            return ""
        }
        
        let dateFormatter = DateFormatter()
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timeStamp.seconds)))
    }
}

