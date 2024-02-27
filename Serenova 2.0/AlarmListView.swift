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

    init(time: Date, sound: String) {
        self.time = time
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
    @State private var alarms = [
        Alarm(time: Date().addingTimeInterval(3600), sound: "Default"),
        Alarm(time: Date().addingTimeInterval(7200), sound: "Beep"),
        Alarm(time: Date().addingTimeInterval(10800), sound: "Ring")
    ]
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
                        ForEach(alarms.indices, id: \.self) { index in
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
                        .onDelete(perform: delete)
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
