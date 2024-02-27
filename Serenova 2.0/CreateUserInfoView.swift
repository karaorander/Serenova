//
//  CreateUserInfoView.swift
//  Serenova 2.0
//
//  Created by Ava Schrandt on 2/20/24.
//

import SwiftUI

struct SignUp2View: View {
    private let data: [String] = ["None", "1-3 Hours", "2-4 Hours", "5-6 Hours", "7-8 Hours", "9-10 Hours", "10-12 Hours", "13-14 Hours", "15-16 Hours", "16+ Hours"]
    private let hoursColumns = [GridItem(.adaptive(minimum: 130))]
    @State private var user = "" //TODO: - get user info viewUser()
    @State private var userName = "" //TODO: username
    @State private var selectedHours = "None" //setting automatic initial selection to none
    @State private var showSignUp3: Bool = false
    var body: some View {
        
        NavigationView {
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [.nightfallHarmonySilverGray.opacity(0.9), .nightfallHarmonyRoyalPurple.opacity(0.5), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                //StarsBackground()
                VStack {
                    Spacer()
                    Text("Welcome, " + userName)
                        .font(.system(size: 100, weight: .heavy))
                        .foregroundColor(.dreamyTwilightLavenderPurple.opacity(0.9))
                        .scaledToFit().minimumScaleFactor(0.01)
                        .lineLimit(1)
                        .padding()
                    Text("First, a few questions so we can personalize your experience.").font(.system(size: 15, weight: .light)).padding().foregroundColor(.dreamyTwilightMidnightBlue)
                    Divider().frame(width: 350, height: 1).overlay(.gray)
                    Text("What does your typical night of sleep look like?").font(.system(size: 28, weight: .heavy)).padding().foregroundColor(.nightfallHarmonyNavyBlue.opacity(0.6)).multilineTextAlignment(.center)
                    Spacer()
                    
                    LazyVGrid(columns: hoursColumns, spacing: 20) {
                        ForEach(data, id: \.self) { option in
                            Button(action: {
                                self.selectedHours = option == self.selectedHours ? "None" : option
                            }) {
                                Text(option)
                                    .padding().frame(width: 150, height: 50).foregroundColor(.white)
                            }
                            
                            .background(self.selectedHours == option ? Color.soothingNightLightGray.opacity(0.5) : Color.nightfallHarmonyRoyalPurple.opacity(0.8))
                            .cornerRadius(10)
                        }
                        
                    }
                    Spacer()
                    Button(action:{
                        updateUserValues()
                        showSignUp3 = true
                    }){
                        Text("Next").font(.system(size: 20)).fontWeight(.medium).frame(width: 320, height: 50).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(10)
                    }
                    NavigationLink ("", destination: SignUp3View().navigationBarBackButtonHidden(true), isActive: $showSignUp3)
                }
            }
        }
    }

    func updateUserValues() {
        
        /* Update user values asynchronously */
        if let currUser = currUser {
            currUser.typicalSleepTime = selectedHours
            currUser.updateValues(newValues: ["typicalSleepTime" : currUser.typicalSleepTime])
        } else {
            print("ERROR! No account found (preview mode?)")
        }

    }
    
}
                           
