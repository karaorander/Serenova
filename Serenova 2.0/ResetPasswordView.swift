//
//  SignUpView.swift
//  Serenova 2.0
//
//  Created by Ava Schrandt on 2/14/24.
//

import SwiftUI
// Need to implement after adding project to firebase: import Firebase
struct ResetPasswordView: View {
    @State private var username: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var emailConfirmationCode: String = ""
    
    @State private var toggleIsOn: Bool = false
    @State private var showAlert1 = true
    @State private var showAlert2 = false
    
    var body: some View {
        NavigationView{
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [.nightfallHarmonySilverGray.opacity(0.9), .nightfallHarmonyRoyalPurple.opacity(0.5), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                //StarsBackground()
                VStack {
                    Spacer()
                    VStack(spacing:20) {
                        Text("Reset Password")
                            .font(.system(size: 45, weight: .heavy))
                            .foregroundColor(.nightfallHarmonyNavyBlue)
                            .frame(height: 2.0)
                            .padding()
                        Text("Reset your Servenova Account Password")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 15))
                            .opacity(0.8)
                            .padding()
                        TextField("Username",text: $username)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white.opacity(0.15))
                            .cornerRadius(10)
                        
                        SecureField("New Password",text: $newPassword)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white.opacity(0.15))
                            .cornerRadius(10)
                        SecureField("Confirm Password",text: $newPassword)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white.opacity(0.15))
                            .cornerRadius(10)
                        TextField("Email Confirmation Code",text: $emailConfirmationCode)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white.opacity(0.15))
                            .cornerRadius(10)
                        
                    }
                    
                    Spacer()
                    Button(action:{resetPass()}){
                        Text("Reset Password").font(.system(size: 20)).fontWeight(.medium).frame(width: 300, height: 50).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(10)
                    }
                    Spacer().frame(height: 80)
                    NavigationLink(destination: SignUpView().navigationBarBackButtonHidden(true)) {
                        Text("Don't Need to Reset Password?").underline()
                    }
                    
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    
    
    func resetPass() {
        if (username != "" && newPassword != "" && confirmPassword != "") {
            if(newPassword == confirmPassword) {
                //firebase authentication
                //i.e. Auth.auth.createUser()
            } else {
                print("error!")
            }
        } else {
            print("Error!")
        }
    }
    
}
#Preview {
    ResetPasswordView()
}
