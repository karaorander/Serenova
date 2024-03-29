import XCTest
@testable import Serenova_2_0

import XCTest
@testable import Serenova_2_0
var viewModel2: MoonProgressViewModel!

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


class RewardsDashboardViewTests: XCTestCase {
    
    var viewModel: MoonProgressViewModel!
    var rewardsDashboardView: RewardsDashboardView!
    
    override func setUp() {
        super.setUp()
        viewModel = MoonProgressViewModel()
        rewardsDashboardView = RewardsDashboardView()
    }
    
    override func tearDown() {
        viewModel = nil
        rewardsDashboardView = nil
        super.tearDown()
    }
    
    func testFetchMoons() {

        viewModel.fetchMoons()
        var updateVal: Int = -1
        if let user = currUser {
            updateVal = user.moonCount
            user.moonCount = -1; // reset
        }
        XCTAssertEqual(viewModel.moonCount, -1, "Initial moon count should be -1")
        viewModel.fetchMoons()
        XCTAssertEqual(viewModel.moonCount, updateVal, "Moon count should be updated after fetching")
    }
    
    func testRewardsIsEmpty() {
        // Case when moon count is 0
        if let user = currUser {
            currUser?.moonCount = 0
            XCTAssertEqual(rewardsDashboardView.rewardsIsEmpty(), 0, "Rewards should be considered empty when moon count is 0")
        }
        
        // Case when moon count is not 0
        currUser?.moonCount = 100
        XCTAssertEqual(rewardsDashboardView.rewardsIsEmpty(), 1, "Rewards should not be considered empty when moon count is not 0")
    }
    
    func testGetFriendsRewardCount() {
        
        do {
            var user = try User(userID: "Tester", name: "Tester", email: "Tester@example.com", phoneNumber: "1234567890")

            let initialMoonCount = user.moonCount
            let rewardCount = 50
            user.updateMoons(rewardCount: rewardCount)
            let moons = initialMoonCount + rewardCount
            
            XCTAssertNotEqual(user.moonCount, moons)
        } catch {
            XCTFail("Failed to create user: \(error.localizedDescription)")
        }
    }
}
