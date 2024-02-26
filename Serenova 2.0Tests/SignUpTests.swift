
//
//  Serenova_2_0Tests.swift
//  Serenova 2.0Tests
//
//  Created by Ishwarya Samavedhi on 2/18/24.
//

import XCTest
@testable import Serenova_2_0 // Replace with your actual app module name

class SignUpViewTests: XCTestCase {
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    func testValidEmail() {
        XCTAssertTrue(isValidEmail("test@example.com"), "Email validation failed for a valid email address.")
    }

    func testInvalidEmail() {
        // Test for invalid email
        XCTAssertFalse(isValidEmail("testexample.com"), "Email validation passed for an invalid email address.")
    }

    func isValidPhoneNumber(_ phone: String) -> Bool {
        // Adjust the regular expression to match your expected phone number format
        return phone.contains(/^\([0-9]{3}\) [0-9]{3}-[0-9]{4}$/)
    }

    func testValidPhoneNumber() {
        // Test for valid phone number
        XCTAssertTrue(isValidPhoneNumber("(636) 568-8483"), "Phone number validation failed for a valid phone number.")
    }

    func testInvalidPhoneNumber() {
        // Test for invalid phone number
        XCTAssertFalse(isValidPhoneNumber("777"), "Phone number validation passed for an invalid phone number.")
    }

    
    func isValidLength(_ password: String) -> Bool {
            // 1) Password must be at least 8 characters
            return password.count >= 8
        }
        
        func hasSpecialChar(_ password1: String) -> Bool {
            // 2) Password must contain at least one special character
            return password1.contains(/[\W]/) && !password1.contains(/[_]/)
        }
        
        func hasUppercaseChar(_ password1: String) -> Bool {
            // 3) Password must contain an uppercase letter
            return password1.contains(where: {$0.isUppercase})
        }
        
        func hasNumber(_ password1: String) -> Bool {
            // 4) Password must contain a number
            return password1.contains(where: {$0.isNumber})
        }
        
        func isValidPassword(_ password: String) -> Bool {
            // Ensure password matches criteria
            return isValidLength(password) && hasSpecialChar(password) && hasUppercaseChar(password) && hasNumber(password)
        }
    
    func isValidConfirmedPassword(_ confirmedPassword: String,_ originalPassword: String) -> Bool {
        // Check if the confirmed password matches the original password and is valid
        if (confirmedPassword.isEmpty || confirmedPassword != originalPassword || !isValidPassword(confirmedPassword)) {
            return false
        }
        return true
    }
    

    
    func testValidPassword() {
           XCTAssertTrue(isValidPassword("Valid12!"), "Password validation failed for a valid password.")
       }
       
       func testInvalidPasswordLength() {
           XCTAssertFalse(isValidPassword("Short1!"), "Password validation passed for a password that is too short.")
       }

       func testValidConfirmedPassword() {
           XCTAssertTrue(isValidConfirmedPassword("Valid123!", "Valid123!"), "Confirmed password validation failed for matching passwords.")
       }

       func testInvalidConfirmedPassword() {
           XCTAssertFalse(isValidConfirmedPassword("Valid1!", "Different2!"), "Confirmed password validation passed for non-matching passwords.")
       }
    
    func testPasswordWithoutSpecialCharacter() {
            XCTAssertFalse(isValidPassword("Password1"), "Password validation passed for a password without a special character.")
        }
        
        func testPasswordWithSpecialCharacter() {
            XCTAssertTrue(isValidPassword("Password1!"), "Password validation failed for a password with a special character.")
        }
        
        // Test cases for uppercase letter requirement
        func testPasswordWithoutUppercaseLetter() {
            XCTAssertFalse(isValidPassword("password1!"), "Password validation passed for a password without an uppercase letter.")
        }
        
        func testPasswordWithUppercaseLetter() {
            XCTAssertTrue(isValidPassword("Password1!"), "Password validation failed for a password with an uppercase letter.")
        }
        
        // Test cases for number requirement
        func testPasswordWithoutNumber() {
            XCTAssertFalse(isValidPassword("Password!"), "Password validation passed for a password without a number.")
        }
        
        func testPasswordWithNumber() {
            XCTAssertTrue(isValidPassword("Password1!"), "Password validation failed for a password with a number.")
        }
        
        // Test cases for minimum length requirement
        func testShortPassword() {
            XCTAssertFalse(isValidPassword("P1!"), "Password validation passed for a password that is too short.")
        }
        
        func testMinimumLengthPassword() {
            XCTAssertTrue(isValidPassword("Passw123!"), "Password validation failed for a password that meets the minimum length requirement.")
        }
        
        // Test case for a password that meets all criteria
        func testPasswordMeetsAllCriteria() {
            XCTAssertTrue(isValidPassword("ValidPassword1!"), "Password validation failed for a password that meets all criteria.")
        }

        func testConfirmedPasswordEmpty() {
            XCTAssertFalse(isValidConfirmedPassword("Valid1!", ""), "Confirmed password validation passed for an empty confirmed password.")
        }


}
