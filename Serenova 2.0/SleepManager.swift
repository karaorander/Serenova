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
    let healthStore = HKHealthStore()
    @Published var sleepSamples: [HKCategorySample] = []
    
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else {
            fatalError("HealthKit is not available on this device.")
        }
        
        if let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) {
            healthStore.requestAuthorization(toShare: nil, read: [sleepType]) { success, error in
                if success {
                    print("Authorization granted for sleep analysis data")
                    self.enableBackgroundDelivery()
                } else {
                    if let error = error {
                        print("Failed to request authorization: \(error.localizedDescription)")
                    }
                    // TODO: Handle failure to request authorization
                }
            }
        }
    }
    
    func enableBackgroundDelivery() {
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
    }
    
    func saveSleepData() {
        
    }
    
    /// For Testing purposes only
    
    func generateMockSleepSamples() -> [HKCategorySample] {
        // create mock sleep samples
        let startDate = Calendar.current.startOfDay(for: Date())
        let endDate = Calendar.current.date(byAdding: .minute, value: 45, to: startDate)!
        
        let sample1 = HKCategorySample(type: HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!, value: HKCategoryValueSleepAnalysis.asleep.rawValue, start: startDate, end: endDate)
        
        let startDate2 = Calendar.current.startOfDay(for: Date())
        let endDate2 = Date()
        let sample2 = HKCategorySample(type: HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!, value: HKCategoryValueSleepAnalysis.asleepREM.rawValue, start: startDate2, end: endDate2)
        
        
        return [sample1,sample2]
    }
    
    
    
    //query for specific day
    func querySleepData(for date: Date){
        
        print("in real data")
        guard HKHealthStore.isHealthDataAvailable() else {
            fatalError("HealthKit is not available on this device.")
        }
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        
        if let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) {
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [sortDescriptor]) { query, results, error in
                // Handle query error
                if let error = error {
                    print("Query error: \(error.localizedDescription)")
                    return
                }
                
                //testing
                if let sleepSamples = results as? [HKCategorySample] {
                    if sleepSamples.isEmpty { print("no samples available")}
                    for sample in sleepSamples {
                        
                        print("Sleep sample: \(sample)")
                    }
                }
            }
            healthStore.execute(query)
            
        } else {
            print("no object type available")
        }
        
    }
    
    
    //converting total sleep time to hours and minutes
    func getsleepData(date: Date)->SleepSession {
        let sleepSession = SleepSession()
        var duration = 0
        querySleepData(for: date)
        ///mock data:
        //sleepSamples = generateMockSleepSamples()
        if(sleepSamples.isEmpty) {
            sleepSession.exists = false
            return sleepSession
        } else {
            sleepSession.exists = true
            sleepSession.date = date
        }
        
        for sample in sleepSamples {
            duration += Int(sample.endDate.timeIntervalSince(sample.startDate))
            
            
            print("Sleep sample: \(sample)")
        }
        sleepSession.durationHours = Int(duration) / 3600
        sleepSession.durationMinutes = (Int(duration) % 3600) / 60
        return sleepSession
    }
}
