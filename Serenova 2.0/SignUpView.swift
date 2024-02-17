//
//  SignUpView.swift
//  Serenova 2.0
//
//  Created by Ava Schrandt on 2/14/24.
//

import SwiftUI
// Need to implement after adding project to firebase: import Firebase
struct SignUpView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password1 = ""
    @State private var password2 = ""
    
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
                        Text("Sign Up")
                            .font(.system(size: 60, weight: .heavy))
                            .foregroundColor(.nightfallHarmonyNavyBlue.opacity(0.6))
                            .frame(height: 2.0)
                            .padding()
                        Text("Create your Serenova account")
                            .multilineTextAlignment(.center)
                            .font(.caption)
                            .opacity(0.8)
                            .padding()
                        TextField("Full Name",text: $name)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white.opacity(0.15))
                            .cornerRadius(10)
                        
                        TextField("Email",text: $email)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white.opacity(0.15))
                            .cornerRadius(10)
                        TextField("Phone",text: $phone)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white.opacity(0.15))
                            .cornerRadius(10)
                        SecureField("Create Password",text: $password1)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white.opacity(0.15))
                            .cornerRadius(10)
                        SecureField("Confirm Password",text: $password2)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(.white.opacity(0.15))
                            .cornerRadius(10)
                        
                    }
                    Spacer()
                    Toggle(isOn: $toggleIsOn, label: {Text ("Allow Push Notifications")})
                        .toggleStyle(SwitchToggleStyle(tint: .moonlitSerenityCharcoalGray))
                        .padding().frame(width:300, height: 20)
                        .fontWeight(.medium)
                    //TODO: need to enbale push notifications
                    
                    Spacer()
                    Button(action:{createUser()}){
                        Text("Create Account").font(.system(size: 20)).fontWeight(.medium).frame(width: 300, height: 50).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(10)
                    }
                    Spacer()
                    
                    NavigationLink(destination: LoginView().navigationBarBackButtonHidden()) {
                        Text("Already have an account? Login here.").underline()
                        
                    }
                    
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        
        
        
    }

    func createUser() {
        //ensure no fields are empty
        if (name != "" && email != "" && phone != "" && password1 != "" && password2 != "") {
            if(password1 == password2) {
                //firebase authentication
                //i.e. Auth.auth.createUser()
            } else {
                print("error!")
            }
        } else {
            print("Error!")
        }
    }
    
    //not sure if this falls under UI
    //making sure all text fields are valid upon submission
    
    
}
#Preview {
    SignUpView()
}
