//
//  ForumTagUserTests.swift
//  Serenova 2.0Tests
//
//  Created by Ava Schrandt on 4/19/24.
//

import XCTest
@testable import Serenova_2_0
import Foundation
import Combine
import SwiftUI

class ForumTagTests: XCTestCase {
    

    var viewModel: ForumPostViewModel!

        override func setUp() {
            super.setUp()
            viewModel = ForumPostViewModel()
        }

        override func tearDown() {
            viewModel = nil
            super.tearDown()
        }

        func testTaggingMultipleUsers() {
            viewModel.selectedFriends = Set(["Friend1", "Friend2", "Friend3"])
            
            // Verify tagging
            XCTAssertEqual(viewModel.selectedFriends, Set(["Friend1", "Friend2", "Friend3"]), "Tagging users failed")
            
        }
    
    func testTaggingNoUsers() {
        let view = ForumPostView(postText: "", postTitle: "")
        view.createPost()
        XCTAssertEqual(view.selectedFriends, Set<String>())
    }
    
    func testFetchAllFriendIDs() {
          
        let forumPostView = ForumPostView(postText: "", postTitle: "")
            forumPostView.fetchAllFriendIDs { friendIDs, error in
                // Assert that friend IDs are fetched or handle error
                XCTAssertNotNil(friendIDs)
                XCTAssertNil(error)
            }
        }
    
}


