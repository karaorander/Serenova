//
//  ForumDeleteTests.swift
//  Serenova 2.0Tests
//
//  Created by Ishwarya Samavedhi on 3/27/24.
//
/*
import XCTest
@testable import Serenova_2_0

final class ForumDeleteTests: XCTestCase {
    
    var sut: ForumView!
    
    override func setUp() {
        super.setUp()
        sut = ForumView()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testDeletingPost() {
        // Given
        let initialPostCount = sut.forumPosts.count
        let postToAddAndDelete = Post()
        sut.forumPosts.append(postToAddAndDelete) // Simulate adding a post
        guard let postIDToDelete = postToAddAndDelete.postID else {
            XCTFail("Post ID should be available.")
            return
        }
        
        // When
        if let index = sut.forumPosts.firstIndex(where: { $0.postID == postIDToDelete }) {
            sut.forumPosts.remove(at: index) // Simulate deleting the post
        }
        
        // Then
        XCTAssertEqual(sut.forumPosts.count, initialPostCount, "Post should be deleted from the forumPosts array")
        XCTAssertFalse(sut.forumPosts.contains(where: { $0.postID == postIDToDelete }), "Deleted post should not exist in forumPosts array")
    }
}
*/