struct SignUp3View: View{
    private let gridLayout = [GridItem(.adaptive(minimum: 130))]
    private let genderOption: [String] = ["Male", "Female"]
    private let genderSymbol: [String] = ["♂", "♀"]
    @State private var selectedGender = "Male"
    @State private var weight:Float = 50
    @State private var height:Float = 64
    @State private var age:Int = 0
    @State private var showSignUp4: Bool = false
    var body: some View {
        NavigationView {
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [.nightfallHarmonySilverGray.opacity(0.9), .nightfallHarmonyRoyalPurple.opacity(0.5), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                //StarsBackground()
                VStack {
                    Spacer()
                    
                    Text("Some Personal Details")
                            .font(.system(size: 30, weight: .heavy))
                            .foregroundColor(.nightfallHarmonyNavyBlue.opacity(0.6))
                            .frame(height: 2.0)
                            .padding()
                    
                    Spacer()
                    //gender
                    LazyVGrid(columns: gridLayout, spacing: 20) {
                        ForEach(genderOption, id: \.self) { option in
                            Button(action: {
                                self.selectedGender = option == self.selectedGender ? "Male" : option
                            }) {
                                Text(option)
                                    .padding().frame(width: 150, height: 50).foregroundColor(.white)
                            }
                            
                            .background(self.selectedGender == option ? Color.soothingNightLightGray.opacity(0.5) : Color.nightfallHarmonyRoyalPurple.opacity(0.8))
                            .cornerRadius(10)
                        }
                    }
                    
                    //Height: stored as inches in $height
                    Slider(value: $height, in: 0...100, step: 1.0).padding().accentColor(.dreamyTwilightLavenderPurple)
                    Text("\(Int(height)/12) feet \(Int(height)%12) inches").font(.system(size: 20, weight: .medium)).foregroundColor(.nightfallHarmonyNavyBlue)
                    Spacer()
                    HStack{
                        Spacer()
                        VStack {
                            //Weight
                            Text("Weight: \(Int(weight))").font(.system(size: 20, weight: .heavy)).foregroundColor(.nightfallHarmonyNavyBlue)
                            Stepper("", value: $weight, in: 40...400, step: 1).labelsHidden().background(.white.opacity(0.6))
                        }
                        Spacer()
                        VStack {
                            //Age
                            Text("Age: \(Int(age))").font(.system(size: 20, weight: .heavy)).foregroundColor(.nightfallHarmonyNavyBlue)
                            Stepper("", value: $age, in: 0...100, step: 1).labelsHidden().background(.white.opacity(0.6))
                        }
                        Spacer()
                    }
            
                    Spacer()
                    Button(action:{
                        updateUserValues()
                        showSignUp4 = true
                    }){
                        Text("Next").font(.system(size: 20)).fontWeight(.medium).frame(width: 320, height: 50).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(10)
                    }
                    NavigationLink ("", destination: SignUp4View().navigationBarBackButtonHidden(true), isActive: $showSignUp4)
                }
            }
        }
    }
    
    func updateUserValues() {
        
        /* Update user values asynchronously */
        if let currUser = currUser {
            if selectedGender == "Male" {
                currUser.gender = User.Gender.Male
            } else {
                currUser.gender = User.Gender.Female
            }
            //currUser.weight = weight
            //currUser.height = height
            currUser.age = age
            currUser.updateValues(newValues: ["gender" : selectedGender,
                                              "weight" : currUser.weight,
                                              "height" : currUser.height,
                                              "age"    : currUser.age])
        } else {
            print("ERROR! No account found (preview mode?)")
        }

    }

}
struct SignUp4View: View{
    private let gridLayout = [GridItem(.adaptive(minimum: 130))]
    private let yesNoOption: [String] = ["Yes", "No"]
    private let questionnaire: [String] = ["Have you ever suffered from insomnia?", "Do you suffer from insomnia currently?", "Do you exercize regularly?", "Do you use, or have used, any special medications to get you to sleep?", "Do you snore regularly?", "Do you suffer from nightmares?"]
    @State private var selection1 = "No"
    @State private var selection2 = "No"
    @State private var selection3 = "No"
    @State private var selection4 = "No"
    @State private var selection5 = "No"
    @State private var selection6 = "No"
    
