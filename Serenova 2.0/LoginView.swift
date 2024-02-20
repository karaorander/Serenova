//
//  LoginView.swift
//  Serenova 2.0
//
//  Created by Kara Orander on 2/16/24.
//

import SwiftUI
import FirebaseAuth
import UIKit


struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showsignup = false
    @State private var showreset = false
    @State private var isAuthenticated = false



    
    weak var viewController: UIViewController?
    
    func getEmail() -> String {
        return email
    }
    
    func getPassword() -> String {
        return password
    }
    
    
    var body: some View {

                
               
        
    NavigationView{
            ZStack {
                NavigationLink(destination: ContentView().navigationBarBackButtonHidden(), isActive: $isAuthenticated) { EmptyView() } // Add this line
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
                        
                        TextField("Email",text: $email)
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
                    Button(action:{
                        login()}){
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
    }

    func login() {
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            print("email: " + email)
            print("password: " + password)
        
            if let error = error {
                failedLogin()
                print(error)
            }

            if let authResult = authResult {
                isAuthenticated = true
                print(authResult)

            }
        }
    }

    func failedLogin() {
        let alert = UIAlertController(title: "Failed Login", message: "Email or Password is incorrect", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))

        
        // Present the alert if this code is within a UIViewController
        //present(alert, animated: true)
        //viewController?.present(alert, animated: true)
        //self.present(alert, animated: true)
    }
}

#Preview {
    LoginView()
}
