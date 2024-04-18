//
//  SleepScoreTests.swift
//  Serenova 2.0Tests
//
//  Created by Ishwarya Samavedhi on 3/29/24.
//

import XCTest
@testable import Serenova_2_0

func calculateSleepScore(deepSleepMinutes: Int, coreSleepMinutes: Int, remSleepMinutes: Int, totalSleepMinutes: Int) -> Int {
    // Using Double for weights to match with the Double type of literals like 0.4, 0.2, etc.
    let deepSleepWeight: Double = 0.4
    let coreSleepWeight: Double = 0.2
    let remSleepWeight: Double = 0.1
    let otherSleepWeight: Double = 0.3

    // Calculate "Other" sleep minutes. Convert Int to Double for consistency in calculations.
    let otherSleepMinutes = max(0.0, Double(totalSleepMinutes) - (Double(deepSleepMinutes) + Double(coreSleepMinutes) + Double(remSleepMinutes)))

    // Calculate weighted scores for each sleep type. The result is in Double, which is consistent with the weight type.
    let deepSleepScore = Double(deepSleepMinutes) * deepSleepWeight
    let coreSleepScore = Double(coreSleepMinutes) * coreSleepWeight
    let remSleepScore = Double(remSleepMinutes) * remSleepWeight
    let otherSleepScore = otherSleepMinutes * otherSleepWeight

    // Sum up the scores and convert the total score to Int before returning.
    let totalScore = Int(deepSleepScore + coreSleepScore + remSleepScore + otherSleepScore)

    return totalScore
}

class SleepScoreTests: XCTestCase {
    
    func testCalculateSleepScore() {
        let sleepScoreView = SleepScoreView()
        let score = calculateSleepScore(deepSleepMinutes: 120, coreSleepMinutes: 180, remSleepMinutes: 90, totalSleepMinutes: 390)
        XCTAssertEqual(score, 93, "The calculated sleep score did not match the expected value.")
    }
    
    func testIdealSleepScenario() {
        let sleepScore = calculateSleepScore(deepSleepMinutes: 120, coreSleepMinutes: 240, remSleepMinutes: 90, totalSleepMinutes: 480)
        XCTAssertGreaterThan(sleepScore, 100, "The sleep score for an ideal sleep scenario should be close to 100.")
    }
    
    // Test for zero sleep scenario
    func testZeroSleepScenario() {
        let sleepScore = calculateSleepScore(deepSleepMinutes: 0, coreSleepMinutes: 0, remSleepMinutes: 0, totalSleepMinutes: 0)
        XCTAssertEqual(sleepScore, 0, "The sleep score for a zero sleep scenario should be 0.")
    }
    
    // Test for excessive sleep scenario
    func testExcessiveSleepScenario() {
        let sleepScore = calculateSleepScore(deepSleepMinutes: 180, coreSleepMinutes: 300, remSleepMinutes: 120, totalSleepMinutes: 600)
        XCTAssertGreaterThan(sleepScore, 100, "The sleep score for an excessive sleep scenario should be greater than 100.")
    }
    
    // Test for single stage sleep scenario
    func testSingleStageSleepScenario() {
        let sleepScore = SleepScoreView().calculateSleepScore(deepSleepMinutes: 480, coreSleepMinutes: 0, remSleepMinutes: 0, totalSleepMinutes: 480)
        XCTAssertGreaterThanOrEqual(sleepScore, 0, "The sleep score for a single stage sleep scenario should be greater than 0.")
    }
    
    // Test for negative values scenario
    func testNegativeValuesScenario() {
        let sleepScore = SleepScoreView().calculateSleepScore(deepSleepMinutes: -120, coreSleepMinutes: -240, remSleepMinutes: -90, totalSleepMinutes: -480)
        XCTAssertEqual(sleepScore, 0, "The sleep score for negative values should be handled gracefully, potentially defaulting to 0.")
    }
    
    func testExportSleepDataAsForumPost() {
        let viewModel = SleepScoreModel()
        viewModel.fullname = "Test User"
        
        // Simulate sleep data
        let totalSleepMin = 480
        let deepSleepMin = 240
        let coreSleepMin = 120
        let remSleepMin = 120
        
        let view = SleepScoreView(viewModel: viewModel)
        view.totalSleepMin = totalSleepMin
        view.deepSleepMin = deepSleepMin
        view.coreSleepMin = coreSleepMin
        view.remSleepMin = remSleepMin
        
        // Calculate sleep score
        let sleepScore = view.calculateSleepScore(deepSleepMinutes: deepSleepMin, coreSleepMinutes: coreSleepMin, remSleepMinutes: remSleepMin, totalSleepMinutes: totalSleepMin)
        
       
        let expectation = XCTestExpectation(description: "View appeared")
        
        // Trigger onAppear to generate export title and content
        view.onAppear {
           
            let exportTitle = view.exportTitle
            let exportContent = view.exportContent
            
            // Expected values
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMM d"
            let dateString = dateFormatter.string(from: Date())
            let expectedTitle = "\(viewModel.fullname)'s Sleep: \(dateString)"
            let expectedContent = "💫 \(viewModel.fullname)'s sleep score of the day: \(sleepScore)\n\nThe breakdown:\n\(totalSleepMin) minutes in total\n\(deepSleepMin) minutes spent in deep sleep\n\(coreSleepMin) minutes spent in light sleep\n\(remSleepMin) minutes spent in REM"
            
            XCTAssertEqual(exportTitle, expectedTitle)
            XCTAssertEqual(exportContent, expectedContent)
            
            
            expectation.fulfill()
        }
        
        
    }
}

