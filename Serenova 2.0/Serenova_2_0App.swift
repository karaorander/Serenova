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
import FirebaseAppCheck


//private let logger = Logger(subsystem: "Serenova",category: "iOS App")


class AppDelegate: NSObject, UIApplicationDelegate {
    var sleepManager: SleepManager!
   func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    // App Check Simulator Error:
    //let providerFactory = AppCheckDebugProviderFactory()
    //AppCheck.setAppCheckProviderFactory(providerFactory)
       
    FirebaseApp.configure()
    sleepManager = SleepManager()
      
      // Request HealthKit authorization
    sleepManager.requestAuthorization()
    return true
  }
}



@main
struct Serenova_2_0App: App {
    // Register App Delegate for Firebase Setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(delegate.sleepManager)

        }
    }
}
extension SleepManager: ObservableObject{}
