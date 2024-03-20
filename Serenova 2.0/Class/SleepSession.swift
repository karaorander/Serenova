//
//  Sleep.swift
//  Serenova 2.0
//
//  Created by Ava Schrandt on 2/28/24.
//
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseDatabase
import FirebaseAuth

class SleepSession: Codable {
    @DocumentID var postID: String?
    var userId : String?
    var exists: Bool = false
    var durationHours: Int = 0
    var durationMinutes: Int = 0
    var deepHours: Int = 0
    var deepMinutes: Int = 0
    var coreHours: Int = 0
    var coreMinutes: Int = 0
    var remHours: Int = 0
    var remMinutes: Int = 0
    var date: Date = Date()
    var sleepStart: Date = Date()
    var sleepEnd: Date = Date()
    var manualInterval: TimeInterval?
    
    enum CodingKeys: String, CodingKey {
        case exists
        case durationHours
        case durationMinutes
        case deepHours
        case deepMinutes
        case coreHours
        case coreMinutes
        case remHours
        case remMinutes
        case date
        case sleepStart
        case sleepEnd
        case userId
        case manualInterval
    }
    
    private var ref: DatabaseReference! = Database.database().reference()
    
    // Constructor for HK
    init() {}
    
    // Constructor for manual log stored in FB
    init(sleepStart:Date, sleepEnd:Date, date: Date, manualInterval:TimeInterval) {
        self.sleepStart = sleepStart
        self.sleepEnd = sleepEnd
        self.date = date
        self.manualInterval = manualInterval
        self.durationHours = Int(manualInterval) / 3600
        self.durationMinutes = (Int(manualInterval) % 3600) / 60
        if let user = Auth.auth().currentUser {
            // User is signed in
            self.userId = user.uid
            // Now you have the UID
            print("User ID:", userId)
        } else {
            // No user is signed in
            print("No user signed in")
        }
        
        
    }
    
    // Function to add sleep session to Firebase
    func addSleepSession() async throws {
        let ref = Firestore.firestore().collection("SleepSessions")
        // Write new sleepSession object to Database
        try ref.addDocument(from: self)
    }
}
