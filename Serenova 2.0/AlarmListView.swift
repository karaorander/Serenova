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

class AlarmListViewModel: ObservableObject {
    @Published var alarms: [Alarm] = []
    @Published var isShowingEditView = false
    var selectedAlarmIndex: Int?
    
    var selectedAlarm: Alarm?

    func populateAlarms() {
        print("sup")
        if let user = currUser {
            var alarmArray: [Alarm] = []
            print("enum: \(user.sounds.enumerated())")
            //print("is elemnt: \(user.sounds[0])")
            for (index, _) in user.sounds.enumerated() {
                print("NOT HERE!")
                if index < user.alarms.count && index < user.sounds.count {
                    let alarm = Alarm(seconds: user.alarms[index], sound: user.sounds[index])
                    print("acc appending")
                    alarmArray.append(alarm)
                }
            }
            print("yeahhh")
            alarms = alarmArray
        }
    }

    func delete(at offsets: IndexSet) {
        if let user = currUser {
            user.alarms.remove(atOffsets: offsets)
            populateAlarms() // Update the alarms array after deletion
        }
    }
    
    func edit(alarm: Alarm) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index] = alarm
        }
    }
}




struct ListOfAlarmsView: View {
    @StateObject private var viewModel = AlarmListViewModel()
    var body: some View {
        NavigationView {
            ZStack {
                // Your background gradient and other UI elements
                
                VStack(spacing: 20) {
                    // Your UI components, including the list of alarms
                    Text("Alarms")
                        .font(.custom("NovaSquare-Bold", size: 50))
                        .foregroundColor(.white)
                        .padding(.bottom, 20)

                    List {
                        ForEach(viewModel.alarms) { alarm in
                            HStack {
                                AlarmRow(alarm: alarm)
                                    .onTapGesture {
                                        viewModel.selectedAlarm = alarm
                                        viewModel.selectedAlarmIndex = viewModel.alarms.firstIndex(where: { $0.id == alarm.id })
                                        viewModel.isShowingEditView = true
                                    }
                            }
                            .padding()
                            .background(Color.nightfallHarmonyRoyalPurple)
                            .cornerRadius(10)
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: viewModel.delete)
                        .id(UUID())
                    }
                }
                .background(LinearGradient(gradient: Gradient(colors: [.nightfallHarmonyRoyalPurple.opacity(0.8), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom))
                .listStyle(PlainListStyle())
                .sheet(isPresented: $viewModel.isShowingEditView) {
                    if let index = viewModel.selectedAlarmIndex {
                        EditAlarmView(viewModel: viewModel, alarm: viewModel.alarms[index])
                    }
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            print("populating")
            viewModel.populateAlarms()
        }
    }
    func saveEditedAlarm(_ editedAlarm: Alarm) {
        viewModel.edit(alarm: editedAlarm)
    }
}



/*struct AlarmRow: View {
    var alarm: Alarm
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
}*/

struct EditAlarmView: View {
    @ObservedObject var viewModel: AlarmListViewModel
    @State private var editedAlarm: Alarm
    @Environment(\.presentationMode) var presentationMode

    init(viewModel: AlarmListViewModel, alarm: Alarm) {
        self.viewModel = viewModel
        self._editedAlarm = State(initialValue: alarm)
    }

    var body: some View {
        VStack {
            DatePicker("Time", selection: $editedAlarm.time, displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()

            // Add any additional fields for editing alarm details, such as sound selection

            Button("Save") {
                viewModel.edit(alarm: editedAlarm) // Update the alarm in the view model
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
        }
        .padding()
        .navigationBarTitle("Edit Alarm")
    }
}

struct AlarmRow: View {
    @ObservedObject var alarm: Alarm // Use @ObservedObject

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
