
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseDatabase

class MessageReply: Codable, Identifiable {
    @DocumentID var replyID: String?
    public var otherID: String?
    public var replyContent: String = ""
    public var timeStamp: Double = Date().timeIntervalSince1970
    public var authorID: String = ""
    public var writerID: String = ""
    
    /*
     * Constructor for Reply
     * TODO: Fill in other details! (i.e authorID, authorUsername, authorProfilePicture)
     */
    init(replyContent: String, otherID: String, authorID: String, writerID: String) {
        self.replyContent = replyContent
        self.otherID = otherID
        self.authorID = authorID
        self.writerID = writerID
    }
    
    /*
     * Function to write new post to Firebase
     */
    func createReply() async throws{
        // Create Firestore document ref
        let ref = Firestore.firestore().collection("Conversations")
        // Write new Post object to Database
        let documentRef = ref.document(self.otherID!).collection("Replies").document()
        try documentRef.setData(from: self)
        // Update replyID
        self.replyID = documentRef.documentID
        // Increment parent post's number of replies
        try await ref.document(self.otherID!).updateData([
            "numReplies" : FieldValue.increment(Int64(1))
        ]);
        
        let db = Firestore.firestore()
        //Add notification to users page
        
        // Retrieve participants and send notifications
        getParticipants(from: self.otherID!) { result in
            switch result {
            case .success(let participants):
                // Loop through each participant and send notifications
                for participant in participants {
                    if participant != currUser?.userID {
                        let joinNotifications = Firestore.firestore()
                            .collection("FriendRequests")
                            .document(participant)
                            .collection("notifications")
                        
                        let message = "\(currUser?.name ?? "Someone"): \(self.replyContent)"
                        
                        joinNotifications.document().setData([
                            "message": message,
                            "type": "message"
                        ], merge: true) { error in
                            if let error = error {
                                print("Error adding notification: \(error)")
                            } else {
                                print("Notification added successfully to Firestore: \(participant)")
                            }
                        }
                    }
                }
            case .failure(let error):
                // Handle any errors that occur when fetching participants
                print("Failed to retrieve participants: \(error)")
            }
        }
    }
    
    // Function to retrieve participants of a conversation given a conversation ID
    func getParticipants(from convoId: String, completion: @escaping (Result<[String], Error>) -> Void) {
        let db = Firestore.firestore()
        let conversationRef = db.collection("Conversations").document(convoId)
        
        conversationRef.getDocument { (document, error) in
            if let error = error {
                // Handle any error that occurs during the query
                completion(.failure(error))
            } else if let document = document, document.exists {
                // Convert the document data into a Conversation object
                do {
                    let conversation = try document.data(as: Conversation.self)
                    // Return the list of participants in the completion handler
                    completion(.success(conversation.participants ?? []))
                } catch {
                    // Handle any error that occurs during data conversion
                    completion(.failure(error))
                }
            } else {
                // Handle the case where the document does not exist
                completion(.success([]))
            }
        }
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



struct Message: Codable {
    var senderID: String
    var timeStamp: Double = Date().timeIntervalSince1970
    var content: String

    init(senderID: String, content: String) {
        self.senderID = senderID
        self.content = content
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
/*class Message {
    var messageContent = ""
    var timeStamp: Double = Date().timeIntervalSince1970
    var senderID: String = ""
    var senderUsername: String = ""
    var recipientUsername: String = ""
    var isSent: Bool = false
    var convoId: String = ""
    var userId: String?
    
    init() {}
    
    /*
     * Function to write new message to Firebase
     */
    func createMessage() async throws{
        if ((Auth.auth().currentUser) != nil) {
            let db = Database.database().reference()
            self.senderID = Auth.auth().currentUser!.uid
            let ur = db.child("User").child(self.senderID)
            
            ur.observeSingleEvent(of: .value) { snapshot in
                guard let userData = snapshot.value as? [String: Any] else {
                    print("Error fetching data")
                    return
                }
                
                // Extract additional information based on your data structure
                if let username = userData["username"] as? String {
                    self.senderUsername = username
                }
            }
        }
        // TODO: store message to Firebase
        
    }
    
    init(messageContent: String, messageSender: String, messageReceiver: String) {
        self.messageContent =  messageContent
        self.senderUsername = messageSender
        self.recipientUsername = messageReceiver
    }
    

}*/
