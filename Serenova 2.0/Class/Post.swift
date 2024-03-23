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
    init(title: String, content: String, tag: String? = nil) {
        self.title = title
        self.titleAsArray = title.lowercased().split(separator: " ").map { String($0) }
        self.content = content
        if tag != nil {
            self.tag = tag
        }
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

