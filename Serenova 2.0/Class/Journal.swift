

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
    var username: String = ""
    var journalDate: Date?
    var journalTime: String = ""
    var journalTitle: String = ""
    var journalContent: String = ""
    var journalPrivacyStatus: String = "Private" // initially private
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
        case username
    }
    
    private var ref: DatabaseReference! = Database.database().reference()
    
    init() {}
    
    init(journalTitle: String, journalContent: String) {
        self.journalContent = journalContent
        self.journalTitle = journalTitle
       
        
        if let user = Auth.auth().currentUser {
            // User is signed in
            self.userId = user.uid
            self.username = currUser?.name ?? ""
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
    
    func updateValues(newValues: [String: Any], completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let ref = db.collection("Journal").document(self.journalId ?? "")
        
        // Update values in Firestore
        ref.updateData(newValues) { error in
            if let error = error {
                // Handle error
                completion(error)
            } else {
                // Update local object if Firestore update succeeds
                for (key, value) in newValues {
                    // Update each property individually
                    switch key {
                    case "journalId":
                        self.journalId = value as? String
                    case "timeStamp":
                        // Handle Timestamp type if needed
                        break
                    case "journalDate":
                        // Handle Date type if needed
                        break
                    case "journalTitle":
                        self.journalTitle = value as? String ?? ""
                    case "journalContent":
                        self.journalContent = value as? String ?? ""
                    case "journalPrivacyStatus":
                        self.journalPrivacyStatus = value as? String ?? "Private"
                    case "journalTags":
                        self.journalTags = value as? [String] ?? []
                    case "userId":
                        self.userId = value as? String ?? ""
                    default:
                        // Handle other properties if needed
                        break
                    }
                }
                completion(nil) // No error
            }
        }
    }

    
    
    
    func deleteJournal() {
        let db = Firestore.firestore()
        do {
            try db.collection("Journal").document(self.journalId ?? "").delete()
          print("Document successfully removed!")
        } catch {
          print("Error removing document: \(error)")
        }
        self.journalId = nil

    }
}

class JournalReply: Codable, Identifiable {
    @DocumentID var replyID: String?
    public var parentPostID: String?
    public var replyContent: String = ""
    public var timeStamp: Double = Date().timeIntervalSince1970
    public var likedIDs: [String] = []
    public var dislikedIDs: [String] = []
    public var authorID: String = ""
    public var authorUsername: String = ""
    public var authorProfilePhoto: URL?
    
    /*
     * Constructor for Reply
     * TODO: Fill in other details! (i.e authorID, authorUsername, authorProfilePicture)
     */
    init(replyContent: String, parentPostID: String) {
        self.replyContent = replyContent
        self.parentPostID = parentPostID
    }
    
    /*
     * Function to write new post to Firebase
     */
    func createReply() async throws{
        // Create Firestore document ref
        let ref = Firestore.firestore().collection("Journal")
        // Write new Post object to Database
        let documentRef = ref.document(self.parentPostID!).collection("Replies").document()
        try documentRef.setData(from: self)
        // Update replyID
        self.replyID = documentRef.documentID
        // Increment parent post's number of replies
        try await ref.document(self.parentPostID!).updateData([
            "numReplies" : FieldValue.increment(Int64(1))
        ]);
    }
    
    /*
     * Function to get relative date
     */
    func getRelativeTime() -> String {
        let dateFormatter = RelativeDateTimeFormatter()
        return dateFormatter.localizedString(for: Date(timeIntervalSince1970: TimeInterval(timeStamp)), relativeTo: Date())
    }
    
    /*
     * Function to get date
     */
    func getRealTime() -> String {
        let dateFormatter = DateFormatter()
        return dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(timeStamp)))
    }
}


