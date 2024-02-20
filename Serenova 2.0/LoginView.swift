//
//  LoginView.swift
//  Serenova 2.0
//
//  Created by Kara Orander on 2/16/24.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @ State private var username: String = ""
    @ State private var password: String = ""
    @State private var showsignup = false
    @State private var showreset = false
    
    @State private var loginError: Bool = false
    @State private var loginErrorMsg = ""
    
    var body: some View {
    NavigationView{
            ZStack {
                
                // Color gradient
                LinearGradient(gradient: Gradient(colors: [.nightfallHarmonySilverGray.opacity(0.9), .nightfallHarmonyRoyalPurple.opacity(0.5), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack {
                    VStack(spacing:20) {
                        Text("Login")
                            .font(.system(size: 45, weight: .heavy))
                            .foregroundColor(.nightfallHarmonyNavyBlue.opacity(0.6))
                            .frame(height: 2.0)
                            .padding()
                        
                        Text("Please log in to continue")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 15))
                            .opacity(0.8)
                            .padding()
                        
                        TextField("Username",text: $username)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white.opacity(0.15))
                            .cornerRadius(10)
                        
                        SecureField("Password",text: $password)
                            .textContentType(.newPassword)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white.opacity(0.15))
                            .cornerRadius(10)
                    }
                    
                    // Forgot password link
                    Spacer().frame(height: 20)
                    NavigationLink(destination: ResetPasswordView().navigationBarBackButtonHidden(true)) {
                        Text("Forgot Password?").underline()
                    }
                    
                    // Login button
                    Spacer().frame(height:25)
                    Button(action:{checkFormComplete()}){
                        Text("Login").font(.system(size: 20)).fontWeight(.medium).frame(width: 300, height: 50).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(10)
                    }
                    
                    
                    Spacer().frame(height: 20)
                    NavigationLink(destination: SignUpView().navigationBarBackButtonHidden(true)) {
                        Text("Sign Up").underline()
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        // ALERT
        .alert(
            "Login Form Incomplete",
            isPresented: $loginError
        ) {
            Button("OK") {}
        } message: {
            Text(loginErrorMsg)
        }
    }
    
    /*
     * Function to check if user can login
     */
    func checkFormComplete() {

        // Form Error Msg for Alert
        loginErrorMsg = ""
        
        if (username.isEmpty) {
            loginErrorMsg = "Please enter your username"
        }
        if (password.isEmpty) {
            if ( loginErrorMsg == "") {
                 loginErrorMsg = "Please enter your password"
            } else {
                loginErrorMsg += " and password"
            }
        }
        
        // Alert User for Error
        if (loginErrorMsg != "") {
            loginError = true
            return
        }
        
        //login()
            
    }
}

/*
func login() {
    // firebase authentication login
    // won't work until firebase set up
    FirebaseAuth.Auth.auth().signIn(withEmail: username, password: password, completion: { [weak self] result, error in
        guard let strongSelf = self else {
            return
        }

        guard error == nil else {
            strongSelf.failedLogin()
            return
        }

        ContentView()
    })
}

func failedLogin() {
    let alert = UIAlertController(title: "Failed Login",
                                  message: "Email or Password is incorrect",
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Continue",
                                  style: .default
                                  handler: { in
    }))
    alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel
                                      handler: { in
    }))

    present(alert, animated: true)
}
*/
#Preview {
    LoginView()
}
