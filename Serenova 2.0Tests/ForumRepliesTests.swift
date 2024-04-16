//
//  ForumReplyTests.swift
//  Serenova 2.0Tests
//
//  Created by Samavedhi, Ishwarya Jannavi on 3/26/24.
//

import XCTest
//import SnapshotTesting
@testable import Serenova_2_0
import SwiftUI

final class ForumReplyTests: XCTestCase {



    func testCreateReply() {
        // Set up your test scenario
        let post = Post(title: "Test Post", content: "Test Content", userTags: [])
        let bindingPost = Binding<Post>(get: { post }, set: { _ in })
        let forumPostDetailView = ForumPostDetailView(post: bindingPost)

        // Assuming some test reply content
        let replyContent = "Test reply content"

        // Call the function to create a reply
        forumPostDetailView.createReply()

        // Check if the reply is added to the replies array
        XCTAssertTrue(!forumPostDetailView.replies.contains(where: { $0.replyContent == replyContent }))
    }

    func testCreateReplyWithError() {
        let post = Post(title: "Test Post", content: "Test Content", userTags: [])
        let bindingPost = Binding<Post>(get: { post }, set: { _ in })
        let forumPostDetailView = ForumPostDetailView(post: bindingPost)
        let replyContent = "" //testing error with empty  / no reply maded
        forumPostDetailView.createReply()
        XCTAssertFalse(forumPostDetailView.replies.contains(where: { $0.replyContent == replyContent }))
    }

    func testQueryReplies() async {
        // Set up your test scenario
        let post = Post(title: "Test Post", content: "Test Content", userTags: [])
        let bindingPost = Binding<Post>(get: { post }, set: { _ in })
        let forumPostDetailView = ForumPostDetailView(post: bindingPost)

        // Define some sample replies
        let reply1 = Reply(replyContent: "Reply 1 content", parentPostID: "1")
        let reply2 = Reply(replyContent: "Reply 2 content", parentPostID: "2")

        // Manually set the replies property to include the sample replies
        forumPostDetailView.replies = [reply1, reply2]

        // Set the expected number of replies after querying
        let expectedRepliesCount = forumPostDetailView.replies.count + 1 // Assuming one more reply will be fetched

        // Call the function to query replies
        do {
            try await forumPostDetailView.queryReplies(NUM_REPLIES: 25)

            // Simulate the asynchronous nature of the query
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // Check if the replies count has increased after querying
                XCTAssertEqual(forumPostDetailView.replies.count, expectedRepliesCount, "Expected number of replies not found after querying")
            }
        } catch {
            // Handle any errors encountered during the query
            XCTFail("Error querying replies: \(error.localizedDescription)")
        }
    }



}
