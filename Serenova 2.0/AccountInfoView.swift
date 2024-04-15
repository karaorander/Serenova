//
//  AccountInfoView.swift
//  Serenova 2.0
//
//  Created by Kara Orander on 2/16/24.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore
import iPhoneNumberField

//Fetch all data from firebase
class AccountInfoViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var fullname = ""
    @Published var phoneNumber = ""
    @Published var age = ""
    @Published var gender = ""
    @Published var height = ""
    @Published var weight = ""
    @Published var bio = ""
    @Published var notifications: Bool = false
    @Published var snore : Bool = true
    @Published var hadinsomnia : Bool = true
    @Published var hasinsomnia : Bool = true
    @Published var hasmedication : Bool = true
    @Published var hasnightmares : Bool = true
    @Published var exercisesRegularly : Bool = false
    @Published var isearlybird : Bool = true
    @Published var totalSleepGoalHours : Float = -1
    @Published var totalSleepGoalMins : Float = -1
    @Published var deepSleepGoalHours : Float = -1
    @Published var deepSleepGoalMins : Float = -1
    @Published var moonCount : Int = -1
    @Published var articlesRead : [String] = []
    @Published var blocked : [String] = []
    
    func fetchUsername() {
        if let currentUser = Auth.auth().currentUser {
            let db = Database.database().reference()
            let id = Auth.auth().currentUser!.uid
            let ur = db.child("User").child(id)
            // Now you can use userRef safely
            
            ur.observeSingleEvent(of: .value) { snapshot in
                guard let userData = snapshot.value as? [String: Any] else {
                    print("Error fetching data")
                    return
                }
                
                // Extract additional information based on your data structure
                if let fullname = userData["name"] as? String {
                    self.fullname = fullname
                }
                
                if let email = userData["email"] as? String {
                    self.email = email
                }
                
                if let username = userData["username"] as? String {
                    self.username = username
                }
                
                
                if let phoneNumber = userData["phoneNumber"] as? String {
                    self.phoneNumber = phoneNumber
                }
                
                if let age = userData["age"] as? String {
                    self.age = age
                }
                
                if let password = userData["password"] as? String {
                    self.password = password
                }
                
                if let gender = userData["gender"] as? String {
                    self.gender = gender
                }
                
                if let height = userData["height"] as? String {
                    self.height = height
                }
                
                if let weight = userData["weight"] as? String {
                    self.weight = weight
                }
                
                if let snore = userData["doesSnore"] as? Bool {
                    self.snore = snore
                }
                
                if let notifications = userData["notifications"] as? Bool {
                    self.notifications = notifications
                }
                
                if let hadinsomnia = userData["hadInsomnia"] as? Bool {
                    self.hadinsomnia = hadinsomnia
                }
                
                if let hasinsomnia = userData["hasInsomnia"] as? Bool {
                    self.hasinsomnia = hasinsomnia
                }
                
                if let hasmeds = userData["hasMedication"] as? Bool {
                    self.hasmedication = hasmeds
                }
                
                if let hasnights = userData["hasNightmares"] as? Bool {
                    self.hasnightmares = hasnights
                }
                
                if let earlybird = userData["isEarlyBird"] as? Bool {
                    self.isearlybird = earlybird
                }
                
                if let totalHours = userData["totalSleepGoalHours"] as? Float {
                    self.totalSleepGoalHours = totalHours
                }
                
                if let exercisesRegularly = userData["exercisesRegularly"] as? Bool {
                    self.exercisesRegularly = exercisesRegularly
                }
                
                if let totalMins = userData["totalSleepGoalMins"] as? Float {
                    self.totalSleepGoalMins = totalMins
                }
                
                if let deepHours = userData["deepSleepGoalHours"] as? Float {
                    self.deepSleepGoalHours = deepHours
                }
                
                if let deepMins = userData["deepSleepGoalMins"] as? Float {
                    self.deepSleepGoalMins = deepMins
                }
                
                if let moonCount = userData["moonCount"] as? Int {
                    self.moonCount = moonCount
                }
                
                if let articlesRead = userData["articlesRead"] as? [String] {
                    self.articlesRead = articlesRead
                }
                
                if let blocked = userData["blocked"] as? [String] {
                    self.blocked = blocked
                }
                
                if let bio = userData["bio"] as? String {
                    self.bio = bio
                    if (self.bio == "") {
                        self.bio = "Write your bio here!"
                    }
                }
            }
        } else {
            // Handle the case where there's no authenticated user
            print("No authenticated user")
        }
        
    }
    
   /* func isEmailTaken(email: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(false)
            } else {
                let isTaken = !(querySnapshot?.isEmpty ?? true)
                completion(isTaken)
            }
        }
    }*/
    
    func deleteUser() {
        let db = Database.database().reference()
        let id = Auth.auth().currentUser!.uid
        let ur = Auth.auth().currentUser
        
        db.child("User").child(id).removeValue();
        
        ur?.delete { error in
            if let error = error {
                print("Error removing user from authentication")
            } else {
                print("User removed")
            }
        }
        
        let ref = Firestore.firestore()
        let currentUserID = Auth.auth().currentUser!.uid
           
           // Reference to the user's "friends" collection
        let friendsCollectionRef = ref.collection("FriendRequests").document(currentUserID)
           
           // Delete the friend document
           friendsCollectionRef.delete { error in
               if let error = error {
                   print("Error removing user from Firestore: \(error)")
               } else {
                   print("User removed successfully from Firestore")
               }
           }
    }
    
    func storeData() {
        let db = Database.database().reference()
        let id = Auth.auth().currentUser!.uid
        let ur = db.child("User").child(id)
        
        //TODO: Add code to make sure username is not already in database
        //TODO: Make sure new email, phone number etc. are valid like in signup view

        let user: [String: Any] = ["name": self.fullname,
                    "username": self.username,
                    "email": self.email,
                    "password": self.password,
                    "phoneNumber": self.phoneNumber,
                    "age": self.age,
                    "gender": self.gender,
                    "height": self.height,
                    "doesSnore": self.snore,
                    "hadInsomnia": self.hadinsomnia,
                    "hasInsomnia": self.hasinsomnia,
                    "hasMedication": self.hasmedication,
                    "hasNightmares": self.hasnightmares,
                    "isEarlyBird": self.isearlybird,
                    "readArticles": self.articlesRead,
                    "blocked": self.blocked
            ]
        
        
        func createUser(completion: @escaping (Bool) -> Void) {
            // Handle User Creation
            Auth.auth().createUser(withEmail: email, password: password) { authResult,
                
                error in
                  
                var authErrorMsg = ""
            
                if let error = error as NSError? {
                    if (error.code == 17007) {
                        // Check if email already in use
                        authErrorMsg = "Email already taken. Try again."
                        self.email = ""
                    } else {
                        // Handle other error messages
                        authErrorMsg = error.localizedDescription
                    }
                }
                
                if let authResult = authResult {
                    print(authResult)
                    Task {
                        do {
                            currUser = try User(userID: authResult.user.uid, name: self.fullname, email: self.email, phoneNumber: self.phoneNumber)
                        } catch {
                            authErrorMsg = error.localizedDescription
                        }
                    }
                }
                completion(authErrorMsg.isEmpty)
            }
        }
        
        ur.updateChildValues(user) { (error, reference) in
            if let error = error {
                print("Error updating user data")
            } else {
                print("updated successfully")
            }
        }
    }
    
    func storeBio() {
        let db = Database.database().reference()
        let id = Auth.auth().currentUser!.uid
        let ur = db.child("User").child(id)
        
        let user: [String: Any] = ["bio": self.bio
            ]
        
        ur.updateChildValues(user) { (error, reference) in
            if let error = error {
                print("Error updating user bio")
            } else {
                /*self.exercisesRegularly = true;
                let user: [String: Any] = ["exercisesRegularly": self.exercisesRegularly]*/
                print("bio updated successfully")
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


struct AccountInfoView: View {
    @State private var color_theme = "Dreamy Twilight"
    @StateObject private var viewModel = AccountInfoViewModel()
    @State private var toggleIsOn: Bool = false
    
    // Added state for image picker and profile image
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var profileImage: Image?
    
    
    var body: some View {
        VStack{
            NavigationView{
                ZStack{
                    LinearGradient(gradient: Gradient(colors: [.dreamyTwilightMidnightBlue.opacity(0.2), .nightfallHarmonyNavyBlue.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            Spacer().frame(height: 50)
                            Text("Account Info")
                                .font(Font.custom("NovaSquare-Bold", size: 40))
                                .frame(height: 2.0, alignment: .leading)
                                .padding()
                            Spacer().frame(height: 20)
                            
                            // Profile Image with Tap Gesture for Image Picker
                            if profileImage != nil {
                                profileImage?
                                    .resizable()
                                    .frame(width: 90, height: 85)
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        showingImagePicker = true
                                    }
                            } else {
                                Image(systemName: "person.crop.circle.fill") // Placeholder image
                                    .resizable()
                                    .frame(width: 90, height: 85)
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        showingImagePicker = true
                                    }
                            }
                            
                            //Shows Full Name
                            Text("\(viewModel.fullname)")
                                .font(.system(size: 25))
                                .fontWeight(.medium)
                                .padding()
                            
                            // Username Field
                            Text("Username: \(viewModel.username)")
                                .padding()
                                .font(.system(size: 17)).fontWeight(.medium).frame(width: 300, height: 40, alignment: .leading).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(5)
                            
                            // Email
                            Text("Email: \(viewModel.email)")
                                .padding()
                                .font(.system(size: 17)).fontWeight(.medium).frame(width: 300, height: 40, alignment: .leading).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(5)
                            
                            // Reset Password Button
                            NavigationLink(destination: ResetPasswordView()){
                                HStack{
                                    Text("Reset Password")
                                        .padding()
                                    Spacer()
                                    Image(systemName:
                                            "arrow.right")
                                    .padding()
                                }
                                .font(.system(size: 17)).fontWeight(.medium).frame(width: 300, height: 40, alignment: .leading).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(5)
                            }
                            
                            //Notification Toggle
                            Toggle(isOn: $toggleIsOn, label: {Text ("Notifications")})
                                .toggleStyle(SwitchToggleStyle(tint: .moonlitSerenityCharcoalGray))
                                .padding().frame(width:300, height: 40)
                                .fontWeight(.medium)
                                .background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(5)
                            //TODO: need to enable push notifications
                            
                            Text("Moon Rewards Count: \(viewModel.moonCount)")
                                .padding()
                                .font(.system(size: 17)).fontWeight(.medium).frame(width: 300, height: 40, alignment: .leading).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(5)
                            
                            // Friend Request Button
                            NavigationLink(destination: FriendRequestView()){
                                HStack{
                                    Text("Friend Requests")
                                        .padding()
                                    Spacer()
                                    Image(systemName:
                                            "arrow.right")
                                    .padding()
                                }
                                .font(.system(size: 17)).fontWeight(.medium).frame(width: 300, height: 40, alignment: .leading).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(5)
                            }
                            
                            // Bio Button
                            NavigationLink(destination: BioInfoView()){
                                HStack{
                                    Text("Bio")
                                        .padding()
                                    Spacer()
                                    Image(systemName:
                                            "arrow.right")
                                    .padding()
                                }
                                .font(.system(size: 17)).fontWeight(.medium).frame(width: 300, height: 40, alignment: .leading).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(5)
                            }
                            
                            // Rewards Page
                            NavigationLink(destination: RewardsDashboardView()){
                                HStack{
                                    Text("Rewards Dashboard")
                                        .padding()
                                    Spacer()
                                    Image(systemName:
                                            "arrow.right")
                                    .padding()
                                }
                                .font(.system(size: 17)).fontWeight(.medium).frame(width: 300, height: 40, alignment: .leading).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(5)
                            }
                            
                            // Edit Profile
                            NavigationLink(destination: EditProfileView().navigationBarBackButtonHidden(true)){
                                HStack{
                                    Text("Edit Profile")
                                        .padding()
                                    Spacer()
                                    Image(systemName:
                                            "arrow.right")
                                    .padding()
                                }
                                .font(.system(size: 17)).fontWeight(.medium).frame(width: 300, height: 40, alignment: .leading).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(5)
                            }
                            
                        }
                    }
                        Spacer()
                        
                        //Menu Bar
                    }.overlay(alignment: .bottom, content: {
                        
                        HStack (spacing: 30){
                            NavigationLink(destination: SleepGraphView().navigationBarBackButtonHidden(true)) {
                                
                                Image(systemName: "chart.xyaxis.line")
                                    .resizable()
                                    .frame(width: 30, height: 35)
                                    .foregroundColor(.white)
                                
                            }
                            NavigationLink(destination: SleepLogView().navigationBarBackButtonHidden(true)) {
                                
                                Image(systemName: "zzz")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                                
                            }
                            NavigationLink(destination: SleepGoalsView().navigationBarBackButtonHidden(true)) {
                                
                                Image(systemName: "list.clipboard")
                                    .resizable()
                                    .frame(width: 30, height: 40)
                                    .foregroundColor(.white)
                                
                            }
                            NavigationLink(destination: AlarmClockView()) {
                                Image(systemName: "alarm")
                                    .resizable()
                                    .frame(width: 30, height: 35)
                                    .foregroundColor(.white)
                                
                            }
                            NavigationLink(destination: ForumView().navigationBarBackButtonHidden(true)) {
                                
                                Image(systemName: "person.2")
                                    .resizable()
                                    .frame(width: 45, height: 30)
                                    .foregroundColor(.white)
                                
                            }
                            NavigationLink(destination: JournalView().navigationBarBackButtonHidden(true)) {

                                Image(systemName: "book.closed")
                                    .resizable()
                                    .frame(width: 30, height: 40)
                                    .foregroundColor(.white)
                            
                        }
                        }.padding()
                            .hSpacing(.center)
                            .background(Color.dreamyTwilightMidnightBlue)
                        
                    })
                
            }.buttonStyle(PlainButtonStyle()).sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(selectedImage: $inputImage)
                
            }
        }
            .onAppear {
                viewModel.fetchUsername()
            }
        }
    func loadImage() {
        guard let inputImage = inputImage else { return }
        profileImage = Image(uiImage: inputImage)
    }
    
    
    
}

struct BioInfoView: View {
    @StateObject private var viewModel = AccountInfoViewModel()
    private let data: [String] = ["Early Bird", "Night Owl"]
    private let preferenceColumns = [GridItem(.adaptive(minimum: 130))]
    @State private var sleepPreference = "Early Bird"

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.dreamyTwilightMidnightBlue.opacity(0.2), .nightfallHarmonyNavyBlue.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                        Text("Bio")
                        .font(Font.custom("NovaSquare-Bold", size: 40))
                            .frame(height: 2.0, alignment: .leading)
                            .padding()
                    Spacer().frame(height: 25)
                        Text("Add a brief description of yourself!")
                        .font(.system(size: 20))
                    
                    Spacer().frame(height: 25)
                    TextField("",text: $viewModel.bio)
                        .padding()
                        .frame(width: 330, height: 200, alignment: .topLeading)
                        .background(.white.opacity(0.15))
                        .cornerRadius(10)
                    Spacer().frame(height: 40)
                    
                    // Submit Bio button
                    Button ("Submit", action: {
                        // TODO: Store BIO in database
                        viewModel.storeBio()
                        if let  user = currUser {
                            user.updateMoons(rewardCount: 50)
                            user.exercisesRegularly = true;
                            user.updateValues(newValues: ["exercisesRegularly" :
                                                            user.exercisesRegularly])
                        }
                    })
                    .font(.system(size: 20)).fontWeight(.medium).frame(width: 300, height: 50).background(Color.soothingNightLightGray.opacity(0.6)).foregroundColor(.nightfallHarmonyNavyBlue.opacity(1)).cornerRadius(10)
                    
                    Spacer().frame(height: 60)
                    // Night Owl or Early Bird Question
                    Text("Night Owl or Early Bird?")
                        .font(Font.custom("NovaSquare-Bold", size: 25))
                    Spacer().frame(height: 30)
                    
                    LazyVGrid(columns: preferenceColumns, spacing: 20) {
                        ForEach(data, id: \.self) { option in
                            Button(action: {
                                self.sleepPreference = option == self.sleepPreference ? "Early Bird" : option
                            }) {
                                Text(option)
                                    .padding().frame(width: 150, height: 50).foregroundColor(.white)
                            }
                            
                            .background(self.sleepPreference == option ? Color.soothingNightLightGray.opacity(0.5) : Color.nightfallHarmonyRoyalPurple.opacity(0.8))
                            .cornerRadius(10)
                        }
                        // TODO: Store night owl early bird preference
                    }
                }
                .onAppear {
                    viewModel.fetchUsername()
                }
            }
        }
    }
}
struct EditProfileView: View {
    @StateObject private var viewModel = AccountInfoViewModel()
    @State var usernametapped: Bool = false
    @State var gologin = false;
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.dreamyTwilightMidnightBlue.opacity(0.2), .nightfallHarmonyNavyBlue.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                    //Scrolling
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            Spacer().frame(height: 40)
                            Text("Profile")
                                .font(Font.custom("NovaSquare-Bold", size: 40))
                                .frame(height: 2.0, alignment: .leading)
                                .padding()
                            Spacer().frame(height: 40)
                            
