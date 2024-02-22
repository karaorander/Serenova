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
    @State private var authError: Bool = false;
    @State private var authErrorMsg = ""
    
    @State private var toggleIsOn: Bool = false
    @State private var passwordTapped: Bool = false;

    @Environment(\.presentationMode) var presentationMode
    
    
    // Getter functions
    func getName() -> String {
        return name
    }
    
    func getEmail() -> String {
        return email
    }

    func getPhone() -> String {
        return phone
    }

    func getPassword1() -> String {
        return password1
    }

    func getPassword2() -> String {
        return password2
    }
    
    mutating func setName(_ newName: String) {
        name = newName
    }

    mutating func setEmail(_ newEmail: String) {
        email = newEmail
    }

    mutating func setPhone(_ newPhone: String) {
        phone = newPhone
    }

    mutating func setPassword1(_ newPassword: String) {
        password1 = newPassword
    }

    mutating func setPassword2(_ newPassword: String) {
        password2 = newPassword
    }

    func getToggleIsOn() -> Bool {
        return toggleIsOn
    }
    
    
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
                            .font(Font.custom("NovaSquare-Bold", size: 45))
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
                                    .onTapGesture {
                                        passwordTapped = true
                                    }
                                Image(systemName: isValidPassword() ? "checkmark":"")
                                    .foregroundColor(.nightfallHarmonyNavyBlue.opacity(0.6))
                            }
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white.opacity(0.15))
                            .cornerRadius(10)
                        }
                        // PASSWORD CRITERIA
                        if (passwordTapped) {
                            VStack (alignment: .leading){
                                Text("Password Requirements:")
                                    .fontWeight(.bold)
                                Spacer().frame(height: 10)
                                HStack {
                                    Image(systemName: isValidLength() ? "checkmark":"xmark")
                                        .foregroundColor(Color.nightfallHarmonySilverGray.opacity(0.9))
                                    Text("at least 8 characters")
                                }
                                HStack {
                                    Image(systemName: hasSpecialChar() ? "checkmark":"xmark")
                                        .foregroundColor(Color.nightfallHarmonySilverGray.opacity(0.9))
                                    Text("at least 1 special character")
                                }
                                HStack {
                                    Image(systemName: hasUppercaseChar() ? "checkmark":"xmark")
                                        .foregroundColor(Color.nightfallHarmonySilverGray.opacity(0.9))
                                    Text("at least 1 uppercase character")
                                }
                                HStack {
                                    Image(systemName: hasNumber() ? "checkmark":"xmark")
                                        .foregroundColor(Color.nightfallHarmonySilverGray.opacity(0.9))
                                    Text("at least 1 number")
                                }
                            }
                            .font(.caption)
                            .frame(width: passwordTapped ? 300: 0, height: passwordTapped ? 110 : 0)
                            .foregroundColor(Color.nightfallHarmonySilverGray.opacity(0.9))
                            .background(Color.nightfallHarmonyNavyBlue.opacity(0.6))
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
            .onTapGesture {
                passwordTapped = false
            }

            // ALERT (for signup form error)
            .alert(
                "Sign Up Form Incomplete",
                isPresented: $signupError
            ) {
                Button("OK") {}
            } message: {
                Text(signupErrorMsg)
            }
            
            // ALERT (for signup error)
            .alert(
                "Sign Up Failed",
                isPresented: $authError
            ) {
                Button("OK") {}
            } message: {
                Text(authErrorMsg)
            }
        }
    }

    /*
     * Function to verify that the email is valid
     */
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: email)
    }
    
    /*
     * Function to verify that the phone-number is valid
     */
    func isValidPhoneNumber() -> Bool {
        return phone.contains(/^\([0-9]{3}\) [0-9]{3}-[0-9]{4}$/)
    }
    
    /*
     * Function to verify that there are 8 characters
     * in the password
     */
    func isValidLength() -> Bool {
        // 1) Password must be at least 8 characters
        return password1.count >= 8
    }
    
    /*
     * Function to verify that there is a special
     * character in the password
     */
    func hasSpecialChar() -> Bool {
        // 2) Password must contain at least one special character
        return password1.contains(/[\W]/) && !password1.contains(/[_]/)
    }
    
    /*
     * Function to verify that there is an uppercase
     * letter in the password
     */
    func hasUppercaseChar() -> Bool {
        // 3) Password must contain an uppercase letter
        return password1.contains(where: {$0.isUppercase})
    }
    
    /*
     * Function to verify that there is a number
     * in the password
     */
    func hasNumber() -> Bool {
        // 4) Password must contain a number
        return password1.contains(where: {$0.isNumber})
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
        return isValidLength() && hasSpecialChar() && hasUppercaseChar() && hasNumber()
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
        
        if (name.isEmpty) {
            signupErrorMsg = "Please enter your full name"
        } else if (!isValidEmail()) {
            signupErrorMsg = "Please enter a valid email address"
        } else if (!isValidPhoneNumber()) {
            signupErrorMsg = "Please enter a valid phone number"
        }  else if (!isValidPassword()) {
            signupErrorMsg = "Please enter a valid password"
        } else if (!isValidConfirmedPassword()) {
            signupErrorMsg = "Please confirm your password"
        }
        
        if (signupErrorMsg != "") {
            // Add message to alert later after formatting is finished
            signupError = true
            return
        }
        
        createUser { success in
            if (success) {
                showSignUp2 = true
            } else {
                authError = true
                return
            }
        }
    }
    
    /*
     * Function to create new user
     */
    func createUser(completion: @escaping (Bool) -> Void) {
        // Handle User Creation
        Auth.auth().createUser(withEmail: email, password: password1) { authResult, error in
          
            authErrorMsg = ""
            
            if let error = error as NSError? {

                if (error.code == 17007) {
                    // Check if email already in use
                    authErrorMsg = "Email already taken. Try again."
                    email = ""
                } else {
                    // Handle other error messages
                    authErrorMsg = error.localizedDescription
                }

            }
            
            if let authResult = authResult {
                print(authResult)
                Task {
                    currUser = await User(authResult: authResult, login: false)
                }
            }
            
            completion(authErrorMsg.isEmpty)
            
        }
    }
    
}

#Preview {
    SignUpView()
}
