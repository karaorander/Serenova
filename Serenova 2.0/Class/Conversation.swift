import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseDatabase
import FirebaseAuth

class Conversation: Codable, Identifiable {
    @DocumentID var convoId: String?
    public var participants: [String] = []
    public var messages: [Message] = []
   // public var convoId: String = ""
    public var numParticipants = -1
    
    
    enum CodingKeys: String, CodingKey {
        case convoId
        case participants
        case messages
        case numParticipants
    }

    init(participants: [String]) {
        self.participants = participants
        self.participants.append(Auth.auth().currentUser!.uid)
        self.numParticipants = self.participants.count
    }

    func addMessage(_ messageToAdd: Message) {
        messages.append(messageToAdd)
        
        for participant in participants {
            // Send participants notification when a message is sent in the conversation
            let db = Firestore.firestore()
            let messageNotifications = db.collection("FriendRequests").document(participant).collection("notifications")
            let currentid = currUser?.userID;
            let currentName = currUser?.name;
            let content = messageToAdd.content
            
            //if let username = currUser?.username {
            if (participant != currentid) {
                messageNotifications.document().setData([
                    "message": "\(currentName!): \(content)",
                    "type": "message"
                ], merge: true) { error in
                    if let error = error {
                        print("Error adding notification: \(error)")
                    } else {
                        print("Notification added successfully to Firestore2: \(participant)")
                    }
                }
            }
        }
    }
    
    func updateValues(newValues: [String: Any], completion: @escaping (Error?) -> Void) {
        guard let convoID = convoId else {
            //completion(ConvoError.missingConvoID)
            // ^^ provide error message
            return
        }
            
        let db = Firestore.firestore()
        let convoRef = db.collection("Conversations").document(convoID)
        
        // Update values in Firestore
        convoRef.updateData(newValues) { error in
            if let error = error {
                // Handle error
                completion(error)
            } else {
                    
                for (key, value) in newValues {
                    // Update each property individually
                    switch key {
                    case "participants":
                        self.participants = value as? [String] ?? []
                    case "messages":
                        self.messages = value as? [Message] ?? []
                    case "numParticipants":
                        self.numParticipants = value as? Int ?? 0
                    default:
                        break
                    }
                }
                completion(nil)
            }
        }
    }
    
    // Function to create a conversation in Firestore
    func createConversation() async throws{
        let db = Firestore.firestore()
        
        // Create a new document reference for the conversation
        let ref = db.collection("Conversations")
        
        let documentRef = ref.document()
        try documentRef.setData(from: self)
        convoId = documentRef.documentID
        
        for participant in participants {
            // Send participants a notification on addition to a groupchat
            let joinNotifications = db.collection("FriendRequests").document(participant).collection("notifications")
            let currentid = currUser?.userID;
            let currentName = currUser?.name;

            //if let username = currUser?.username {
            if (participant != currentid) {
                joinNotifications.document().setData([
                    "message": "\(currentName!) added you to a chat",
                    "type": "message"
                ], merge: true) { error in
                    if let error = error {
                        print("Error adding notification: \(error)")
                    } else {
                        print("Notification added successfully to Firestore2: \(participant)")
                    }
                }
            }
        }
    }
}
