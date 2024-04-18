//
//  User.swift
//  Serenova 2.0
//
//  Created by Caitlin Wilson on 2/19/24.
//
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase

// Global User Variable
var currUser: User?

class User: Codable {
    public var userID: String = ""
    public var name: String = ""
    public var username: String = ""
    public var email: String = ""
    public var phoneNumber: String = ""
    public var bio: String = ""
    public var colorScheme: ColorScheme = ColorScheme.MoonlitSerenity // TODO: Set default ColorScheme
    public var profileURL: URL?
    public var typicalSleepTime: String = ""
    public var gender: Gender = Gender.Female
    public var weight: Float = -1
    public var height: Float = -1
    public var age: Int = -1
    public var hadInsomnia: Bool = false
    public var hasInsomnia: Bool = false
    public var exercisesRegularly: Bool = false
    public var hasMedication: Bool = false
    public var doesSnore: Bool = false
    public var hasNightmares: Bool = false
    public var typicalWakeUpTime: String = ""
    public var typicalBedTime: String = ""
    public var isEarlyBird: Bool = true
    public var totalSleepGoalHours: Float = -1
    public var totalSleepGoalMins: Float = -1
    public var deepSleepGoalHours: Float = -1
    public var deepSleepGoalMins: Float = -1
    public var moonCount: Int = -1
    public var friends: [String] = []
    public var notifications: [String] = []
    public var blocked: [String] = []
    public var alarms: [Int] = []
    public var sounds: [String] = []
    public var conversations: [Conversation] = []

    
    /* Gender */
    enum Gender: String, Codable {
        case Male = "Male"
        case Female = "Female"
    }
    
    /* Color Schemes */
    enum ColorScheme: String, Codable {
        case MoonlitSerenity = "Moonlit Serenity"
        case SoothingNight = "Soothing Night"
        case TranquilMist = "Tranquil Mist"
        case DreamyTwilight = "Dreamy Twilight"
        case NightfallHarmony = "Nightfall Harmony"
    }
    
    /* CodingKeys */
    enum CodingKeys: CodingKey {
        case name, username, email, phoneNumber, bio,
             colorScheme, profileURL, typicalSleepTime,
             gender, weight, height, age, hadInsomnia,
             hasInsomnia, exercisesRegularly, hasMedication,
             doesSnore, hasNightmares, typicalWakeUpTime,
             typicalBedTime, isEarlyBird, moonCount
    }
    
    /* Database Reference */
    private var ref: DatabaseReference! = Database.database().reference().child("User")

    /*
     * Constructor for new Serenova User
     * TODO: Add Username
     */
    init(userID: String, name: String, email: String, phoneNumber: String) throws {
        self.userID = userID
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        
        try self.addUser()
    }
    
    /*
     * Function to add a User
     * Throws error related to encoding the object
     */
    func addUser() throws {
        // Convert data to JSON-like object for storage
        let encodedData = try JSONSerialization.jsonObject(with: JSONEncoder().encode(self), options: []) as? [String: Any]
        // Write new User object to Database
        ref.child(self.userID).setValue(encodedData)
    }
    
    func addFriend(_ friendID: String) {
        friends.append(friendID)
    }
    
    func addAlarm(_ alarmID: Int) {
        alarms.append(alarmID)
    }
    
    func blockUser(_ blockedID: String) {
        blocked.append(blockedID)
    }
    
    func addSound(_ soundID: String) {
        sounds.append(soundID)
    }
    
    func addConversation(_ convoID: Conversation) {
        conversations.append(convoID)
    }
    
    func addNotification(_ noti: String) {
        if let currUser = currUser {
            currUser.notifications.append(noti)
            currUser.updateValues(newValues: ["notifications" : notifications])
        } else {
            print("error")
        }
    }
    
    
    func addSleepSession(sleepSessionData: [String: Any]) throws {
        // Write new sleep session under the "sleepSessions" node for the user
        ref.child(self.userID).child("sleepSessions").childByAutoId().setValue(sleepSessionData)
        { error, _ in
                    if let error = error {
                        print("Failed to log sleep session:", error.localizedDescription)
                    } else {
                        print("Sleep session logged successfully")
                    }
                }
    }
    
    
    /*
     * Function to update rewards
     * to Firebase
     */
    func updateMoons(rewardCount : Int) {
        let db = Database.database().reference()
        let id = Auth.auth().currentUser!.uid

        if let currUser = currUser {
            var moon = currUser.moonCount
            moon = moon + rewardCount
            currUser.moonCount = moon
            currUser.updateValues(newValues: ["moonCount" : moon])
        } else {
            print("error")
        }
    }
    
    /*
     * Function to update values
     * to Firebase
     */
    func updateValues(newValues: [String: Any]) {
        // Reflect changes to Firebase
        ref.child(self.userID).updateChildValues(newValues)
    }
    
    /*
     * Function to get Friend data
     * from Firebase
     */
    func getFriendData(friendID: String, data: String) -> String {
        let db = Database.database().reference()
        let ur = db.child("User").child(friendID)
        var dataValue = ""
        
        ur.observeSingleEvent(of: .value, with: { snapshot in
            guard let userData = snapshot.value as? [String: Any] else {
                print("Error fetching data")
                return
            }
            
            dataValue = userData[data] as! String
        })
        
        return dataValue
    }

    /*
     * Function to delete a user
     */
    func deleteUser() {
        ref.child(self.userID).setValue(nil)
    }

}