                            //Full Name
                            ZStack {
                                HStack {
                                    Text("Name: ")
                                    TextField("",text: $viewModel.fullname)
                                }
                                .padding()
                                .frame(width: 300, height: 50)
                                .background(.white.opacity(0.15))
                                .cornerRadius(10)
                            }
                            Spacer().frame(height: 15)
                            
                            //Username
                            ZStack {
                                HStack {
                                    Text("Username: ")
                                    TextField("",text: $viewModel.username)
                                }
                                .padding()
                                .frame(width: 300, height: 50)
                                .background(.white.opacity(0.15))
                                .cornerRadius(10)
                            }
                            Spacer().frame(height: 15)
                            
                            //Email
                            ZStack {
                                HStack {
                                    Text("Email: ")
                                    TextField("",text: $viewModel.email)
                                    Image(systemName: isValidEmail() ? "checkmark":"")
                                }
                                .padding()
                                .frame(width: 300, height: 50)
                                .background(.white.opacity(0.15))
                                .cornerRadius(10)
                            }
                            
                            Spacer().frame(height: 15)
                            
                            // PHONE
                            ZStack {
                                HStack {
                                    Text("Phone: ")
                                    iPhoneNumberField("", text: $viewModel.phoneNumber)
                                        .keyboardType(.decimalPad)
                                    Image(systemName: isValidPhoneNumber() ? "checkmark":"")
                                }
                                .padding()
                                .frame(width: 300, height: 50)
                                .background(.white.opacity(0.15))
                                .cornerRadius(10)
                            }
                            Spacer().frame(height: 15)
                            
