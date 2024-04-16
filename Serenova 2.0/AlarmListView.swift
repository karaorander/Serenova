//
//  AlarmListView.swift
//  Serenova 2.0
//
//  Created by Ishwarya Samavedhi on 2/27/24.
//

import SwiftUI

class Alarm: Identifiable, ObservableObject {
    let id = UUID()
    @Published var time: Date
    @Published var sound: String

    init(seconds: Int, sound: String) {
        let referenceDate = Calendar.current.startOfDay(for: Date())
        self.time = referenceDate.addingTimeInterval(TimeInterval(seconds))
        self.sound = sound
    }
}

struct EditAlarmView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var alarm: Alarm // Changed to @ObservedObject
    let sounds = ["Default", "Beep", "Ring", "Digital"]

    var body: some View {
        NavigationView {
            Form {
                DatePicker("Select Time", selection: $alarm.time, displayedComponents: .hourAndMinute)
                    .datePickerStyle(GraphicalDatePickerStyle())

                Picker("Select Sound", selection: $alarm.sound) {
                    ForEach(sounds, id: \.self) {
                        Text($0)
                    }
                }
            }
            .navigationTitle("Edit Alarm")
            .navigationBarItems(trailing: Button("Done") {
                self.presentationMode.wrappedValue.dismiss()
            })
        }
    }
}


struct ListOfAlarmsView: View {
    /*@State private var alarms = [
        Alarm(seconds: 5403, sound: "Default"),
        Alarm(seconds: 3600, sound: "Beep")
        //Alarm(time: Date().addingTimeInterval(0), sound: "Ring")
    ]*/
    @State private var alarms: [Alarm] = []
    @State private var isShowingEditView: Bool = false
    @State private var selectedAlarmIndex: Int?


    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.nightfallHarmonyRoyalPurple.opacity(0.8), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                                    .ignoresSafeArea()
                VStack(spacing: 20) {
                    
                    Text("Alarms")
                                            .font(.custom("NovaSquare-Bold", size: 50)) // Customize the font here
                                            .foregroundColor(.white)
                                            .padding(.bottom, 20)
                    List {
                        if let user = currUser {
                            ForEach(user.alarms.indices, id: \.self) { index in
                                if index < alarms.count { // Check if index is within bounds of alarms array
                                    HStack {
                                        AlarmRow(alarm: $alarms[index])
                                            .onTapGesture {
                                                self.selectedAlarmIndex = index
                                                self.isShowingEditView = true
                                            }
                                    }
                                    .padding()
                                    .background(Color.nightfallHarmonyRoyalPurple)
                                    .cornerRadius(10)
                                    .listRowBackground(Color.clear)
                                }
                            }
                            .onDelete(perform: delete)
                        }
                    }
                    .toolbar {
                        EditButton()
                    }
                    .sheet(isPresented: $isShowingEditView) {
                        if let index = selectedAlarmIndex {
                            EditAlarmView(alarm: alarms[index])
                        }
                    }
                    
                }
                .background(LinearGradient(gradient: Gradient(colors: [.nightfallHarmonyRoyalPurple.opacity(0.8), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom))
                .listStyle(PlainListStyle())
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            if let user = currUser {
                print("hey.. \(user.alarms[0])")
                
                for (index, _) in user.sounds.enumerated() {
                    if index < user.alarms.count && index < user.sounds.count {
                        let alarm = Alarm(seconds: user.alarms[index], sound: user.sounds[index])
                        alarms.append(alarm)
                    }
                }
            }
        }
    }
    
    
    func delete(at offsets: IndexSet) {
        alarms.remove(atOffsets: offsets)
    }
}


struct AlarmRow: View {
    @Binding var alarm: Alarm
    var body: some View {
        HStack {
            Text(alarm.time, style: .time)
                .font(.custom("NovaSquare-Bold", size: 18))
                .foregroundColor(.white)

            Spacer()

            Text(alarm.sound)
                .font(.custom("NovaSquare-Bold", size: 18))
                .foregroundColor(.white)
            
        }
        .padding()
        .background(Color.nightfallHarmonyRoyalPurple)
        .cornerRadius(10)
    }
}


struct ListOfAlarmsView_Previews: PreviewProvider {
    static var previews: some View {
        ListOfAlarmsView()
    }
}
