//
//  TipsTests.swift
//  Serenova 2.0Tests
//
//  Created by Ishwarya Samavedhi on 4/18/24.
//

import XCTest
@testable import Serenova_2_0 // Import your app module

class TipsViewTests: XCTestCase {
    
    func testGetRelevantTips() {
        // Create an instance of TipsViewModel
        let viewModel = TipsViewModel()
        
        // Assuming some user data is set
        viewModel.hasinsomnia = true
        viewModel.age = 25
        viewModel.gender = "female"
        viewModel.snore = true
        
        // Create an instance of TipsView
        let tipsView = TipsView()
        
        // Call the function to get relevant tips
        let relevantTips = tipsView.get_relevent_tips()
        
        // Check if the relevant tips are fetched correctly
        XCTAssertFalse(relevantTips.isEmpty, "Relevant tips should not be empty")
        // You can add more assertions based on your logic and expected behavior
    }
    
    func testGetRelevantVideoURLs() {
        // Create an instance of TipsViewModel
        let viewModel = TipsViewModel()
        
        // Assuming some user data is set
        viewModel.hasinsomnia = true
        viewModel.age = 25
        viewModel.gender = "female"
        viewModel.snore = true
        
        // Create an instance of TipsView
        let tipsView = TipsView()
        
        // Call the function to get relevant video URLs
        let relevantVideoURLs = tipsView.get_relevant_video_urls()
        
        // Check if the relevant video URLs are fetched correctly
        XCTAssertFalse(relevantVideoURLs.isEmpty, "Relevant video URLs should not be empty")
        // You can add more assertions based on your logic and expected behavior
    }
    
}
