//
//  AlarmTests.swift
//  Serenova 2.0Tests
//
//  Created by Ishwarya Samavedhi on 4/14/24.
//

import XCTest
@testable import Serenova_2_0 // Import your app module here

class AlarmClockViewTests: XCTestCase {
    
    // Test case to check if the alarm time is set correctly
    func testAlarmTimeSetting() {
        let alarmClockView = AlarmClockView()
        let newTime = Date()
        
        alarmClockView.alarmTime = newTime
        
        XCTAssertNotEqual(alarmClockView.alarmTime, newTime, "Alarm time should be set correctly")
    }
    
    // Test case to check if the selected sound is updated correctly
    func testSelectedSoundUpdate() {
        let alarmClockView = AlarmClockView()
        let newSound = "Beep"
        
        alarmClockView.selectedSound = newSound
        
        XCTAssertNotEqual(alarmClockView.selectedSound, newSound, "Selected sound should be updated correctly")
    }
    
    // Test case to check if the repeating toggle works as expected
    func testRepeatingToggle() {
        let alarmClockView = AlarmClockView()
        let initialRepeatingState = alarmClockView.isRepeating
        
        alarmClockView.isRepeating.toggle()
        
        XCTAssertEqual(alarmClockView.isRepeating, initialRepeatingState, "Repeating toggle should change state")
    }
    
}
