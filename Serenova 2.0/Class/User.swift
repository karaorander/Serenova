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
    private var userID: String = ""
    private var name: String = ""
    private var username: String = ""
    private var email: String = ""
    private var phoneNumber: String = ""
    private var colorScheme: ColorScheme = ColorScheme.MoonlitSerenity // TODO: Set default ColorScheme
    private var profileURL: URL?
    private var typicalSleepTime: String = ""
    private var gender: Gender = Gender.Female
    private var weight: Int = -1
    private var height: Int = -1
    private var age: Int = -1
    private var hadInsomnia: Bool = false
    private var hasInsomnia: Bool = false
    private var exercisesRegularly: Bool = false
    private var hasMedication: Bool = false
    private var doesSnore: Bool = false
    private var hasNightmares: Bool = false
    private var typicalWakeUpTime: String = ""
    private var typicalBedTime: String = ""
    private var isEarlyBird: Bool = true
    
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
    
    enum CodingKeys: CodingKey {
        case name, username, email, phoneNumber,
             colorScheme, profileURL, typicalSleepTime,
             gender, weight, height, age, hadInsomnia,
             hasInsomnia, exercisesRegularly, hasMedication,
             doesSnore, hasNightmares, typicalWakeUpTime,
             typicalBedTime, isEarlyBird
    }
    
    // Database Reference
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
     * Function to update values
     * to Firebase (should be called
     * by another function e.g. updateEmail())
     */
    
    /*
     * Function to delete a user
     */
    func deleteUser() {
        
    }
    
    /*
     * Function to update email
     */
    func updateEmail(newEmail: String) {
       
    }
    
    /*
     * Function to update username
     */
    func updateUsername(newUsername: String) {
        
    }

    /*
     * Function to update password
     */
    func updatePassword(newPassword: String) {
        
    }
    
    /*
     * Function to change color scheme
     */
    func updateColorScheme(newScheme: ColorScheme) {
    
    }

    /*
     * Function to change user photo
     * (Should maybe handle deleting the old picture
     *  + updating the new URL)
     */
    func updateProfilePicture(newURL: URL) {
        
    }
}