                            //Age
                            ZStack {
                                HStack {
                                    Text("Age: ")
                                    TextField("",text: $viewModel.age)
                                }
                                .padding()
                                .frame(width: 300, height: 50)
                                .background(.white.opacity(0.15))
                                .cornerRadius(10)
                            }
                            
                            Spacer().frame(height: 15)
                            
                            //Gender
                            ZStack {
                                HStack {
                                    Text("Gender: ")
                                    TextField("",text: $viewModel.gender)
                                }
                                .padding()
                                .frame(width: 300, height: 50)
                                .background(.white.opacity(0.15))
                                .cornerRadius(10)
                            }
                            Spacer().frame(height: 15)
                            
                            // Height
                            ZStack {
                                HStack {
                                    Text("Height: ")
                                    TextField("",text: $viewModel.height)
                                }
                                .padding()
                                .frame(width: 300, height: 50)
                                .background(.white.opacity(0.15))
                                .cornerRadius(10)
                            }
                            Spacer().frame(height: 15)
                            
                            // TOGGLES
                            
                            //Snore
                            Toggle(isOn: $viewModel.snore, label: {Text ("Snore")})
                                .toggleStyle(SwitchToggleStyle(tint: .moonlitSerenityCharcoalGray))
                                .padding().frame(width: 300, height: 50)
                                .background(.white.opacity(0.15))
                                .cornerRadius(10)
                            Spacer().frame(height: 15)
                            
