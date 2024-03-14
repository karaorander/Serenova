//
//  AccountInfoView.swift
//  Serenova 2.0
//
//  Created by Kara Orander on 2/16/24.
//

import SwiftUI
import Firebase
import FirebaseDatabase

// TODO: DELETE ACCOUNT BUTTON

// TODO: GET AND STORE EARLY BIRD OR NIGHT OWL PREFERENCE

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
    @Published var notifications: Bool = false
    @Published var snore : Bool = true
    @Published var hadinsomnia : Bool = true
    @Published var hasinsomnia : Bool = true
    @Published var hasmedication : Bool = true
    @Published var hasnightmares : Bool = true
    @Published var isearlybird : Bool = true
    
    func fetchUsername() {
        let db = Database.database().reference()
        let id = Auth.auth().currentUser!.uid
        let ur = db.child("User").child(id)
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
}

struct AccountInfoView: View {
    @State private var color_theme = "Dreamy Twilight"
    // TODO: Get username, full name, email, notification preferences from database
    @StateObject private var viewModel = AccountInfoViewModel()
    @State private var toggleIsOn: Bool = false
    
    
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
                        
                        // Color drop down menu
                        // Color theme stored in $color_theme
                        /*VStack {
                            
                            HStack {
                                Button {
                                    color_theme = "Moonlit Serenity"
                                } label: {
                                    Circle()
                                        .foregroundColor(.moonlitSerenitySteelBlue)
                                        .frame(height: 30)
                                }
                                Button {
                                    color_theme = "Soothing Night"
                                } label: {
                                    Circle()
                                        .foregroundColor(.soothingNightAccentBlue)
                                        .frame(height: 30)
                                }
                                Button {
                                    color_theme = "Tranquil Mist"
                                } label: {
                                    Circle()
                                        .foregroundColor(.tranquilMistTealBlue)
                                        .frame(height: 30)
                                }
                                Button {
                                    color_theme = "Dreamy Twilight"
                                } label: {
                                    Circle()
                                        .foregroundColor(.dreamyTwilightLavenderPurple)
                                        .frame(height: 30)
                                }
                                Button {
                                    color_theme = "Nightfall Harmony"
                                } label: {
                                    Circle()
                                        .foregroundColor(.nightfallHarmonyRoyalPurple)
                                        .frame(height: 30)
                                }
                            }
                            
                            Spacer().frame(height:30)
                        }*/
                        
                        Image(.userimageprofile)
                            .resizable()
                            .frame(width: 90, height: 85)
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
                        NavigationLink(destination: ResetPasswordView()){
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
                        NavigationLink(destination: ForumView().navigationBarBackButtonHidden(true)) {
                            
                            Image(systemName: "person.2")
                                .resizable()
                                .frame(width: 45, height: 30)
                                .foregroundColor(.white)
                            
                        }
                    }.padding()
                        .hSpacing(.center)
                        .background(Color.dreamyTwilightMidnightBlue)
                    
                })
                
            }.buttonStyle(PlainButtonStyle())
            
        }
        .onAppear {
            viewModel.fetchUsername()
        }
    }
}

struct BioInfoView: View {
    @StateObject private var viewModel = AccountInfoViewModel()
    @State private var biotext = "Write your bio here!"
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
                    TextField("\(biotext)",text: $biotext)
                        .padding()
                        .frame(width: 330, height: 200, alignment: .topLeading)
                        .background(.white.opacity(0.15))
                        .cornerRadius(10)
                    Spacer().frame(height: 40)
                    
                    // Submit Bio button
                    Button ("Submit", action: {
                        // TODO: Store BIO in database
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
    EditProfileView()
}
