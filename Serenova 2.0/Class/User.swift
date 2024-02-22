//
//  User.swift
//  Serenova 2.0
//
//  Created by Caitlin Wilson on 2/19/24.
//
import Foundation
import FirebaseAuth
import FirebaseDatabase

// *** Not sure if there's one reference
public var ref: DatabaseReference! = Database.database().reference()

// Global user variable to hold current user
var currUser: User?

class User {
    private var name: String = ""
    private var username: String = ""
    //private var password: String = ""  // FirebaseAuth stores + protects this for us so i dont think we need this
    private var email: String = ""
    //private var journals: [Journal] = []
    //private var articlesRead = [Article] = []
    //private var longTermSleep: [SleepLog] = []
    //private var colorScheme: ColorSchemes // TODO: Set default value
    //private var profilePhoto // TODO: Set default value
    private var userId: String = ""
    private var typicalSleepTime: String = ""
    private var gender: Gender = Gender.Female //TODO: Set default value
    private var weight: Int = -1
    private var height: Int = -1
    private var age: Int = -1
    private var hadInsomnia: Bool = false
    private var hasInsomnia: Bool = false
    private var exerciseRegularly: Bool = false
    private var hasMedication: Bool = false
    private var doesSnore: Bool = false
    private var hasNightmares: Bool = false
    private var typicalWakeUpTime: String = ""
    private var typicalBedTime: String = ""
    private var isEarlyBird: Bool = true
    
    enum Gender: Int {
        case Male
        case Female
    }
    let Male = Gender(rawValue: 0)
    let Female = Gender(rawValue: 1)
    
    enum ColorSchemes: Int{
        case MoonlitSerenity
        case SoothingNight
        case TranquilMist
        case DreamyTwilight
        case NightfallHarmony
    }
    let MoonlitSerenity = ColorSchemes(rawValue: 0)
    let SoothingNight = ColorSchemes(rawValue: 1)
    let TranquilMist = ColorSchemes(rawValue: 2)
    let DreamyTwilight = ColorSchemes(rawValue: 3)
    let NightfallHarmony = ColorSchemes(rawValue: 4)
    
    
    /* 
     * Constructor to create a User
     * Object from FirebaseAuth result
     *
     * If logging in, will retrieve data
     * If signing up, will create new User object
     * in Database
     */
    init(authResult: AuthDataResult, login: Bool) async {
        
        // Set unique identifier for User
        self.userId = authResult.user.uid
        
        if (login) {
            // 1) Get snapshot of User data
            if let snapshot = await self.readUserData() {
                self.name = snapshot["name"] as? String ?? ""
                self.username = snapshot["username"] as? String ?? ""
                //self.password = snapshot?["password"] as? String?? ""
                self.email = snapshot["email"] as? String ?? ""
                //self.journals
                //self.articlesRead
                //self.longTermSleep
                //self.colorScheme // TODO: update this with correct value type
                //self.profilePhoto  // TODO: update this with correct value type
                self.typicalSleepTime = snapshot["typicalSleepTime"] as? String ?? ""
                self.gender = snapshot["gender"] as? Gender ?? Gender.Female
                self.weight = snapshot["weight"] as? Int ?? -1
                self.height = snapshot["height"] as? Int ?? -1
                self.age = snapshot["age"] as? Int ?? -1
                self.hadInsomnia = snapshot["hadInsomnia"] as? Bool ?? false
                self.hasInsomnia = snapshot["hasInsomnia"] as? Bool ?? false
                self.exerciseRegularly = snapshot["hasInsomnia"] as? Bool ?? false
                self.hasMedication = snapshot["hasMedication"] as? Bool ?? false
                self.doesSnore = snapshot["doesSnore"] as? Bool ?? false
                self.hasNightmares = snapshot["hasNightmares"] as? Bool ?? false
                self.typicalWakeUpTime = snapshot["typicalWakeUpTime"] as? String ?? ""
                self.typicalBedTime = snapshot["typicalBedTime"] as? String ?? ""
                self.isEarlyBird = snapshot["earlyBird"] as? Bool ?? false
            }
            
        } else {
            // 2) Create new User Object for new user
            self.writeUserData()
        }
        
        // Set current user to this object
        if currUser == nil {
            currUser = self
        }
    }

    /*
     * Function to read User data from Firebase
     *
     */
    func readUserData() async -> NSDictionary? {
        // Read in User data given the uniqueID
        do {
            let snapshot = try await ref.child("Users/\(self.userId)").getData()
            return snapshot.value as? NSDictionary
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /*
     * Function to write the entire User Object
     * to the database. Default values are used
     * as placeholders
     */
    func writeUserData() {
        let savedUser: [String: Any] = [  "name": self.name,
                                          "username": self.username,
                                          //"password": self.password,
                                          "email": self.email,
                                          //"journals": self.journals,
                                          //"articlesRead": self.articlesRead,
                                          //"longTermSleep": self.longTermSleep,
                                          //"colorScheme": self.colorScheme.rawValue, // TODO: update this with correct value type
                                          //"profilePhoto": self.profilePhoto,  // TODO: update this with correct value type
                                          "typicalSleepTime": self.typicalSleepTime,
                                          "gender": self.gender.rawValue,
                                          "weight": self.weight,
                                          "height": self.height,
                                          "age": self.age,
                                          "hadInsomnia": self.hadInsomnia,
                                          "hasInsomnia": self.hasInsomnia,
                                          "exerciseRegularly": self.exerciseRegularly,
                                          "hasMedication": self.hasMedication,
                                          "doesSnore": self.doesSnore,
                                          "hasNightmares": self.hasNightmares,
                                          "typicalWakeUpTime": self.typicalWakeUpTime,
                                          "typicalBedTime": self.typicalBedTime,
                                          "isEarlyBird": self.isEarlyBird    ]
        let savedUserUpdates = ["Users/\(self.userId)": savedUser]
        ref.updateChildValues(savedUserUpdates)
    }
    
    /*
     * Function to write a certain value
     * of the User to the database
     */
    func updateUserValue(attribute: String, value: Any) {
        // Update variable to specified user
        ref.child("Users/\(self.userId)/\(attribute)").setValue(value)
    }
    
    /*
     * TODO: Check if username is unique
     */
    func isUsernameUnique() {
        
    }
    
    /*
     * TODO: Implement User logout
     */
    func userLogout() {
        
    }
    
    /*
     * TODO: Implement deleting User from Database
     */
    func deleteUser() {
        
    }
    
    /*
     * TODO: Implement adding Journal entry
     */
    func addJournal(journalEntry: Journal) {
        
    }
    
    /*
     * TODO: Implement updating email
     */
    func updateEmail(newEmail: String) {
        
    }
    
    /*
     * TODO: Implement updating password
     */
    func updatePassword(newPassword: String) {
        
    }
    
    /*
     * TODO: Implement updating username
     */
    func updateUsername(newUsername: String) {
        
    }
    
    /*
     * TODO: Implement adding Article entry
     */
    func addArticle(newArticle: Article) {
        
    }
    
    /*
     * TODO: Implement adding Sleep Logo entry
     */
    func addSleepData(newSleepData: SleepLog) {
        
    }
    
    /*
     * TODO: Implement allowing user info to be viewed
     */
    func viewUser() {
        
    }
    
    /*
     * TODO: Implement changing color scheme
     */
    func changeColorScheme(newColorScheme: ColorSchemes) {
        
    }
    
    /*
     * TODO: Implement changing profile picture
     */
}

