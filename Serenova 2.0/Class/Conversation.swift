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
        self.numParticipants = participants.count
    }

    func addMessage(_ messageToAdd: Message) {
        messages.append(messageToAdd)
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
        
        try ref.addDocument(from: self)
        
        
    }
}
