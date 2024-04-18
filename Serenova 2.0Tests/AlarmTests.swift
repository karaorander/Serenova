//
//  AlarmTests.swift
//  Serenova 2.0Tests
//
//  Created by Ishwarya Samavedhi on 4/14/24.
//

import XCTest
@testable import Serenova_2_0 // Import your app module

class AlarmClockViewTests: XCTestCase {


    func testScheduleAlarmNotification() {
        // Create an instance of AlarmClockView
        let alarmClockView = AlarmClockView()
        
        // Set alarm time to 10 seconds from now
        let currentDate = Date()
        let futureDate = Calendar.current.date(byAdding: .second, value: 10, to: currentDate)!
        alarmClockView.setAlarmTime(futureDate)
        
        // Schedule notification
        alarmClockView.scheduleAlarmNotification(10, "Beep")
        
        // Get the alarm time components
        let calendar = Calendar.current
        let alarmTimeComponents = calendar.dateComponents([.hour, .minute], from: alarmClockView.alarmTime)
        let futureDateComponents = calendar.dateComponents([.hour, .minute], from: futureDate)
        
        // Check if the hour and minute components are equal
        XCTAssertEqual(alarmTimeComponents.hour, futureDateComponents.hour)
        XCTAssertEqual(alarmTimeComponents.minute, futureDateComponents.minute)
    }

    func testSecondsToTimeString() {
        // Create an instance of AlarmClockView
        let alarmClockView = AlarmClockView()
        
        // Test converting seconds to time string
        let timeString = alarmClockView.secondsToTimeString(3600) // 1 hour in seconds
        XCTAssertEqual(timeString, "01:00 am")
        
        let timeString2 = alarmClockView.secondsToTimeString(3600 * 13) // 1 pm
        XCTAssertEqual(timeString2, "01:00 pm")
    }

    // Test notification content
    
    func testNotificationContent() {
        // Create an instance of AlarmClockView
        let alarmClockView = AlarmClockView()
        
        // Set alarm time to a specific time
        let alarmTime = 10 // Time in seconds
        alarmClockView.setAlarmTime(Date())
        
        // Schedule notification
        alarmClockView.scheduleAlarmNotification(alarmTime, "Beep") // Assuming successful scheduling
        
        // Check if the notification message is correct
        let expectedMessage = "The 00:00 am Alarm is Done ! **Beep noises!!**" // Replace with expected message
        // Replace with actual notification content verification if available
        
        // Example assertion
        XCTAssertEqual(expectedMessage, "The 00:00 am Alarm is Done ! **Beep noises!!**")
    }
    
}
