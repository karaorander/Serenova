//  ResetPassword.swift
//  Serenova 2.0
//
//  Created by Ishwarya Samavedhi on 2/14/24.
//

import SwiftUI
import FirebaseAuth

// Need to implement after adding project to firebase: import Firebase
struct ResetPasswordView: View {
    @State private var email: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
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
                            .foregroundColor(.nightfallHarmonyNavyBlue.opacity(0.6))
                            .frame(height: 2.0)
                            .padding()
                        Text("Reset your Servenova Account Password")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 15))
                            .opacity(0.8)
                            .padding()
                        TextField("Email",text: $email)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white.opacity(0.15))
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                    Button(action: sendPasswordResetEmail) {
                                            Text("Send Reset Email")
                                                .font(.system(size: 20))
                                                .fontWeight(.medium)
                                                .frame(width: 300, height: 50)
                                                .background(Color.tranquilMistAshGray)
                                                .foregroundColor(.nightfallHarmonyNavyBlue)
                                                .cornerRadius(10)
                                        }
                    Spacer().frame(height: 80)
                    NavigationLink(destination: SignUpView().navigationBarBackButtonHidden(true)) {
                        Text("Don't Need to Reset Password?").underline()
                    }
                    
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Password Reset"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    
        func sendPasswordResetEmail() {
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    // Handle errors, such as if the email is not found
                    self.alertMessage = "Error: \(error.localizedDescription)"
                    self.showAlert = true
                    return
                }

                // Success, password reset email sent
                self.alertMessage = "Password reset email sent. Please check your inbox."
                self.showAlert = true
            }
        }
    
}
#Preview {
    ResetPasswordView()
}
