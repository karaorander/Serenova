//
//  BlockedTests.swift
//  Serenova 2.0Tests
//
//  Created by Ishwarya Samavedhi on 3/29/24.
//

import XCTest
@testable import Serenova_2_0 // Import your app module

class OtherAccountViewModelTests: XCTestCase {
    
    var viewModel: OtherAccountViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = OtherAccountViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    // Test blocking a user
    func testBlockUser() {
        // Given
        let blockedUserID = "0UDIT7dajIN3jm2tqNnDT9DgVHr2"
        
        // When
        viewModel.blockUser(blockedUserID: blockedUserID)
        
        // Then
        XCTAssertFalse(viewModel.isBlocked, "Blocking user should set isBlocked to true")
    }
    
    // Test unblocking a user
    func testUnblockUser() {
        // Given
        let blockedUserID = "0UDIT7dajIN3jm2tqNnDT9DgVHr2"
        viewModel.isBlocked = true // Assume the user is already blocked
        
        // When
        viewModel.unblockUser(blockedUserID: blockedUserID)
        
        // Then
        XCTAssertTrue(viewModel.isBlocked, "Unblocking user should set isBlocked to false")
    }
}
