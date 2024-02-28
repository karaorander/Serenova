//
//  Serenova_2_0App.swift
//  Serenova 2.0
//
//  Created by Kara Orander on 2/12/24.
//

import SwiftUI
import FirebaseCore
import FirebaseDatabase
import HealthKit
import HealthKitUI
import os


//private let logger = Logger(subsystem: "Serenova",category: "iOS App")


class AppDelegate: NSObject, UIApplicationDelegate {

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }

}



@main
struct Serenova_2_0App: App {
    
    // Register App Delegate for Firebase Setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    private let healthStore: HKHealthStore
         
    init() {
        guard HKHealthStore.isHealthDataAvailable() else {  fatalError("This app requires a device that supports HealthKit") }
        healthStore = HKHealthStore()
        requestHealthkitPermissions()
    }
         
         private func requestHealthkitPermissions() {
             
             let sampleTypesToRead = Set([
                 HKCategoryType(.sleepAnalysis)
             ])
             
             healthStore.requestAuthorization(toShare: nil, read: sampleTypesToRead) { (success, error) in
                 print("Request Authorization -- Success: ", success, " Error: ", error ?? "nil")
             }
         }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(healthStore)

        }
    }
}
extension HKHealthStore: ObservableObject{}
