import XCTest
@testable import Serenova_2_0 // Import your app module here

// Import required modules

// Import required modules



import XCTest
@testable import Serenova_2_0

class ManualLogViewTests: XCTestCase {
    
    var manualLogView: ManualLogView!
    
    override func setUp() {
        super.setUp()
        manualLogView = ManualLogView()
    }
    
    override func tearDown() {
        manualLogView = nil
        super.tearDown()
    }
    
    // Test case for logging sleep time
    func testLogSleepTime() {
         // Set up your test scenario
         
         // Assuming some test values for sleep start and end
         let sleepStart = Date()
         let sleepEnd = sleepStart.addingTimeInterval(8 * 3600) // 8 hours sleep duration
         
         // Call the function to log sleep time
         manualLogView.creatManualSession(sleepStart: sleepStart, sleepEnd: sleepEnd, date: sleepStart, duration: 8 * 3600)
         
         // Check if the moon count updates correctly based on sleep duration range
         if let user = currUser {
             if (abs(8 - Int(user.totalSleepGoalHours)) < 5) {
                 XCTAssertEqual(user.moonCount, 20, "Moon count should increase by 20 for sleep duration within the range")
             } else {
                 XCTAssertEqual(user.moonCount, 0, "Moon count should not increase for sleep duration outside the range")
             }
         } else {
             XCTAssertNil(currUser)
         }
     }
}
