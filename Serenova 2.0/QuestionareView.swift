//
//  QuestionareView.swift
//  Serenova 2.0
//
//  Created by Ishwarya Samavedhi on 2/19/24.
//

// View for selecting the amount of sleep needed
/*
import SwiftUI

struct UserQuestionnaire {
    var sleepAmount: String = ""
    var gender: String = "Male"
    var height: Double = 180
    var weight: Double = 85
    var age: Int = 21
    var sufferedFromInsomnia: Bool = false
    var currentlySufferInsomnia: Bool = false
    var oversleepRegularly: Bool = false
    var usedSleepAids: Bool = false
    var snoreRegularly: Bool = false
    var sufferNightmares: Bool = false
    var wakeUpTime: String = ""
    var sleepTime: String = ""
}

struct QuestionSectionView: View {
    var title: String
    @Binding var selection: String
    var options: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            HStack {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        selection = option
                    }) {
                        Text(option)
                            .foregroundColor(selection == option ? .white : .black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selection == option ? Color.blue : Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
            }
        }
        .padding()
    }
}

// View for entering personal details like gender, height, weight, age
struct PersonalDetailsView: View {
    @Binding var questionnaire: UserQuestionnaire
    @State private var localHeight: Double
    @State private var localWeight: Double
    @State private var localAge: Double
    
    init(questionnaire: Binding<UserQuestionnaire>) {
           self._questionnaire = questionnaire
           // Initialize local state with the bound values
           _localHeight = State(initialValue: questionnaire.height.wrappedValue)
           _localWeight = State(initialValue: questionnaire.weight.wrappedValue)
           _localAge = State(initialValue: Double(questionnaire.age.wrappedValue))
       }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Some Personal Details")
                .font(.headline)
                .padding(.bottom, 5)
            
            HStack {
                Button(action: {
                    questionnaire.gender = "Male"
                }) {
                    Text("Male")
                        .foregroundColor(questionnaire.gender == "Male" ? .white : .black)
                        .padding()
                        .background(questionnaire.gender == "Male" ? Color.blue : Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
                
                Button(action: {
                    questionnaire.gender = "Female"
                }) {
                    Text("Female")
                        .foregroundColor(questionnaire.gender == "Female" ? .white : .black)
                        .padding()
                        .background(questionnaire.gender == "Female" ? Color.blue : Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
            }
            
            Slider(value: $localHeight, in: 100...250, step: 1) {
                Text("Height: \(Int(localHeight)) cm")
            }
            .onChange(of: localHeight) { newValue in
                questionnaire.height = newValue
            }

            // Weight slider
            Slider(value: $localWeight, in: 30...200, step: 1) {
                Text("Weight: \(Int(localWeight)) kg")
            }
            .onChange(of: localWeight) { newValue in
                questionnaire.weight = newValue
            }

            // Age slider
            Slider(value: $localAge, in: 18...100, step: 1) {
                Text("Age: \(Int(localAge)) years")
            }
            .onChange(of: localAge) { newValue in
                questionnaire.age = Int(newValue)
            }
        }
        .padding()
    }
}

// View for insomnia and sleep issues
struct InsomniaAndSleepView: View {
    @Binding var questionnaire: UserQuestionnaire

    var body: some View {
        VStack(alignment: .leading) {
            Text("Insomnia and Sleep Issues")
                .font(.headline)
                .padding(.bottom, 5)

            Toggle(isOn: $questionnaire.sufferedFromInsomnia) {
                Text("Have you ever suffered from insomnia?")
            }

            Toggle(isOn: $questionnaire.currentlySufferInsomnia) {
                Text("Do you suffer from insomnia currently?")
            }

            Toggle(isOn: $questionnaire.oversleepRegularly) {
                Text("Do you oversleep regularly?")
            }

            Toggle(isOn: $questionnaire.usedSleepAids) {
                Text("Do you use, or have used, any special methods to help you sleep?")
            }

            Toggle(isOn: $questionnaire.snoreRegularly) {
                Text("Do you snore regularly?")
            }

            Toggle(isOn: $questionnaire.sufferNightmares) {
                Text("Do you suffer from nightmares?")
            }
        }
        .padding()
    }
}

// View for selecting wake up and sleep times
struct SleepScheduleView: View {
    @Binding var questionnaire: UserQuestionnaire

    var body: some View {
        VStack(alignment: .leading) {
            Text("Sleep Schedule")
                .font(.headline)
                .padding(.bottom, 5)

            // Add other time options similarly as buttons
            Button(action: {
                questionnaire.wakeUpTime = "5am or earlier"
            }) {
                Text("5am or earlier")
                    .foregroundColor(questionnaire.wakeUpTime == "5am or earlier" ? .white : .black)
                    .padding()
                    .background(questionnaire.wakeUpTime == "5am or earlier" ? Color.blue : Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }

            Button(action: {
                questionnaire.sleepTime = "10pm–12am"
            }) {
                Text("10pm–12am")
                    .foregroundColor(questionnaire.sleepTime == "10pm–12am" ? .white : .black)
                    .padding()
                    .background(questionnaire.sleepTime == "10pm–12am" ? Color.blue : Color.gray.opacity(0.2))
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}
*/
