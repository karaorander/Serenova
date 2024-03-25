//
//  AccountInfoView.swift
//  Serenova 2.0
//
//  Created by Kara Orander on 2/16/24.
//

import SwiftUI
import Firebase
import FirebaseDatabase

//Fetch all data from firebase
class AccountInfoViewModel: ObservableObject {
    @Published var username = ""
    @Published var email = ""
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
    @Published var isearlybird : Bool = true
    @Published var totalSleepGoalHours : Float = -1
    @Published var totalSleepGoalMins : Float = -1
    @Published var deepSleepGoalHours : Float = -1
    @Published var deepSleepGoalMins : Float = -1
    @Published var moonCount : Int = -1
    
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
    
    func deleteUser() {
        let db = Database.database().reference()
        let id = Auth.auth().currentUser!.uid
        let ur = db.child("User").child(id)
        
        db.child("User").child(id).removeValue();
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
                    "phoneNumber": self.phoneNumber,
                    "age": self.age,
                    "gender": self.gender,
                    "height": self.height,
                    "doesSnore": self.snore,
                    "hadInsomnia": self.hadinsomnia,
                    "hasInsomnia": self.hasinsomnia,
                    "hasMedication": self.hasmedication,
                    "hasNightmares": self.hasnightmares,
                    "isEarlyBird": self.isearlybird
            ]
        
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
                    
                    VStack {
                        Text("Account Info")
                            .font(Font.custom("NovaSquare-Bold", size: 40))
                            .frame(height: 2.0, alignment: .leading)
                            .padding()
                        Spacer().frame(height: 20)
                        
                        // Profile Image with Tap Gesture for Image Picker
                        if profileImage != nil {
                            profileImage?
                                .resizable()
                                .scaledToFit()
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
                        
                        Spacer().frame(height:25)
                        
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
                        
                        Text("Moon Rewards Count: \(viewModel.moonCount)")
                            .padding()
                            .font(.system(size: 17)).fontWeight(.medium).frame(width: 300, height: 40, alignment: .leading).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(5)
                    }
                    Spacer()
                    
                    //Menu Bar
                }.overlay(alignment: .bottom, content: {
                    
                    HStack (spacing: 40){
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
                        NavigationLink(destination: ForumPostView().navigationBarBackButtonHidden(true)) {
                            
                            Image(systemName: "person.2")
                                .resizable()
                                .frame(width: 45, height: 30)
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
                    TextField("\($viewModel.bio)",text: $viewModel.bio)
                        .padding()
                        .frame(width: 330, height: 200, alignment: .topLeading)
                        .background(.white.opacity(0.15))
                        .cornerRadius(10)
                    Spacer().frame(height: 40)
                    
                    // Submit Bio button
                    Button ("Submit", action: {
                        // TODO: Store BIO in database
                        viewModel.storeBio()
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
                            HStack {
                                Text("Name: ")
                                TextField("",text: $viewModel.fullname)
                            }
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white.opacity(0.15))
                            .cornerRadius(10)
                            Spacer().frame(height: 15)
                            
                            //Username
                            HStack {
                                Text("Username: ")
                                TextField("",text: $viewModel.username)
                            }
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white.opacity(0.15))
                            .cornerRadius(10)
                            Spacer().frame(height: 15)
                            
                            //Email
                            HStack {
                                Text("Email: ")
                                TextField("",text: $viewModel.email)
                            }
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white.opacity(0.15))
                            .cornerRadius(10)
                            Spacer().frame(height: 15)
                            
                            HStack {
                                Text("Phone: ")
                                TextField("",text: $viewModel.phoneNumber)
                            }
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white.opacity(0.15))
                            .cornerRadius(10)
                            Spacer().frame(height: 15)
                            
                            //Age
                            HStack {
                                Text("Age: ")
                                TextField("",text: $viewModel.age)
                            }
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white.opacity(0.15))
                            .cornerRadius(10)
                            Spacer().frame(height: 15)
                            
                            //Gender
                            HStack {
                                Text("Gender: ")
                                TextField("",text: $viewModel.gender)
                            }
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white.opacity(0.15))
                            .cornerRadius(10)
                            Spacer().frame(height: 15)
                            
                            // Height
                            HStack {
                                Text("Height: ")
                                TextField("",text: $viewModel.height)
                            }
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white.opacity(0.15))
                            .cornerRadius(10)
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
                                viewModel.storeData()
                                AccountInfoView()
                            })
                            .font(.system(size: 20)).fontWeight(.medium).frame(width: 300, height: 50).background(Color.soothingNightLightGray.opacity(0.6)).foregroundColor(.nightfallHarmonyNavyBlue.opacity(1)).cornerRadius(10)
                            
                            Spacer().frame(height: 50)
                            
                            // Submit Bio button
                            Button ("Delete Account", action: {
                                // TODO: Remove all info from database and return to login page
                                viewModel.deleteUser()
                                LoginView()
                            })
                            .font(.system(size: 20)).fontWeight(.medium).frame(width: 300, height: 50).background(Color.soothingNightLightGray.opacity(0.6)).foregroundColor(.nightfallHarmonyNavyBlue.opacity(1)).cornerRadius(10)
                            
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
            }
        }
    }
}

#Preview {
    AccountInfoView()
}
