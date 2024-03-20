//
//  SleepManagerTests.swift
//  Serenova 2.0Tests
//
//  Created by Ava Schrandt on 2/28/24.
//

import XCTest
import HealthKit
@testable import Serenova_2_0


class SleepManagerTests: XCTestCase {
    
    var sleepManager: SleepManager!
    
    override func setUp() {
        super.setUp()
        sleepManager = SleepManager()
    }
    
    override func tearDown() {
        sleepManager = nil
        super.tearDown()
    }
    
    /**that data is not nil for query of specific date**/
    func testQuerySleepData() {
        let expectation = XCTestExpectation(description: "Query Sleep Data")
        let testDate = Date()
        
        sleepManager.querySleepData(completion: { totalSleepDuration, deepSleepDuration, coreSleepDuration, remSleepDuration in
            XCTAssertNotNil(totalSleepDuration, "Total sleep duration should not be nil")
            
            expectation.fulfill()
        }, date: testDate)
    }
    
    /**Testing for authorization success  detection**/
    func testAuthorizationSuccess() {
            
            let authorizationExpectation = expectation(description: "Authorization expectation")
            
            // Set up a mock health store that always returns success
            class MockHealthStore: HKHealthStore {
                override func requestAuthorization(toShare typesToShare: Set<HKSampleType>?, read typesToRead: Set<HKObjectType>?, completion: @escaping (Bool, Error?) -> Void) {
                    completion(true, nil)
                }
            }
            
            let healthStore = MockHealthStore()
            sleepManager.requestAuthorization()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                
                XCTAssertTrue(self.sleepManager.authenticated)
                authorizationExpectation.fulfill()
            }
            
            waitForExpectations(timeout: 2.0, handler: nil)
        }
        
    /**Testing for authorization failure detection**/
        func testAuthorizationFailure() {
            let authorizationExpectation = expectation(description: "Authorization expectation")
            
            class MockHealthStore: HKHealthStore {
                override func requestAuthorization(toShare typesToShare: Set<HKSampleType>?, read typesToRead: Set<HKObjectType>?, completion: @escaping (Bool, Error?) -> Void) {
                    completion(false, NSError(domain: "TestErrorDomain", code: 123, userInfo: nil))
                }
            }
            sleepManager.healthStore = MockHealthStore()
            
            sleepManager.requestAuthorization()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                XCTAssertFalse(self.sleepManager.authenticated)
                authorizationExpectation.fulfill()
            }
            waitForExpectations(timeout: 2.0, handler: nil)
        }
}
