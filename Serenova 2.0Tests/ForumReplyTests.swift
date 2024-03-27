//
//  ForumReplyTests.swift
//  Serenova 2.0Tests
//
//  Created by Samavedhi, Ishwarya Jannavi on 3/26/24.
//
/*
import XCTest
@testable import Serenova_2_0
import SwiftUI

final class ForumPostDeletionTests: XCTestCase {
    
    var forumView: ForumView!
    var postToDelete: Post!
    
    override func setUp() {
        super.setUp()
        // Initialize the ForumView and the post to delete
        forumView = ForumView()
        postToDelete = Post()
        // Simulate adding the post to the forum view's list of posts
        forumView.forumPosts.append(postToDelete)
    }
    
    override func tearDown() {
        // Clean up
        forumView = nil
        postToDelete = nil
        super.tearDown()
    }
    
    func testDeletePost() {
        // Given: A post is in the forum's post list
        let initialPostCount = forumView.forumPosts.count
        
        // When: The post is deleted
        // Assume there's a method in ForumView to delete a post by its ID or reference
        if let index = forumView.forumPosts.firstIndex(where: { $0.id == postToDelete.id }) {
            forumView.forumPosts.remove(at: index)
        }
        
        // Then: The post should no longer be in the forum's post list
        let finalPostCount = forumView.forumPosts.count
        XCTAssertLessThan(finalPostCount, initialPostCount, "Post count should decrease after deletion.")
        XCTAssertFalse(forumView.forumPosts.contains(where: { $0.id == postToDelete.id }), "Deleted post should not be in the list.")
    }
}*/
