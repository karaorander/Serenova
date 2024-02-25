//
//  Post.swift
//  Serenova 2.0
//
//  Created by Caitlin Wilson on 2/19/24.
//
import Foundation
import FirebaseDatabase

class Post {
    //var authorID: String = ""
    //var authorUserName: String = ""
    var title: String = ""
    var content: String = ""
    var timeStamp: String = ""
    // var likeIDs: [String] = []
    // var userProfileURL: URL
    // var imageURL: URL?
    // var imageReferenceID: String = ""
    // var likeIDs: [String] = []
    
    // *** If we want to use structs instead
    // *** just move the necessary code wherever
    
    /*
     * Constructor for creating new post
     */
    init(title: String, content: String) {
        //self.authorID = authorID
        self.title = title
        self.content = content
        
        // Set correct date format
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        self.timeStamp = dateFormatter.string(from: date)
        
        self.writePost()
    }
    
    /*
     * TODO: Constructor to read posts from Firebase
     */
    init() {}
    
    /*
     * Function to write new post to Firebase
     */
    func writePost() {
        let ref: DatabaseReference! = Database.database().reference().child("Post")
        
        // Create JSON-like object for data storage
        let newPost: [String: Any] = [  /*"authorID": self.authorID,*/
                                        "title": self.title,
                                        "content": self.content,
                                        "timeStamp": self.timeStamp   ]
        // Upload post to Firebase
        ref.childByAutoId().setValue(newPost)
    }
    
    /*
     * TODO: Function to update value(s) to Firebase
     */
    
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
