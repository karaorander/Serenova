//
//  Journal.swift
//  Serenova 2.0
//
//  Created by Caitlin Wilson on 2/19/24.
//
import Foundation
import FirebaseDatabase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseDatabase
import FirebaseAuth

class Journal: Codable, Identifiable {
    @DocumentID var journalId: String?
    @ServerTimestamp public var timeStamp: Timestamp?
    var userId: String?
    var journalDate: Date?
    var journalTime: String = ""
    var journalTitle: String = ""
    var journalContent: String = ""
    var journalPrivacyStatus: Bool = true // True = Private
    var journalTags: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case journalId
        case timeStamp
        case journalDate
        case journalTitle
        case journalContent
        case journalPrivacyStatus
        case journalTags
        case userId
    }
    
    private var ref: DatabaseReference! = Database.database().reference()
    
    init() {}
    
    init(journalTitle: String, journalContent: String) {
        self.journalContent = journalContent
        self.journalTitle = journalTitle
       
        
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
    
    func addJournalEntry() async throws {
        self.journalTime = getRealTime()
        let ref = Firestore.firestore().collection("Journal")
        // Write new sleepSession object to Database
        try ref.addDocument(from: self)
    }
    
    func getRealTime() -> String {
            guard let timeStamp = self.timeStamp else {
                return ""
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
            return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timeStamp.seconds)))
        }
}
