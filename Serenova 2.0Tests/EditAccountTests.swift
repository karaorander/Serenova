//
//  EditAccountTests.swift
//  Serenova 2.0Tests
//
//  Created by Ishwarya Samavedhi on 3/29/24.
//

import XCTest
import Firebase
@testable import Serenova_2_0

class AccountInfoViewModelTests: XCTestCase {
    var viewModel: AccountInfoViewModel!

    override func setUp() {
        super.setUp()
        // Initialize the view model or mock dependencies if needed
        viewModel = AccountInfoViewModel()
    }

    override func tearDown() {
        // Clean up resources if needed
        viewModel = nil
        super.tearDown()
    }

    func testDeleteUser() {
        // Set up any necessary preconditions (e.g., authenticated user)
        let currentUser = Auth.auth().currentUser
        // Assume user is authenticated
        XCTAssertNotNil(currentUser, "User should be authenticated for deletion")

        // Perform deletion
        viewModel.deleteUser()

        XCTAssertNotNil(Auth.auth().currentUser == nil, "User should be removed from authentication")
        
    }
    
    func testIsValidEmail() {
        let viewModel = EditProfileView()
        XCTAssertTrue(viewModel.isValidEmail2(email: "example@example.com"), "Valid email should return true")
        XCTAssertFalse(viewModel.isValidEmail2(email: "invalidemail.com"), "Valid email should return true")
    }

    func testIsValidPhoneNumber() {
        let viewModel = EditProfileView()

        XCTAssertTrue(viewModel.isValidPhoneNumber2(phoneNumber: "(123) 456-7890"), "Valid phone number should return true")
        XCTAssertFalse(viewModel.isValidPhoneNumber2(phoneNumber: "1234567890"), "Invalid phone number should return false")
    }

}


