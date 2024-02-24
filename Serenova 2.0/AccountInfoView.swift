//
//  AccountInfoView.swift
//  Serenova 2.0
//
//  Created by Kara Orander on 2/16/24.
//

import SwiftUI

struct AccountInfoView: View {
    @State private var color_theme = "Dreamy Twilight"
    // TODO: Get username, full name, email, notification preferences from database
    @State private var username = "MYUSERNAME"
    @State private var email = "MYEMAIL"
    @State private var fullname = "MYNAME"
    @State private var notifications: Bool = false
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
                        VStack {
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
                        }
                        
                        Image(.userimageprofile)
                            .resizable()
                            .frame(width: 90, height: 85)
                        Spacer().frame(height:25)
                        
                        //Shows Full Name
                        Text("\(fullname)")
                            .font(.system(size: 25))
                            .fontWeight(.medium)
                            .padding()
                        
                        
                        // Username Field
                        Text("Username: \(username)")
                            .padding()
                            .font(.system(size: 17)).fontWeight(.medium).frame(width: 300, height: 40, alignment: .leading).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(5)
                        
                        // Email
                        Text("Email: \(username)")
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
                    }
                    Spacer()
                    
                //Menu Bar
                }.overlay(alignment: .bottom, content: {
                    
                    HStack (spacing: 40){
                        
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
                        NavigationLink(destination: ForumPostView().navigationBarBackButtonHidden(true)) {

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
    }
}

struct BioInfoView: View {
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
                
            }
        }
    }
}

#Preview {
    AccountInfoView()
}
