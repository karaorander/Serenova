
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseDatabase

class Message {
    var messageContent = ""
    var timeStamp: Double = Date().timeIntervalSince1970
    var senderID: String = ""
    var senderUsername: String = ""
    var recipientUsername: String = ""
    var isSent: Bool = false
    
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