    @State private var showSignUp5: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [.nightfallHarmonySilverGray.opacity(0.9), .nightfallHarmonyRoyalPurple.opacity(0.5), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    Text(questionnaire[0]).font(.system(size: 20, weight: .heavy)).foregroundColor(.nightfallHarmonyNavyBlue).padding()
                    HStack {
                        ForEach(yesNoOption, id: \.self) { option in
                            Button(action: {
                                self.selection1 = option == self.selection1 ? "No" : option
                            }) {
                                Text(option)
                                    .padding().frame(width: 150, height: 30).foregroundColor(.white)
                            }.background(self.selection1 == option ? Color.soothingNightLightGray.opacity(0.5) : Color.nightfallHarmonyRoyalPurple.opacity(0.6))
                                .cornerRadius(10)
                        }
                    }
                    Text(questionnaire[1]).font(.system(size: 20, weight: .heavy)).foregroundColor(.nightfallHarmonyNavyBlue).padding()
                    HStack {
                        ForEach(yesNoOption, id: \.self) { option in
                            Button(action: {
                                self.selection2 = option == self.selection2 ? "No" : option
                            }) {
                                Text(option)
                                    .padding().frame(width: 150, height: 30).foregroundColor(.white)
                            }.background(self.selection2 == option ? Color.soothingNightLightGray.opacity(0.5) : Color.nightfallHarmonyRoyalPurple.opacity(0.6))
                                .cornerRadius(10)
                        }
                    }
                    Text(questionnaire[2]).font(.system(size: 20, weight: .heavy)).foregroundColor(.nightfallHarmonyNavyBlue).padding()
                    HStack {
                        ForEach(yesNoOption, id: \.self) { option in
                            Button(action: {
                                self.selection3 = option == self.selection3 ? "No" : option
                            }) {
                                Text(option)
                                    .padding().frame(width: 150, height: 30).foregroundColor(.white)
                            }.background(self.selection3 == option ? Color.soothingNightLightGray.opacity(0.5) : Color.nightfallHarmonyRoyalPurple.opacity(0.6))
                                .cornerRadius(10)
                        }
                    }
                    Text(questionnaire[3]).font(.system(size: 20, weight: .heavy)).foregroundColor(.nightfallHarmonyNavyBlue).padding()
                    HStack {
                        ForEach(yesNoOption, id: \.self) { option in
                            Button(action: {
                                self.selection4 = option == self.selection4 ? "No" : option
                            }) {
                                Text(option)
                                    .padding().frame(width: 150, height: 30).foregroundColor(.white)
                            }.background(self.selection4 == option ? Color.soothingNightLightGray.opacity(0.5) : Color.nightfallHarmonyRoyalPurple.opacity(0.6))
                                .cornerRadius(10)
                        }
                    }
                    Text(questionnaire[4]).font(.system(size: 20, weight: .heavy)).foregroundColor(.nightfallHarmonyNavyBlue).padding()
                    HStack {
                        ForEach(yesNoOption, id: \.self) { option in
                            Button(action: {
                                self.selection5 = option == self.selection5 ? "No" : option
                            }) {
                                Text(option)
                                    .padding().frame(width: 150, height: 30).foregroundColor(.white)
                            }.background(self.selection5 == option ? Color.soothingNightLightGray.opacity(0.5) : Color.nightfallHarmonyRoyalPurple.opacity(0.6))
                                .cornerRadius(10)
                        }
                    }
                    Text(questionnaire[5]).font(.system(size: 20, weight: .heavy)).foregroundColor(.nightfallHarmonyNavyBlue).padding()
                    HStack {
                        ForEach(yesNoOption, id: \.self) { option in
                            Button(action: {
                                self.selection6 = option == self.selection6 ? "No" : option
                            }) {
                                Text(option)
                                    .padding().frame(width: 150, height: 30).foregroundColor(.white)
                            }.background(self.selection6 == option ? Color.soothingNightLightGray.opacity(0.5) : Color.nightfallHarmonyRoyalPurple.opacity(0.6))
                                .cornerRadius(10)
                        }
                    }
                    /*ForEach(questionnaire, id: \.self) { question in
                        Text(question).font(.system(size: 20, weight: .heavy)).foregroundColor(.nightfallHarmonyNavyBlue).padding()
                        LazyVGrid(columns: gridLayout, spacing: 20) {
                            ForEach(yesNoOption, id: \.self) { option in
                                Button(action: {
                                    self.selectedOption = option == self.selectedOption ? "No" : option
                                }) {
                                    Text(option)
                                        .padding().frame(width: 150, height: 30).foregroundColor(.white)
                                }
                                
                                .background(self.selectedOption == option ? Color.soothingNightLightGray.opacity(0.5) : Color.nightfallHarmonyRoyalPurple.opacity(0.6))
                                .cornerRadius(10)
                            }
                        }
                    }
                     */
                    Spacer()
                    Button(action:{
                        updateUserValues()
                        showSignUp5 = true
                    }){
                        Text("Next").font(.system(size: 20)).fontWeight(.medium).frame(width: 320, height: 50).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(10)
                    }
                    NavigationLink ("", destination: SignUp5View().navigationBarBackButtonHidden(true), isActive: $showSignUp5)
                }
            }
        }
    }
    func updateUserValues() {
        
        /* Update user values asynchronously */
        if let currUser = currUser {
            currUser.hadInsomnia = selection1 == "No" ? false : true
            currUser.hasInsomnia = selection2 == "No" ? false : true
            currUser.exercisesRegularly = selection3 == "No" ? false : true
            currUser.hasMedication =  selection4 == "No" ? false : true
            currUser.doesSnore = selection5 == "No" ? false: true
            currUser.hasNightmares = selection6 == "No" ? false: true
            currUser.updateValues(newValues: ["hadInsomnia"        : currUser.hadInsomnia,
                                              "hasInsomnia"        : currUser.hasInsomnia,
                                              "exercisesRegularly" : currUser.exercisesRegularly,
                                              "hasMedication"      : currUser.hasMedication,
                                              "doesSnore"          : currUser.doesSnore,
                                              "hasNightmares"      : currUser.hasNightmares
                                             ])
        } else {
            print("ERROR! No account found (preview mode?)")
        }

    }
}

