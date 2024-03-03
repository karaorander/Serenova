//
//  SleepManager.swift
//  Serenova 2.0
//
//  Created by Ava Schrandt on 2/27/24.
//

import Foundation
import HealthKit
import SwiftUI



/// Helper for reading and writing to HealthKit.
class SleepManager {
    var sleepSession = SleepSession()
    var healthStore = HKHealthStore()
    var authenticated: Bool = false
    @Published var sleepSamples: [HKCategorySample] = []
    
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
            fatalError("HealthKit is not available on this device.")
        }
        
        if let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) {
            healthStore.requestAuthorization(toShare: nil, read: [sleepType]) { success, error in
                if success {
                    print("Authorization granted for sleep analysis data")
                    self.authenticated = true
                    // self.enableBackgroundDelivery()
                } else {
                    if let error = error {
                        print("Failed to request authorization: \(error.localizedDescription)")
                    }
                   // fatalError("This app requires Health Permissions to be enabled :)")
                    
                }
            }
        }
    }
    
    /*func enableBackgroundDelivery() {
     guard HKHealthStore.isHealthDataAvailable() else {
     fatalError("HealthKit is not available on this device.")
     }
     
     if let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) {
     healthStore.enableBackgroundDelivery(for: sleepType, frequency: .immediate) { success, error in
     if success {
     print("Background delivery enabled for sleep analysis data")
     } else {
     if let error = error {
     print("Failed to enable background delivery: \(error.localizedDescription)")
     } else {
     print("Unknown error occurred while enabling background delivery.")
     }
     }
     }
     }
     }*/
    
    func saveSleepData() {
        
    }
    
    
    
    
    func querySleepData(completion: @escaping (TimeInterval?)-> Void, date: Date) {
        let totalSleepDuration:TimeInterval = 0
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)
        
        ///predicate
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [.strictStartDate, .strictEndDate])
        
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { _, results, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let results = results as? [HKCategorySample] else {
                print("No data to display")
                return
            }
            
            print("Start Date: \(startDate), End Date: \(String(describing: endDate))")
            print("Fetched \(results.count) sleep analysis samples.")
            
            var totalSleepTime: TimeInterval = 0
            
            for result in results {
                if let type = HKCategoryValueSleepAnalysis(rawValue: result.value) {
                    if HKCategoryValueSleepAnalysis.allAsleepValues.contains(type) {
                        let sleepDuration = result.endDate.timeIntervalSince(result.startDate)
                        ///for testing
                        print("""
                            Sample start: \(result.startDate),
                            end: \(result.endDate),
                            value: \(result.value),
                            duration: \(sleepDuration) seconds
                            """)
                        totalSleepTime += sleepDuration
                        
                    }
                }
            }
            self.sleepSession.durationHours = Int(totalSleepTime) / 3600
            self.sleepSession.durationMinutes = (Int(totalSleepTime) % 3600) / 60
            print(self.sleepSession.durationHours)
            print(self.sleepSession.durationMinutes)
            completion(totalSleepTime)
        }
        healthStore.execute(query)
    }
    
}