                            //Had insomnia
                            Toggle(isOn: $viewModel.hadinsomnia, label: {Text ("Had Insomnia")})
                                .toggleStyle(SwitchToggleStyle(tint: .moonlitSerenityCharcoalGray))
                                .padding().frame(width: 300, height: 50)
                                .background(.white.opacity(0.15))
                                .cornerRadius(10)
                            Spacer().frame(height: 15)
                            
                            //Have insomnia
                            Toggle(isOn: $viewModel.hasinsomnia, label: {Text ("Have Insomnia")})
                                .toggleStyle(SwitchToggleStyle(tint: .moonlitSerenityCharcoalGray))
                                .padding().frame(width: 300, height: 50)
                                .background(.white.opacity(0.15))
                                .cornerRadius(10)
                            Spacer().frame(height: 15)
                            
                            //Has mediaction
                            Toggle(isOn: $viewModel.hasmedication, label: {Text ("Medication")})
                                .toggleStyle(SwitchToggleStyle(tint: .moonlitSerenityCharcoalGray))
                                .padding().frame(width: 300, height: 50)
                                .background(.white.opacity(0.15))
                                .cornerRadius(10)
                            Spacer().frame(height: 15)
                            
                            //Nightmares
                            Toggle(isOn: $viewModel.hasnightmares, label: {Text ("Nightmares")})
                                .toggleStyle(SwitchToggleStyle(tint: .moonlitSerenityCharcoalGray))
                                .padding().frame(width: 300, height: 50)
                                .background(.white.opacity(0.15))
                                .cornerRadius(10)
                            Spacer().frame(height: 15)
                            
