import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import UserNotifications



struct AlarmClockView: View {
    let sleepManager = SleepManager()


    @State public var alarmTime: Date = Date()
    @State public var selectedSound: String = "Default"
    @State public var isRepeating: Bool = false // State to handle the repeating toggle
    @State private var showAlert = false
    @State private var isClicked = false
    var colors = [Color.tranquilMistAccentTurquoise.opacity(0.6), Color.dreamyTwilightMidnightBlue]
    let sounds = ["Default", "Beep", "Ring", "Digital"]

    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(destination: ListOfAlarmsView().navigationBarBackButtonHidden(true), isActive: $isClicked) { EmptyView() } // Add this line
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
                    
                    HStack {
                        // Set Alarm button
                        Button(action: {
                            // Perform actions here when the button is tapped
                            if let user = currUser {
                                showAlert = true
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
                                user.addSound(selectedSound)
                                print("alarm: \(alarmTimeInterval)")
                                print("sound: \(selectedSound)")
                                let alarm2 = Alarm(seconds: alarmTimeInterval, sound: "Alarm Sound")
                                // scheduleNotification(for: alarm2)
                                scheduleAlarmNotification(alarmTimeInterval, selectedSound)
                                //user.addAlarm(selectedSound)
                                let alarmNoti = db.collection("FriendRequests").document(currentUserID).collection("notifications")
                                // Add friend to Firestore "Friends" collection
                                //if let username = currUser?.username {
                                let timeString = secondsToTimeString(alarmTimeInterval)
                                alarmNoti.document().setData([
                                    "message": "Alarm Set at \(timeString) !",
                                    "type": "alarm"
                                ], merge: true) { error in
                                    if let error = error {
                                        print("Error adding notification: \(error)")
                                    } else {
                                        print("Notification added successfully to Firestore2: \(currentUserID)")
                                    }
                                }
                            }
                        }) {
                            Text("Set Alarm")
                                .font(.custom("NovaSquare-Bold", size: 20))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.nightfallHarmonyRoyalPurple) // Purple background
                                .cornerRadius(20)
                                .padding()
                        }
                        Button("View Alarms") {
                            isClicked = true
                        }
                        .font(.custom("NovaSquare-Bold", size: 20))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.nightfallHarmonyRoyalPurple)
                        .cornerRadius(20)
                        .padding()

                    }
                    Spacer()
                }
                .background(LinearGradient(gradient: Gradient(colors: [ .nightfallHarmonyRoyalPurple.opacity(0.8), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom))
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Alarm Set"), message: Text("Your alarm has been successfully set!"), dismissButton: .default(Text("OK")))
                }
                .overlay(alignment: .bottom, content: {
                    
                   MenuView()
                    
                })
                .ignoresSafeArea()
            }
        }
        
    }
    
    func setAlarmTime(_ time: Date) {
        alarmTime = time
    }
    
    func scheduleAlarmNotification(_ time: Int, _ sound: String) {
        let calendar = Calendar.current
        let alarmTimeComponents = calendar.dateComponents([.hour, .minute], from: alarmTime)
        let currentDateTime = Date()
        let currentDateTimeComponents = calendar.dateComponents([.hour, .minute], from: currentDateTime)
        
        // Check if the alarm time is in the future
        if let alarmHour = alarmTimeComponents.hour,
           let alarmMinute = alarmTimeComponents.minute,
           let currentHour = currentDateTimeComponents.hour,
           let currentMinute = currentDateTimeComponents.minute {
            if alarmHour > currentHour || (alarmHour == currentHour && alarmMinute > currentMinute) {
                // Calculate the time interval until the alarm time
                let timeInterval = (alarmHour - currentHour) * 3600 + (alarmMinute - currentMinute) * 60
                // Schedule the notification
                print("time int \(timeInterval)")
                DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(timeInterval)) {
                    sendAlarmNotification(time, sound)
                }
                showAlert = true
            } else {
                showAlert = false
                print("Alarm time should be in the future.")
            }
        }
    }
    
    func sendAlarmNotification(_ time: Int, _ sound: String) {
        let timeString = secondsToTimeString(time)
        let db = Firestore.firestore()
        let currentUserID = Auth.auth().currentUser!.uid
        db.collection("FriendRequests").document(currentUserID).collection("notifications").document().setData([
            "message": "The \(timeString) Alarm is Done ! **\(sound) noises!!**",
            "type": "alarm"
        ]) { error in
            if let error = error {
                print("Error adding notification: \(error)")
            } else {
                print("real alarm noti sent!: \(currentUserID)")
            }
        }
    }
    
    func secondsToTimeString(_ seconds: Int) -> String {
        let hour = seconds / 3600
        let minute = (seconds % 3600) / 60
        let suffix = hour >= 12 ? "pm" : "am"
        let formattedHour = hour % 12 == 0 ? 12 : hour % 12
        return String(format: "%02d:%02d %@", formattedHour, minute, suffix)
    }
    
}

struct AlarmClockView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmClockView()
    }
}
