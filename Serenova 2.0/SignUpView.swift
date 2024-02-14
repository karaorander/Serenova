//
//  SignUpView.swift
//  Serenova 2.0
//
//  Created by Ava Schrandt on 2/14/24.
//

import SwiftUI

struct SignUpView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var verifyPassword = ""

    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [.nightfallHarmonySilverGray.opacity(0.9), .nightfallHarmonyRoyalPurple.opacity(0.5), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            StarsBackground()
            VStack {
                Spacer()
                VStack(spacing:20) {
                    Text("Sign Up")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(.nightfallHarmonyNavyBlue)
                        .frame(height: 1.0)
                    Text("Create your Serenova account")
                        .multilineTextAlignment(.center)
                        .font(.caption)
                        .opacity(0.8)
                        .padding(.bottom)
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
                    SecureField("Create Password",text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(.white.opacity(0.15))
                        .cornerRadius(10)
                    SecureField("Confirm Password",text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(.white.opacity(0.15))
                        .cornerRadius(10)
                    
                }
                Spacer()
                Button(action:{}){
                    Text("Create Account").font(.system(size: 20)).fontWeight(.medium).frame(width: 300, height: 50).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(10)
                }
                Spacer()
                Text("Already have an account? Login here.").underline().onTapGesture {
                    //toggle login page here
                }
                
            }
        }
        

        
        
    }
}
struct StarsBackground: View {
    let smallStarsCoordinats: [[CGFloat]] =
    [
        [-170, -290],
        [80, -290],
        [-100, -230],
        [-150, -180],
        [-140, -90],
        [-170, 30],
        [-180, 130],
        [-130, 140],
        [-20, 160],
        [-100, 100],
        [-130, -30],
        [130, -220],
        [-70, -320],
        [175, 0],
        [100, -85],
        [-80, -130],
        [70, 130],
        [120, 120],
        [100, 250],
        [180, 280],
        [160, 180]
    ]
    let bigStarsCoordinats: [[CGFloat]] =
        [
            [-0, -300],
            [50, -350],
            [-150, -330],
            [-140, -250],
            [-80, -182],
            [-160, -150],
            [80, -170],
            [-170, 0],
            [-140, 60],
            [-90, 150],
            [10, -140],
            [150, -120],
            [170, -340],
            [120, -40],
            [110, 60],
            [180, 100],
            [-10, 105],
            [-182, -70],
            [100, 180],
            [150, 310],
            [130, 270],
            [90, 300]
        ]
    var body: some View {
            ZStack {
                ForEach(smallStarsCoordinats, id:\.self) { coor in
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 1.5, height: 1.5)
                        .offset(x: coor[0], y: coor[1])
                }
                
                ForEach(bigStarsCoordinats, id:\.self) { coor in
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 3, height: 3)
                        .offset(x: coor[0], y: coor[1])
                }
                
                
            }
        }
    }
#Preview {
    SignUpView()
}
