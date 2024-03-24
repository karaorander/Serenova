//
//  Post.swift
//  Serenova 2.0
//
//  Created by Caitlin Wilson on 2/19/24.
//
import Foundation
import FirebaseDatabase

class Post: Codable {
    public var postID: String = ""
    public var title: String = ""
    public var content: String = ""
    public var timeStamp: String = ""
    public var imageURL: URL?
    public var authorID: String = ""
    public var authorUsername: String = ""
    public var authorProfilePhoto: URL?
    public var likeIDs: [String] = []
    public var notifyUsers: [String] = []
    
    enum CodingKeys: CodingKey {
        case postID, title, content, timeStamp, imageURL,
             authorID, authorUsername, authorProfilePhoto, likeIDs
    }
    
    // Create reference to "Post" objects within Database
    private var ref: DatabaseReference! = Database.database().reference()
    
    /*
     * Constructor for creating new post
     * TODO: Add authorUsername
     */
    init(title: String, content: String, authorID: String, authorProfilePhoto: URL? = nil) {
        self.title = title
        self.content = content
        self.authorID = authorID
        self.authorProfilePhoto = authorProfilePhoto
        
        // Generates unique ID for post (HANDLE ERROR LATER)
        self.postID = self.ref.childByAutoId().key ?? "ERROR"
    }
    
    /*
     * TEMP CONSTRUCTOR FOR PREVIEW MODE (REMOVE LATER)
     */
    init(title: String, content: String) {
        self.title = title
        self.content = content
        
        // Generates unique ID for post (HANDLE ERROR LATER)
        self.postID = self.ref.childByAutoId().key ?? "ERROR"
    }
    
    /*
     * Regular constructor used for loading existing Post
     */
    init() {}
    
    /*
     * Function to write new post to Firebase
     */
    func createPost() throws {
        // Set Date to time that the Post is actually posted
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        self.timeStamp = dateFormatter.string(from: date)
        
        // Convert data to JSON-like object for storage
        let encodedData = try JSONSerialization.jsonObject(with: JSONEncoder().encode(self), options: []) as? [String: Any]
        // Write new Post object to Database
        ref.child("Post").child(self.postID).setValue(encodedData)
    }
    
    /*
     * Function to update certain values of the post (edit mode)
     */
    func updateValues(newValues: [String: Any]) {
        self.ref.child(self.postID).updateChildValues(newValues)
    }
    
    /*
     * Function to delete a post
     */
    func deletePost() {
        self.ref.child(self.postID).removeValue()
    }
}

/// post model example including likes, image urls, etc
/*
struct Post: Identifiable, Codable {
    @DocumentID var id: String?  // This is specific to FireStore
    var text = String
    var imageURL: URL?
    var imageReferenceID: String = ""
    var publishDate: Date = Date()
    var likeIDs: [String] = []
    //basic user info
    var userName: String
    var userUID: String
    var userProfileURL: URL
    
    enum CodingKeys: CodingKey {
        case id
        case text
        case imageURL
        case imageReferenceID
        case publishDate
        case likeIDs
        case userName
        case userUID
        case userProfileURL
    }
    
}
*/
