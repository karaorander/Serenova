//
//  User.swift
//  Serenova 2.0
//
//  Created by Caitlin Wilson on 2/19/24.
//
import Foundation
import FirebaseAuth
import FirebaseDatabase

// Global User Variable
var currUser: User?

class User: Codable {
    public var userID: String = ""
    public var name: String = ""
    public var username: String = ""
    public var email: String = ""
    public var imageURL: UIImage?
    public var phoneNumber: String = ""
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
        case name, username, email, imageURL, phoneNumber,
             colorScheme, profileURL, typicalSleepTime,
             gender, weight, height, age, hadInsomnia,
             hasInsomnia, exercisesRegularly, hasMedication,
             doesSnore, hasNightmares, typicalWakeUpTime,
             typicalBedTime, isEarlyBird
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
    
    /*
     * TODO: Function to read user data from
     * Firebase
     */
    
    /*
     * Function to update values
     * to Firebase
     */
    func updateValues(newValues: [String: Any]) {
        // Reflect changes to Firebase
        ref.child(self.userID).updateChildValues(newValues)
    }

    /*
     * Function to delete a user
     */
    func deleteUser() {
        ref.child(self.userID).setValue(nil)
    }

    /*
     * Function to set the image URL
     */
    func setUserImageURL(imageURL: URL) {
        self.imageURL = imageURL
    }

}