//Sleep times
struct SignUp5View: View{
    private let gridLayout = [GridItem(.adaptive(minimum: 130))]
    private let yesNoOption: [String] = ["Yes", "No"]
    private let wakeupOptions: [String] = ["5am or earlier", "6am-8am", "8am-10am", "10am-12pm", "12pm-2pm", "2pm or later"]
    private let sleepOptions: [String] = ["5pm or earlier", "6pm-8pm", "8pm-10pm", "10pm-12am", "12am-2am", "2am or later"]
    
    @State private var wakeupSelection = "5am or earlier"
    @State private var sleepSelection = "5pm or earlier"
    
    @State private var showHomePage: Bool = false
    
    
    var body: some View {
        NavigationView {
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [.nightfallHarmonySilverGray.opacity(0.9), .nightfallHarmonyRoyalPurple.opacity(0.5), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    Text("When do you wake typically wake up?")
                        .font(.system(size: 30, weight: .heavy)).foregroundColor(.nightfallHarmonyNavyBlue).padding()
                    LazyVGrid(columns: gridLayout, spacing: 20) {
                        ForEach(wakeupOptions, id: \.self) { option in
                            Button(action: {
                                self.wakeupSelection = option == self.wakeupSelection ? "5am or earlier" : option
                            }) {
                                Text(option)
                                    .padding().frame(width: 150, height: 50).foregroundColor(.white)
                            }
                            
                            .background(self.wakeupSelection == option ? Color.soothingNightLightGray.opacity(0.5) : Color.nightfallHarmonyRoyalPurple.opacity(0.8))
                            .cornerRadius(10)
                        }
                    }
                    Spacer()
                    Text("When do you go to sleep?")
                        .font(.system(size: 30, weight: .heavy)).foregroundColor(.nightfallHarmonyNavyBlue).padding().multilineTextAlignment(.center)
                    LazyVGrid(columns: gridLayout, spacing: 20) {
                        ForEach(sleepOptions, id: \.self) { option in
                            Button(action: {
                                self.sleepSelection = option == self.sleepSelection ? "5am or earlier" : option
                            }) {
                                Text(option)
                                    .padding().frame(width: 150, height: 50).foregroundColor(.white)
                            }
                            
                            .background(self.sleepSelection == option ? Color.soothingNightLightGray.opacity(0.5) : Color.dreamyTwilightMidnightBlue.opacity(0.8))
                            .cornerRadius(10)
                        }
                    }
                    Spacer()
                    //TODO: change destination to Serenova homepage
                    Button(action:{
                        updateUserValues()
                        showHomePage = true
                    }){
                        Text("Next").font(.system(size: 20)).fontWeight(.medium).frame(width: 320, height: 50).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(10)
                    }
                    NavigationLink ("", destination: SleepGoalsView().navigationBarBackButtonHidden(true), isActive: $showHomePage)
                }
            }
        }
    }
    
    func updateUserValues() {
        
        /* Update user values asynchronously */
        if let currUser = currUser {
            currUser.typicalWakeUpTime = wakeupSelection
            currUser.typicalBedTime = sleepSelection
            
            currUser.updateValues(newValues: ["typicalWakeUpTime" : currUser.typicalWakeUpTime,
                                              "typicalBedTime"  : currUser.typicalBedTime
                                             ])
        }  else {
            print("ERROR! No account found (preview mode?)")
        }
        
    }
}


#Preview {
    SignUp2View()
}
