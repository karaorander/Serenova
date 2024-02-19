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
        
        //createUser()
        
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
#Preview {
    SignUpView()
}
