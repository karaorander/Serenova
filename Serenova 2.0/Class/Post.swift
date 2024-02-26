//
//  Post.swift
//  Serenova 2.0
//
//  Created by Caitlin Wilson on 2/19/24.
//
import Foundation
import FirebaseDatabase

class Post {
    private var postID: String = ""
    private var title: String = ""
    private var content: String = ""
    private var timeStamp: String = ""
    private var imageURL: URL?
    //private var authorID: String = ""
    //private var authorUserName: String = ""
    //private var likeIDs: [String] = []
    //private var userProfileURL: URL
    //private var imageReferenceID: String = ""
    
    // Create reference to "Post" objects within Database
    private var ref: DatabaseReference! = Database.database().reference().child("Post")
    
    /*
     * Constructor for creating new post
     * (Add other values later)
     */
    init(title: String, content: String) {
        self.title = title
        self.content = content
        
        // Generates unique ID for post (HANDLE ERROR LATER)
        self.postID = self.ref.childByAutoId().key ?? "ERROR"
    }
    
    /*
     * TODO: Constructor to read posts from Firebase
     */
    init() {}
    
    /*
     * Function to write new post to Firebase
     */
    func createPost() {        
        // Set Date to time that the actual Post is posted
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        self.timeStamp = dateFormatter.string(from: date)
        
        // Create JSON-like object for data storage
        var newPost: [String: Any] = [  /*"authorID": self.authorID,*/
                                        "title": self.title,
                                        "content": self.content,
                                        "timeStamp": self.timeStamp ]
        
        // Add image if possible
        if let imageURL = self.imageURL {
            newPost["imageURL"] = imageURL.absoluteString
        }
        // Upload Post to Firebase
        self.ref.child(self.postID).setValue(newPost)
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
    
    /*
     * Function to get generate postID
     */
    func getPostID() -> String {
        return self.postID
    }
    
    /*
     * Function to set the image URL
     */
    func setPostMediaURL(imageURL: URL) {
        self.imageURL = imageURL
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
