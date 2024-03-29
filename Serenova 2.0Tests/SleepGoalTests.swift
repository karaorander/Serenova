//
//  SleepGoalTests.swift
//  Serenova 2.0Tests
//
//  Created by Voorhees, Mary Nicole on 3/28/24.
//

import XCTest
@testable import Serenova_2_0 // Import your app module here

// Import required modules

// Import required modules



import XCTest
@testable import Serenova_2_0
//var viewModel: EditGoalsView!

class SleepGoalsViewTests: XCTestCase {
    
    var sleepGoalsView: GoalViewModel!
    var editRewardsView: EditGoalsView!

        
    override func setUp() {
        super.setUp()
        sleepGoalsView = GoalViewModel()
        editRewardsView = EditGoalsView()
    }
    
    override func tearDown() {
        sleepGoalsView = nil
        editRewardsView = nil
        super.tearDown()
    }
    
    func testGetTotalGoal() {
        let updateHrs = 7
        let updateMins = 30
        
        if let user = currUser {
            user.totalSleepGoalHours = Float(updateHrs)
            user.totalSleepGoalMins = Float(updateMins)
            var totalGoal = (updateHrs * 60) + updateMins
                            
            XCTAssertEqual(editRewardsView.getTotalGoal(), Float(totalGoal))
        }
    }
    
    func testGetDeepGoal() {
        let updateHrs = 5
        let updateMins = 45
        
        if let user = currUser {
            user.deepSleepGoalHours = Float(updateHrs)
            user.deepSleepGoalMins = Float(updateMins)
            var deepGoal = (updateHrs * 60) + updateMins
                            
            XCTAssertEqual(editRewardsView.getDeepGoal(), Float(deepGoal))
        }
    }
    
}
