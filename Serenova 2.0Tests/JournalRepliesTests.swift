//
//  JournalRepliesTests.swift
//  Serenova 2.0Tests
//
//  Created by Ishwarya Samavedhi on 4/18/24.
//

import XCTest
@testable import Serenova_2_0
import SwiftUI

final class JournalRepliesTests: XCTestCase {

    func testCreateReply() async {
        // Set up your test scenario
        let journal = Journal(journalTitle: "Test Journal", journalContent: "Test Content")
        journal.journalId = "y1glIRTj3qM9NcrZQXES"
        let replyContent = "Test reply content"
        let journalReply = JournalReply(replyContent: replyContent, parentPostID: journal.journalId!)

        // Call the function to create a reply
        do {
            try await journalReply.createReply()

            // Check if the reply is added successfully
            XCTAssertNotNil(journalReply.replyID, "Reply ID should not be nil after creation")
        } catch {
            // Handle any errors encountered during the creation of the reply
            XCTFail("Error creating reply: \(error.localizedDescription)")
        }
    }

    func testCreateReplyWithError() async {
        // Set up your test scenario
        let journal = Journal(journalTitle: "Test Journal", journalContent: "Test Content")
        journal.journalId = "y1glIRTj3qM9NcrZQXES"
        let replyContent = "" // Testing error with empty / no reply made
        let journalReply = JournalReply(replyContent: replyContent, parentPostID: "1")

        // Call the function to create a reply
        do {
            try await journalReply.createReply()

            // Check if the reply is added successfully (which should not happen in this case)
            XCTAssertNil(journalReply.replyID, "Reply ID should be nil due to error")
        } catch {
            // Check if the error is as expected
            XCTAssertEqual(error.localizedDescription, "No document to update: projects/serenova-59d2c/databases/(default)/documents/Journal/1", "Unexpected error message")
        }
    }

    func testQueryReplies() async {
        // Set up your test scenario
        let journal = Journal(journalTitle: "Test Journal", journalContent: "Test Content")
        var journalListingView = JournalListingView2(journal: journal)
        var journalReplies: [JournalReply] = []

        // Define some sample replies
        let reply1 = JournalReply(replyContent: "Reply 1 content", parentPostID: "1")
        let reply2 = JournalReply(replyContent: "Reply 2 content", parentPostID: "2")

        // Manually set the replies property to include the sample replies
        journalReplies = [reply1, reply2]
        let expectedRepliesCount = journalReplies.count + 1

        
        do {
            try await journalListingView.queryReplies(NUM_REPLIES: 25)

            // Simulate the asynchronous nature of the query
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // Check if the replies count has increased after querying
                XCTAssertEqual(journalListingView.replies.count, expectedRepliesCount, "Expected number of replies not found after querying")
            }
        } catch {
            // Handle any errors encountered during the query
            XCTFail("Error querying replies: \(error.localizedDescription)")
        }
        
    }
    
    


}
