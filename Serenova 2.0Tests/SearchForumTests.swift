//
//  SearchForumTests.swift
//  Serenova 2.0Tests
//
//  Created by Ishwarya Samavedhi on 3/29/24.
//

import XCTest
@testable import Serenova_2_0
import Foundation
import Combine
import SwiftUI


class ForumViewModel: ObservableObject {
    @Published var posts: [Post3] = []
    @Published var displayedPosts: [Post3] = []
    var filterOptions: [String] = ["None", "Most Recent", "Least Recent", "Most Replies"]
    var tagOptions: [String] = ["None", "Questions", "Tips", "Hacks", "Support", "Goals", "Midnight Thoughts"]

    func searchPosts(searchText: String, filterOption: Int, tagOption: Int) {
        var tempPosts = posts

        // Keyword Search
        if !searchText.isEmpty {
            tempPosts = tempPosts.filter { $0.title.contains(searchText) }
        }

        // Filter
        switch filterOption {
        case 1: // Most Recent
            tempPosts = tempPosts.sorted { $0.timeStamp > $1.timeStamp }
        case 2: // Least Recent
            tempPosts = tempPosts.sorted { $0.timeStamp < $1.timeStamp }
        case 3: // Most Replies
            tempPosts = tempPosts.sorted { $0.numReplies > $1.numReplies }
        default:
            break
        }

        // Tags
        if tagOption != 0 {
            tempPosts = tempPosts.filter { $0.tag == tagOptions[tagOption] }
        }

        displayedPosts = tempPosts
    }

    // Add methods to retrieve and manage posts as needed...
}
struct SearchForumView: View {
    @StateObject var viewModel = ForumViewModel()
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search by single keyword", text: $searchText)
                    .padding()
                    .onChange(of: searchText) { newValue in
                        viewModel.searchPosts(searchText: newValue, filterOption: 0, tagOption: 0)
                    }

                List(viewModel.displayedPosts) { post in
                    Text(post.title) // Customize as needed
                }
            }
            .navigationBarTitle("Search Forum")
        }
        .onAppear {
            // Fetch posts if needed
        }
    }
}

// Assuming you have a basic Post model
struct Post3: Identifiable {
    var id = UUID()
    var title: String
    var timeStamp: Double
    var numReplies: Int
    var tag: String?
}

class ForumViewModelTests: XCTestCase {
    var viewModel: ForumViewModel!

    override func setUp() {
        super.setUp()
        viewModel = ForumViewModel()
        viewModel.posts = [
            Post3(title: "SwiftUI Tips", timeStamp: 1000, numReplies: 10, tag: "Tips"),
            Post3(title: "Understanding Combine", timeStamp: 2000, numReplies: 20, tag: "Hacks")
        ]
    }

    func testSearchByText() {
        viewModel.searchPosts(searchText: "SwiftUI", filterOption: 0, tagOption: 0)
        XCTAssertEqual(viewModel.displayedPosts.count, 1)
        XCTAssertEqual(viewModel.displayedPosts.first?.title, "SwiftUI Tips")
    }

    func testFilterByMostRecent() {
        viewModel.searchPosts(searchText: "", filterOption: 1, tagOption: 0)
        XCTAssertEqual(viewModel.displayedPosts.first?.title, "Understanding Combine")
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
}
