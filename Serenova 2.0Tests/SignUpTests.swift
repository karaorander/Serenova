//
//  Serenova_2_0Tests.swift
//  Serenova 2.0Tests
//
//  Created by Ishwarya Samavedhi on 2/18/24.
//

import XCTest
@testable import Serenova_2_0

class SignUpTests: XCTestCase {

    var signUpView: SignUpView!

    override func setUpWithError() throws {
        super.setUp()
        signUpView = SignUpView()
    }

    override func tearDownWithError() throws {
        signUpView = nil
        super.tearDown()
    }

    func testEmptyFields() {
        signUpView.createUser()
        XCTAssertTrue(signUpView.getName().isEmpty, "Name field should be empty.")
        XCTAssertTrue(signUpView.getEmail().isEmpty, "Email field should be empty.")
    }

    func testPasswordMismatch() {
        signUpView.setPassword1("password1")
        signUpView.setPassword2("password2")
        signUpView.createUser()
        XCTAssertEqual(signUpView.getPassword1(), "password1", "Password1 should not be modified.")
        XCTAssertEqual(signUpView.getPassword2(), "password2", "Password2 should not be modified.")
    }

    func testWeakPassword() {
        signUpView.setPassword1("weak")
        signUpView.setPassword2("weak")

        let expectation = XCTestExpectation(description: "Weak password error message printed")

        let app = XCUIApplication()
        addUIInterruptionMonitor(withDescription: "Alert") { alert -> Bool in
            if alert.staticTexts["Error! Need at least 8 characters!"].exists {
                expectation.fulfill()
            }
            return true
        }

        signUpView.createUser()

        wait(for: [expectation], timeout: 5)
    }

    func testInvalidEmailFormat() {
        signUpView.setEmail("invalidemail")

        let expectation = XCTestExpectation(description: "Invalid email error message printed")

        let app = XCUIApplication()
        addUIInterruptionMonitor(withDescription: "Alert") { alert -> Bool in
            if alert.staticTexts["Error! Invalid Email Entered"].exists {
                expectation.fulfill()
            }
            return true
        }

        signUpView.createUser()

        wait(for: [expectation], timeout: 5)
    }

}
