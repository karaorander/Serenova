//
//  Serenova_2_0App.swift
//  Serenova 2.0
//
//  Created by Kara Orander on 2/12/24.
//

import SwiftUI
import FirebaseCore
import FirebaseDatabase


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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
