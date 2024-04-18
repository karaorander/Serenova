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
    
    // Function to create a conversation in Firestore
    func createConversation() async throws{
        let db = Firestore.firestore()
        
        // Create a new document reference for the conversation
        let ref = db.collection("Conversations")
        
        try ref.addDocument(from: self)
        
        
    }
}
