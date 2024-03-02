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
    let healthStore = HKHealthStore()

    override func setUpWithError() throws {
        try super.setUpWithError()
        sleepManager = SleepManager()
    }

    override func tearDownWithError() throws {
        sleepManager = nil
        try super.tearDownWithError()
    }

    func testHKQuery() {
        let expectation = XCTestExpectation(description: "Query sleep data from HealthKit")
        
        healthStore.requestAuthorization(toShare: nil, read: [HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!]) { (success, error) in
            if success {
                self.sleepManager.querySleepData(for: Date())
                if  self.sleepManager.sleepSamples.isEmpty{
                    print("no sleep data")
                } else {
                    XCTAssertFalse(self.sleepManager.sleepSamples.isEmpty)
                }
                expectation.fulfill()
            } else {
                XCTFail("Failed to request authorization for HealthKit")
            }
        }
        wait(for: [expectation], timeout: 10.0)
    }
}
