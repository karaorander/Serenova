//
//  SignUpView.swift
//  Serenova 2.0
//
//  Created by Ava Schrandt on 2/14/24.
//

import SwiftUI
import iPhoneNumberField
import FirebaseCore
import FirebaseDatabase
import FirebaseAuth

struct SignUpView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password1 = ""
    @State private var password2 = ""
    
    @State private var showSignUp2: Bool = false
    @State private var signupError: Bool = false
    @State private var signupErrorMsg = ""
    
    @State private var toggleIsOn: Bool = false

    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        NavigationView {
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [.nightfallHarmonySilverGray.opacity(0.9), .nightfallHarmonyRoyalPurple.opacity(0.5), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                //StarsBackground()
                VStack {
                    Spacer()
                    VStack(spacing:20) {
                        // SIGN UP
                        Text("Sign Up")
                            .font(.system(size: 60, weight: .heavy))
                            .foregroundColor(.nightfallHarmonyNavyBlue.opacity(0.6))
                            .frame(height: 2.0)
                            .padding()
                        // CREATE ACCOUNT
                        Text("Create your Serenova account")
                            .multilineTextAlignment(.center)
                            .font(.caption)
                            .opacity(0.8)
                            .padding()
                        // NAME
                        ZStack {
                            HStack {
                                TextField("Full Name",text: $name)
                                Image(systemName: name.isEmpty ? "": "checkmark")
                                    .foregroundColor(.nightfallHarmonyNavyBlue.opacity(0.6))
                            }
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white.opacity(0.15))
                            .cornerRadius(10)
                        }
                        // EMAIL
                        ZStack {
                            HStack {
                                TextField("Email",text: $email)
                                Image(systemName: isValidEmail() ? "checkmark":"")
                                    .foregroundColor(.nightfallHarmonyNavyBlue.opacity(0.6))
                            }
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white.opacity(0.15))
                            .cornerRadius(10)
                        }
                        // PHONE
                        ZStack {
                            HStack {
                                iPhoneNumberField("Phone", text: $phone)
                                    .keyboardType(.decimalPad)
                                Image(systemName: isValidPhoneNumber() ? "checkmark":"")
                                    .foregroundColor(.nightfallHarmonyNavyBlue.opacity(0.6))
                            }
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white.opacity(0.15))
                            .cornerRadius(10)
                        }
                        // PASSWORD1
                        ZStack {
                            HStack {
                                SecureField("Create Password",text: $password1)
                                    .textContentType(.newPassword)
                                Image(systemName: isValidPassword() ? "checkmark":"")
                                    .foregroundColor(.nightfallHarmonyNavyBlue.opacity(0.6))
                            }
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white.opacity(0.15))
                            .cornerRadius(10)
                        }
                        // PASSWORD2
                        ZStack {
                            HStack {
                                SecureField("Confirm Password",text: $password2)
                                    .textContentType(.newPassword)
                                Image(systemName: isValidConfirmedPassword() ? "checkmark":"")
                                    .foregroundColor(.nightfallHarmonyNavyBlue.opacity(0.6))
                            }
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white.opacity(0.15))
                            .cornerRadius(10)
                        }
                    }
                    Spacer()
                    Toggle(isOn: $toggleIsOn, label: {Text ("Allow Push Notifications")})
                        .toggleStyle(SwitchToggleStyle(tint: .moonlitSerenityCharcoalGray))
                        .padding().frame(width:300, height: 20)
                        .fontWeight(.medium)
                    //TODO: need to enable push notifications
                    
                    Spacer()
                    Button(action:{checkFormComplete()}){
                        Text("Create Account").font(.system(size: 20)).fontWeight(.medium).frame(width: 300, height: 50).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(10)
                    }
                    NavigationLink ("", destination: SignUp2View().navigationBarBackButtonHidden(true), isActive: $showSignUp2)
                    Spacer()
                    NavigationLink(destination: LoginView().navigationBarBackButtonHidden()) {
                        Text("Already have an account? Login here.").underline()
                        
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())

            // ALERT
            .alert(
                "Sign Up Form Incomplete",
                isPresented: $signupError
            ) {
                Button("OK") {}
            } message: {
                Text(signupErrorMsg)
            }
        }
    }

    /*
     * Function to verify that the email is valid
     */
    func isValidEmail() -> Bool {
        return email.contains(/.+@.+\..+/)
    }
    
    /*
     * Function to verify that the phone-number is valid
     */
    func isValidPhoneNumber() -> Bool {
        return phone.contains(/^\([0-9]{3}\) [0-9]{3}-[0-9]{4}$/)
    }
    
    /*
     * Function to verify that the password is valid
     * Must be at least 8 characters
     * Must have at least one capital letter
     * Must have at least one number
     * Must have at least one special character
     */
    func isValidPassword() -> Bool {
        // Ensure password matches criteria:
        
        // 1) Password must be at least 8 characters
        if (password1.count < 8) {
            return false
        }
        
        // 2) Password must contain at least one special character
        if (!password1.contains(/[\W]/) && !password1.contains(/[_]/)) {
            return false
        }
        
        // 3) Password must contain an uppercase letter
        if (!password1.contains(where: {$0.isUppercase})) {
            return false
        }
        
        // 4) Password must contain a number
        if(!password1.contains(where: {$0.isNumber})) {
            return false
        }
        
        return true
    }
    
    /*
     * Function to check if the confirmed password matches
     * the original password and is valid
     */
    func isValidConfirmedPassword() -> Bool {
        if (password2.isEmpty || password2 != password1 || !isValidPassword()) {
            return false
        }
        return true
    }
    
    /*
     * Function to check if user can be created
     */
    func checkFormComplete() {
        // Form Error Msg for Alert
        signupErrorMsg = ""
        
        if (!isValidConfirmedPassword()) {
            signupErrorMsg = "Please confirm your password"
        }
        if (!isValidPassword()) {
            signupErrorMsg = "Please enter a valid password"
        }
        if (!isValidPhoneNumber()) {
            signupErrorMsg = "Please enter a valid phone number"
        }
        if (!isValidEmail()) {
            signupErrorMsg = "Please enter a valid email address"
        }
        if (name.isEmpty) {
            signupErrorMsg = "Please enter your full name"
        }
        
        if (signupErrorMsg != "") {
            // Add message to alert later after formatting is finished
            signupError = true
            return
        }
        showSignUp2 = true
        createUser()
    }
    
    /*
     * Function to create new user
     */
    func createUser() {
        // won't work until firebase set up (set email/password login)
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password1, completion: { result, error in
            ContentView()
            // move to ContentView
        })
    }
    
}
struct SignUp2View: View {
    private let data: [String] = ["None", "1-3 Hours", "2-4 Hours", "5-6 Hours", "7-8 Hours", "9-10 Hours", "10-12 Hours", "13-14 Hours", "15-16 Hours", "16+ Hours"]
    private let hoursColumns = [GridItem(.adaptive(minimum: 130))]
    @State private var user = "" //TODO: - get user info viewUser()
    @State private var userName = "" //TODO: username
    @State private var selectedHours = "None" //setting automatic initial selection to none
    @State private var showSignUp3: Bool = false
    var body: some View {
        
        NavigationView {
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [.nightfallHarmonySilverGray.opacity(0.9), .nightfallHarmonyRoyalPurple.opacity(0.5), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                //StarsBackground()
                VStack {
                    Spacer()
                    Text("Welcome, " + userName)
                        .font(.system(size: 100, weight: .heavy))
                        .foregroundColor(.dreamyTwilightLavenderPurple.opacity(0.9))
                        .scaledToFit().minimumScaleFactor(0.01)
                        .lineLimit(1)
                        .padding()
                    Text("First, a few questions so we can personalize your experience.").font(.system(size: 15, weight: .light)).padding().foregroundColor(.dreamyTwilightMidnightBlue)
                    Divider().frame(width: 350, height: 1).overlay(.gray)
                    Text("What does your typical night of sleep look like?").font(.system(size: 28, weight: .heavy)).padding().foregroundColor(.nightfallHarmonyNavyBlue.opacity(0.6)).multilineTextAlignment(.center)
                    Spacer()
                    
                    LazyVGrid(columns: hoursColumns, spacing: 20) {
                        ForEach(data, id: \.self) { option in
                            Button(action: {
                                self.selectedHours = option == self.selectedHours ? "None" : option
                            }) {
                                Text(option)
                                    .padding().frame(width: 150, height: 50).foregroundColor(.white)
                            }
                            
                            .background(self.selectedHours == option ? Color.soothingNightLightGray.opacity(0.5) : Color.nightfallHarmonyRoyalPurple.opacity(0.8))
                            .cornerRadius(10)
                        }
                        
                    }
                    Spacer()
                    NavigationLink (destination: SignUp3View().navigationBarBackButtonHidden(true)) {
                            Text("Next").font(.system(size: 20)).fontWeight(.medium).frame(width: 320, height: 50).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(10)
                        
                    }
                    
                }
            }
        }
    }
        
    }
                           
