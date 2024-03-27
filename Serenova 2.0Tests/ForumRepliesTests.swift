//
//  ForumRepliesTests.swift
//  Serenova 2.0Tests
//
//  Created by Samavedhi, Ishwarya Jannavi on 3/26/24.
//

import XCTest
import FirebaseFirestoreSwift
import FirebaseFirestore
@testable import Serenova_2_0


final class ForumViewTests: XCTestCase {
    
    var sut: ForumView!
    
    override func setUp() {
        super.setUp()
        sut = ForumView()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testAddingReplyToPost() {
        // Given
        let post = Post() // Create a mock post
        let replyContent = "This is a test reply"
        
        // When
        post.addReply(content: replyContent)
        XCTAssertEqual(post.replies.last?.content, replyContent)
    }
}

class Post {
    var replies: [Reply] = []
    var content: String = ""
    
    func addReply(content: String) {
        let reply = Reply(content: content)
        replies.append(reply)
    }
}

struct Reply {
    var content: String
}
