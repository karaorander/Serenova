//
//  SleepManager.swift
//  Serenova 2.0
//
//  Created by Ava Schrandt on 2/27/24.
//

import Foundation
import HealthKit
import SwiftUI
import Firebase

/* To Query sleep data:
 * Healthkit sleep data is being queried directly from Healthkit (not storing in Firebase)
 * Manual sessions are stored as a collection in firebase and are being queried from there
 
 * calling querySleepData will query all related data (Healthkit and manual) for specific 24hr day (specified in call)
 
 * example of usage :
 sleepManager.querySleepData(completion: { totalSleepTime, deepSleepTime, coreSleepTime, remSleepTime in
 DispatchQueue.main.async {
     currentHrs = Int(totalSleepTime ?? 0) / 3600
     currentMin = (Int(totalSleepTime ?? 0) % 3600) / 60
 }
}, date: day.date)
 
 * Inside the dispatch queue is where to manipulate the queried values (totalSleepTime, deepSleepTime, coreSleepTime, remSleepTime)
 / assign to local variables if needed
 
 */


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
    
    /*func saveSleepData() {
        
    }*/
    
    
    
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
                        
                    switch type {
                    case .asleepDeep:
                            deepSleepDuration += sleepDuration
                        totalSleepDuration += sleepDuration
                    case .asleepREM:
                        remSleepDuration += sleepDuration
                        totalSleepDuration += sleepDuration
                    case .asleepCore, .asleepUnspecified:
                        coreSleepDuration += sleepDuration
                        totalSleepDuration += sleepDuration
                    case .asleepUnspecified:
                        totalSleepDuration += sleepDuration
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
            var totalManualSleep: TimeInterval = 0
            //calling query to Firebase to add manually logged sessions to total sleep time
            self.queryManualSession(date: date, completion: { totalManualSleep in
                DispatchQueue.main.async {
                    totalSleepTime += totalManualSleep
                    self.sleepSession.durationHours = Int(totalSleepTime) / 3600
                    self.sleepSession.durationMinutes = (Int(totalSleepTime) % 3600) / 60
                    self.sleepSession.deepHours = Int(deepSleepDuration) / 3600
                    self.sleepSession.deepMinutes = (Int(deepSleepDuration) % 3600) / 60
                    self.sleepSession.coreHours = Int(coreSleepDuration) / 3600
                    self.sleepSession.coreMinutes = (Int(coreSleepDuration) % 3600) / 60
                    self.sleepSession.remHours = Int(remSleepDuration) / 3600
                    self.sleepSession.remMinutes = (Int(remSleepDuration) % 3600) / 60
                    print("TOTAL", self.sleepSession.durationHours)
                    print(self.sleepSession.durationMinutes)
                    print("DEEP %d", self.sleepSession.deepHours)
                    print(self.sleepSession.deepMinutes)
                    print("CORE %d", self.sleepSession.coreHours)
                    print("CORE %d", self.sleepSession.coreMinutes)
                    print("REM %d", self.sleepSession.remHours)
                    print(" %d", self.sleepSession.remMinutes)
                    completion(totalSleepTime, deepSleepDuration, coreSleepDuration, remSleepDuration)
                }
            })
        }
        healthStore.execute(query)
    }
    
    /* NOTE: working but need to fix security rules in firebase
     UPDATE: working */
    func queryManualSession(date: Date, completion: @escaping (TimeInterval) -> Void) {
        var totalManualSleep: TimeInterval = 0
        let sleepSessionsCollection = Firestore.firestore().collection("SleepSessions")
        
        // Specifing the date to query for date
        let targetDate = Calendar.current.startOfDay(for: date)  // Replace this with your target date
        
        let targetTimestamp = Timestamp(date: targetDate)
        
        // Creating query to filter documents where the "date" field is equal to the target date
        var userId: String = ""
        if let user = Auth.auth().currentUser {
            // User is signed in
            userId = user.uid
        } else {
            // No user is signed in
            print("No user signed in")
            return
        }
        
        let query = sleepSessionsCollection.whereField("date", isEqualTo: targetTimestamp)
                                           .whereField("userId", isEqualTo: userId)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                guard let documents = querySnapshot?.documents else {
                    print("No documents found")
                    return
                }
                
                for document in documents {
                    // Access the data of each document
                    let data = document.data()
                    
                    if let manualInterval = data["manualInterval"] as? TimeInterval {
                        print("Hours: \(manualInterval)")
                        totalManualSleep += manualInterval
                    } else {
                        print("TimeInterval not found or not an integer")
                    }
                }
                completion(totalManualSleep) // Pass the totalManualSleep to the completion handler
            }
        }
    }
    
}
