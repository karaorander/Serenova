//
//  Post.swift
//  Serenova 2.0
//
//  Created by Caitlin Wilson on 2/19/24.
//
import Foundation
class Post {
    var postTitle: String = ""
    var postContent: String = ""
    var isPublished: Bool = false
    
    init() {}
}

/// post model example including likes, image urls, etc
/*
struct Post: Identifiable, Codable {
    @DocumentID var id: String?
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
