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
    
    
    
    //ALL sleep values
    func querySleepData(completion: @escaping (TimeInterval?, TimeInterval?, TimeInterval?, TimeInterval?)-> Void, date: Date) {
        let totalSleepDuration:TimeInterval = 0
        var deepSleepDuration:TimeInterval = 0
        var coreSleepDuration:TimeInterval = 0
        var remSleepDuration:TimeInterval = 0
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
                 //   if HKCategoryValueSleepAnalysis.allAsleepValues.contains(type) {
                        let sleepDuration = result.endDate.timeIntervalSince(result.startDate)
                        ///for testing
                        print("""
                            Sample start: \(result.startDate),
                            end: \(result.endDate),
                            value: \(result.value),
                            duration: \(sleepDuration) seconds
                            """)
                        totalSleepTime += sleepDuration
                    switch type {
                    case .asleepDeep:
                            deepSleepDuration += sleepDuration
                    case .asleepREM:
                        remSleepDuration += sleepDuration
                    case .asleepCore, .asleepUnspecified:
                        coreSleepDuration += sleepDuration
                    case .awake:
                        // Ignore awake segments
                        break
                    case .inBed:
                        
                        break
                    @unknown default:
                        break
                    }
                        
                   // }
                }
            }
            self.sleepSession.durationHours = Int(totalSleepTime) / 3600
            self.sleepSession.durationMinutes = (Int(totalSleepTime) % 3600) / 60
            self.sleepSession.deepHours = Int(deepSleepDuration) / 3600
            self.sleepSession.deepMinutes = (Int(deepSleepDuration) % 3600) / 60
            self.sleepSession.coreHours = Int(coreSleepDuration) / 3600
            self.sleepSession.coreMinutes = (Int(coreSleepDuration) % 3600) / 60
            self.sleepSession.remHours = Int(remSleepDuration) / 3600
            self.sleepSession.remMinutes = (Int(remSleepDuration) % 3600) / 60
            print("TOTAL %d", self.sleepSession.durationHours)
            print(self.sleepSession.durationMinutes)
            print("DEEP %d", self.sleepSession.deepHours)
            print(self.sleepSession.deepMinutes)
            print("CORE %d", self.sleepSession.coreHours)
            print("CORE %d", self.sleepSession.coreMinutes)
            print("REM %d", self.sleepSession.remHours)
            print(" %d", self.sleepSession.remMinutes)
            completion(totalSleepTime, deepSleepDuration, coreSleepDuration, remSleepDuration)
        }
        healthStore.execute(query)
    }
    
}


