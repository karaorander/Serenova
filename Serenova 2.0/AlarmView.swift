import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage


struct AlarmClockView: View {
    let sleepManager = SleepManager()


    @State public var alarmTime: Date = Date()
    @State public var selectedSound: String = "Default"
    @State public var isRepeating: Bool = false // State to handle the repeating toggle
    @State private var isClicked = false
    var colors = [Color.tranquilMistAccentTurquoise.opacity(0.6), Color.dreamyTwilightMidnightBlue]
    let sounds = ["Default", "Beep", "Ring", "Digital"]

    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(destination: ListOfAlarmsView(), isActive: $isClicked) { EmptyView() } // Add this line
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
                        print("alarm time \(alarmTime)")
                        if let user = currUser {
                            print("hi7iii")
                            let db = Firestore.firestore()
                            let currentUserID = Auth.auth().currentUser!.uid
                            
                            let calendar = Calendar.current

                            // Get the hour, minute, and second components from the selected alarm time
                            let hour = calendar.component(.hour, from: alarmTime)
                            let minute = calendar.component(.minute, from: alarmTime)
                            let second = calendar.component(.second, from: alarmTime)

                            // Calculate the time interval between the alarm time and midnight
                            let alarmTimeInterval = (hour * 3600) + (minute * 60) + second

                            // Add the alarm time to the user's alarm array
                            user.addAlarm(alarmTimeInterval)
                            user.addSound(self.selectedSound)
                            print("alarm: \(alarmTimeInterval)")
                            print("sound: \(self.selectedSound)")
                            //user.addAlarm(selectedSound)
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
                        //isClicked = true
                    }
                    .font(.custom("NovaSquare-Bold", size: 20))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.nightfallHarmonyRoyalPurple) // Purple background
                    .cornerRadius(20)
                    .padding()
                    Spacer()
                }
                .background(LinearGradient(gradient: Gradient(colors: [ .nightfallHarmonyRoyalPurple.opacity(0.8), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom))
                .ignoresSafeArea()
            }
        }
        
    }
    
    func setAlarmTime(_ time: Date) {
        alarmTime = time
    }
}

struct AlarmClockView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmClockView()
    }
}