struct SignUp3View: View{
    private let gridLayout = [GridItem(.adaptive(minimum: 130))]
    private let genderOption: [String] = ["Male", "Female"]
    private let genderSymbol: [String] = ["♂", "♀"]
    @State private var selectedGender = "Male"
    @State private var weight:Float = 50
    @State private var height:Float = 64
    @State private var age:Float = 0
    var body: some View {
        NavigationView {
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [.nightfallHarmonySilverGray.opacity(0.9), .nightfallHarmonyRoyalPurple.opacity(0.5), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                //StarsBackground()
                VStack {
                    Spacer()
                    
                    Text("Some Personal Details")
                            .font(.system(size: 30, weight: .heavy))
                            .foregroundColor(.nightfallHarmonyNavyBlue.opacity(0.6))
                            .frame(height: 2.0)
                            .padding()
                    
                    Spacer()
                    //gender
                    LazyVGrid(columns: gridLayout, spacing: 20) {
                        ForEach(genderOption, id: \.self) { option in
                            Button(action: {
                                self.selectedGender = option == self.selectedGender ? "Male" : option
                            }) {
                                Text(option)
                                    .padding().frame(width: 150, height: 50).foregroundColor(.white)
                            }
                            
                            .background(self.selectedGender == option ? Color.soothingNightLightGray.opacity(0.5) : Color.nightfallHarmonyRoyalPurple.opacity(0.8))
                            .cornerRadius(10)
                        }
                    }
                    
                    //Height: stored as inches in $height
                    Slider(value: $height, in: 0...100, step: 1.0).padding().accentColor(.dreamyTwilightLavenderPurple)
                    Text("\(Int(height)/12) feet \(Int(height)%12) inches").font(.system(size: 20, weight: .medium)).foregroundColor(.nightfallHarmonyNavyBlue)
                    Spacer()
                    HStack{
                        Spacer()
                        VStack {
                            //Weight
                            Text("Weight: \(Int(weight))").font(.system(size: 20, weight: .heavy)).foregroundColor(.nightfallHarmonyNavyBlue)
                            Stepper("", value: $weight, in: 40...400, step: 1).labelsHidden().background(.white.opacity(0.6))
                        }
                        Spacer()
                        VStack {
                            //Age
                            Text("Age: \(Int(age))").font(.system(size: 20, weight: .heavy)).foregroundColor(.nightfallHarmonyNavyBlue)
                            Stepper("", value: $age, in: 0...100, step: 1).labelsHidden().background(.white.opacity(0.6))
                        }
                        Spacer()
                    }
            
                    Spacer()
                    NavigationLink (destination: SignUp4View().navigationBarBackButtonHidden(true)) {
                            Text("Next").font(.system(size: 20)).fontWeight(.medium).frame(width: 320, height: 50).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(10)
                        
                    }
                }
            }
        }
    }

}
struct SignUp4View: View{
    private let gridLayout = [GridItem(.adaptive(minimum: 130))]
    private let yesNoOption: [String] = ["Yes", "No"]
    private let questionnaire: [String] = ["Have you ever suffered from insomnia?", "Do you suffer from insomnia currently?", "Do you exercize regularly?", "Do you use, or have used, any special medications to get you to sleep?", "Do you snore regularly?", "Do you suffer from nightmares?"]
    @State private var selectedOption = "No"
    
    
    var body: some View {
        NavigationView {
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [.nightfallHarmonySilverGray.opacity(0.9), .nightfallHarmonyRoyalPurple.opacity(0.5), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                //StarsBackground()
                VStack {
                    Spacer()
                    ForEach(questionnaire, id: \.self) { question in
                        Text(question).font(.system(size: 20, weight: .heavy)).foregroundColor(.nightfallHarmonyNavyBlue)
                        LazyVGrid(columns: gridLayout, spacing: 20) {
                            ForEach(yesNoOption, id: \.self) { option in
                                Button(action: {
                                    self.selectedOption = option == self.selectedOption ? "No" : option
                                }) {
                                    Text(option)
                                        .padding().frame(width: 150, height: 30).foregroundColor(.white)
                                }
                                
                                .background(self.selectedOption == option ? Color.soothingNightLightGray.opacity(0.5) : Color.nightfallHarmonyRoyalPurple.opacity(0.6))
                                .cornerRadius(10)
                            }
                        }
                    }
                    Spacer()
                    NavigationLink (destination: SignUp4View().navigationBarBackButtonHidden(true)) {
                            Text("Next").font(.system(size: 20)).fontWeight(.medium).frame(width: 320, height: 50).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(10)
                    }
                    
                }
            }
        }
    }
}

#Preview {
    SignUp4View()
}
