//
//  ContentView.swift
//  Serenova 2.0
//
//  Created by Kara Orander on 2/12/24.
//

import SwiftUI
import FirebaseDatabase
import UIKit

struct ContentView: View {
    // private let database = Database.database().reference()

    var body: some View {
        LoginView()
    }

    // *in the form of an object for sake of readability in database
    // *currently 0 as placeholder until user input
    // let goal: [String: int] = [
    //      "Sleep Hours": 0
    //  ]
    // database.child("Sleep Goals").setValue(goal)
}

#Preview {
    ContentView()
}
