import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage


struct AlarmClockView: View {
    let sleepManager = SleepManager()

    @State private var alarmTime: Date = Date()
    @State private var selectedSound: String = "Default"
    @State private var isRepeating: Bool = false // State to handle the repeating toggle
    var colors = [Color.tranquilMistAccentTurquoise.opacity(0.6), Color.dreamyTwilightMidnightBlue]
    let sounds = ["Default", "Beep", "Ring", "Digital"]

    var body: some View {
        NavigationView {
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [ .nightfallHarmonyRoyalPurple.opacity(0.8), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack (){
        
                    Spacer()
                    Text("Set Alarm")
                        .font(.custom("NovaSquare-Bold", size: 50))
                        .foregroundColor(.white)
                        .padding()
                    
                    // Time Picker for the alarm time
                    DatePicker("Select Time", selection: $alarmTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                        .background(Color.nightfallHarmonyRoyalPurple.opacity(0.7)) // Semi-transparent purple background
                        .cornerRadius(15)
                        .padding()
                    
                    // Sound selection buttons
                    HStack {
                        ForEach(sounds, id: \.self) { sound in
                            Button(action: {
                                self.selectedSound = sound
                            }) {
                                Text(sound)
                                    .foregroundColor(self.selectedSound == sound ? .white : Color.soothingNightLightGray)
                                    .font(.custom("NovaSquare-Bold", size: 18))
                                    .padding()
                                    .background(self.selectedSound == sound ? Color.nightfallHarmonyRoyalPurple : Color.clear) // Purple for selected button
                                    .cornerRadius(15)
                            }
                        }
                    }
                    .padding()
                    
                    // Toggle for repeating alarm
                    Toggle(isOn: $isRepeating) {
                        Text("Repeat")
                            .foregroundColor(.white)
                            .font(.custom("NovaSquare-Bold", size: 18))
                    }
                    .padding()
                    .background(Color.nightfallHarmonyNavyBlue.opacity(0.4))
                    .cornerRadius(15)
                    .padding()
                    
                    // Set Alarm button
                    Button("Set Alarm") {
                        //sleepManager.alarmTime = alarmTime
                        //sleepManager.alarmSession()
                        if let user = currUser {
                            print("hi7iii")
                            let db = Firestore.firestore()
                            let currentUserID = Auth.auth().currentUser!.uid
                            user.addAlarm(selectedSound)
                            let alarmNoti = db.collection("FriendRequests").document(currentUserID).collection("notifications")
                            // Add friend to Firestore "Friends" collection
                            //if let username = currUser?.username {
                            alarmNoti.document().setData([
                                "message": "Alarm Set at _ time!"
                            ], merge: true) { error in
                                if let error = error {
                                    print("Error adding notification: \(error)")
                                } else {
                                    print("Notification added successfully to Firestore2: \(currentUserID)")
                                }
                            }
                        }
                    }
                    .font(.custom("NovaSquare-Bold", size: 20))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.nightfallHarmonyRoyalPurple) // Purple background
                    .cornerRadius(20)
                    .padding()
                    NavigationLink ("", destination: ListOfAlarmsView().navigationBarBackButtonHidden(true))
                    Spacer()
                }
                .background(LinearGradient(gradient: Gradient(colors: [ .nightfallHarmonyRoyalPurple.opacity(0.8), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom))
                .ignoresSafeArea()
            }
        }
        
    }
}

struct AlarmClockView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmClockView()
    }
}
