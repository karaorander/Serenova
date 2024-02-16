//
//  LoginView.swift
//  Serenova 2.0
//
//  Created by Kara Orander on 2/16/24.
//

import SwiftUI

struct LoginView: View {
    @ State private var username: String = ""
    @ State private var password: String = ""
    @State private var showsignup = false
    @State private var showreset = false
    var body: some View {
    NavigationView{
            ZStack {
                
                // Color gradient
                LinearGradient(gradient: Gradient(colors: [.nightfallHarmonySilverGray.opacity(0.9), .nightfallHarmonyRoyalPurple.opacity(0.5), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack {
                    //Spacer()
                    VStack(spacing:20) {
                        Text("Login")
                            .font(.system(size: 45, weight: .heavy))
                            .foregroundColor(.nightfallHarmonyNavyBlue)
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
                    Button(action:{login()}){
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
}

func login() {
    // firebase authentication login
}

#Preview {
    LoginView()
}
