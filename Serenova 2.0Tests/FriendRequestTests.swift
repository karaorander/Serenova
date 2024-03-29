import XCTest
import Firebase
@testable import Serenova_2_0

protocol PermissionsServiceProtocol {
    func canSendFriendRequest(to userID: String, completion: @escaping (Bool) -> Void)
    func canViewProfile(of userID: String, completion: @escaping (Bool) -> Void)
    // Add other permission-related methods as needed
}

class RequestViewModel2: ObservableObject {
    var permissionsService: PermissionsServiceProtocol

    init(permissionsService: PermissionsServiceProtocol) {
        self.permissionsService = permissionsService
    }

    func checkCanSendFriendRequest(to userID: String, completion: @escaping (Bool) -> Void) {
        permissionsService.canSendFriendRequest(to: userID) { canSend in
            completion(canSend)
        }
    }

    func checkCanViewProfile(of userID: String, completion: @escaping (Bool) -> Void) {
        permissionsService.canViewProfile(of: userID) { canView in
            completion(canView)
        }
    }
}

class MockPermissionsService2: PermissionsServiceProtocol {
    var canSendFriendRequestResult = false
    var canViewProfileResult = false

    func canSendFriendRequest(to userID: String, completion: @escaping (Bool) -> Void) {
        completion(canSendFriendRequestResult)
    }

    func canViewProfile(of userID: String, completion: @escaping (Bool) -> Void) {
        completion(canViewProfileResult)
    }
}

class RequestViewModelTests2: XCTestCase {
    var viewModel: RequestViewModel2!
    var mockPermissionsService: MockPermissionsService2!

    override func setUp() {
        super.setUp()
        mockPermissionsService = MockPermissionsService2()
        viewModel = RequestViewModel2(permissionsService: mockPermissionsService)
    }

    func testCanSendFriendRequest() {
        mockPermissionsService.canSendFriendRequestResult = true
        let userID = "QTtHOTNo0qazEobpeMzfRZbxgQv1"
        
        let expectation = XCTestExpectation(description: "Check can send friend request")

        viewModel.checkCanSendFriendRequest(to: userID) { canSend in
            XCTAssertTrue(canSend, "Should be able to send friend request")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }

    func testCanViewProfile() {
        mockPermissionsService.canViewProfileResult = true
        let userID = "QTtHOTNo0qazEobpeMzfRZbxgQv1"

        let expectation = XCTestExpectation(description: "Check can view profile")

        viewModel.checkCanViewProfile(of: userID) { canView in
            XCTAssertTrue(canView, "Should be able to view profile")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
