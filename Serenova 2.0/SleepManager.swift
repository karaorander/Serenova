//
//  ViewController.swift
//  Serenova 2.0
//
//  Created by Ava Schrandt on 2/27/24.
//

import Foundation
import HealthKit
import UIKit
import SwiftUI

let healthStore = HKHealthStore()
var HKauthenticated:Bool = false;
/*func requestHealth() {
   
    guard HKHealthStore.isHealthDataAvailable() else {  fatalError("This app requires a device that supports HealthKit") }
    if let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) {
        let setType = Set<HKSampleType>(arrayLiteral: sleepType)
        healthStore.requestAuthorization(toShare: nil, read: setType) { (success, error) in
            
            if !success || error != nil {
                
                return
            }
            
           HKauthenticated = true
        }
    }
}*/
class SleepManager: ObservableObject {
    
    
    func getHKSleep() {
        let endDate = Date()
        //past 24 hrs
        let startDate = endDate.addingTimeInterval(-1.0 * 60.0 * 60.0 * 24.0)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        let sleepCategory1 = HKCategoryValueSleepAnalysis.asleepDeep.rawValue
        let sleepCategory2 = HKCategoryValueSleepAnalysis.asleepREM.rawValue
        let sleepCategory3 = HKCategoryValueSleepAnalysis.asleepCore.rawValue
        let sleepSampleType = HKCategoryType(.sleepAnalysis)
        
        let deepSample = HKCategorySample(type: sleepSampleType,
                                          value: sleepCategory1,
                                          start: startDate,
                                          end: endDate);
        let remSample = HKCategorySample(type: sleepSampleType,
                                         value: sleepCategory2,
                                         start: startDate,
                                         end: endDate)
        let coreSample = HKCategorySample(type: sleepSampleType,
                                          value: sleepCategory3,
                                          start: startDate,
                                          end: endDate)
        let sleepSample:[HKCategorySample]  = [deepSample, remSample, coreSample]
    }

    
        
        
    
}