                            //Early Bird
                            Toggle(isOn: $viewModel.isearlybird, label: {Text ("EarlyBird")})
                                .toggleStyle(SwitchToggleStyle(tint: .moonlitSerenityCharcoalGray))
                                .padding().frame(width: 300, height: 50)
                                .background(.white.opacity(0.15))
                                .cornerRadius(10)
                            
                            Spacer().frame(height: 30)
                            
                            // Submit Bio button
                            Button ("Submit", action: {
                                /*viewModel.isEmailTaken(email: viewModel.email) { isTaken in
                                    if isTaken {
                                        print("taken")
                                    } else {*/
                                        // Proceed with saving the new email since it's not taken
                                        viewModel.storeData()
                                    //}
                                //}
                            })
                            .font(.system(size: 20)).fontWeight(.medium).frame(width: 300, height: 50).background(Color.soothingNightLightGray.opacity(0.6)).foregroundColor(.nightfallHarmonyNavyBlue.opacity(1)).cornerRadius(10)
                            
                            Spacer().frame(height: 50)
                            
                            
                            // Delete User button
                            Button (action: {
                                // TODO: Remove all info from database and return to login page
                                viewModel.deleteUser()
                                gologin = true;
                            }) {
                                Text("Delete Account")
                                    .font(.system(size: 20)).fontWeight(.medium).frame(width: 300, height: 50).background(Color.soothingNightLightGray.opacity(0.6)).foregroundColor(.nightfallHarmonyNavyBlue.opacity(1)).cornerRadius(10)
                            }
                            
                            
                            // Back button
                            NavigationLink(destination: AccountInfoView().navigationBarBackButtonHidden(true)) {
                                Text("Back to Account").underline()
                                    .foregroundColor(.black)
                            }
                            //Spacer().frame(height: 60)
                        }
                    }
                }
                .onAppear {
                    viewModel.fetchUsername()
                }
                .background(
                    NavigationLink(destination: LoginView().navigationBarBackButtonHidden(), isActive: $gologin) {
                        LoginView()
                    }
                        .hidden()
                )
            }
        }
    }
    
    /*
     * Function to verify that the email is valid
     */
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: viewModel.email)
    }
    
    
    /*
     * Function to verify that the phone-number is valid
     */
    func isValidPhoneNumber() -> Bool {
        return viewModel.phoneNumber.contains(/^\([0-9]{3}\) [0-9]{3}-[0-9]{4}$/)
    }
    
    func isValidEmail2(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: email)
    }
    
    
    /*
     * Function to verify that the phone-number is valid
     */
    func isValidPhoneNumber2(phoneNumber: String) -> Bool {
        // Regular expression for phone number validation
        let phoneRegex = "^\\([0-9]{3}\\) [0-9]{3}-[0-9]{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        
        return phoneTest.evaluate(with: phoneNumber)
    }
}

#Preview {
    AccountInfoView()
}
