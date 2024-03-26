//
//  SleepLogView.swift
//  Serenova 2.0
//
//  Created by Ava Schrandt on 2/22/24.
//

import SwiftUI
import UIKit
import HealthKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseDatabaseSwift
import FirebaseStorage

//TODO: set up HK with firebase, get data from firebase instead of HKstore
class sleepLogModel {
    
}
class sleepLoggerModel: ObservableObject {
    @Published var fullname = ""
    @Published var totalSleepGoalHours : Float = -1
    @Published var totalSleepGoalMins : Float = -1
    @Published var deepSleepGoalHours : Float = -1
    @Published var deepSleepGoalMins : Float = -1
    @Published var sleepGoalReached = false

    
    func fetchUsername() {
        let db = Database.database().reference()
        let id = Auth.auth().currentUser!.uid
        let ur = db.child("User").child(id)
        ur.observeSingleEvent(of: .value) { snapshot in
            guard let userData = snapshot.value as? [String: Any] else {
                print("Error fetching data")
                return
            }
            
            // Extract additional information based on your data structure
            if let fullname = userData["name"] as? String {
                self.fullname = fullname
            }
            
            if let totalSleepGoalHours = userData["totalSleepGoalHours"] as? Float {
                self.totalSleepGoalHours = totalSleepGoalHours
            }
            
            if let sleepGoalReached = userData["sleepGoalReached"] as? Bool {
                self.sleepGoalReached = sleepGoalReached
            }
            
            if let totalSleepGoalMins = userData["totalSleepGoalMins"] as? Float {
                self.totalSleepGoalMins = totalSleepGoalMins
            }
            
            if let deepSleepGoalHours = userData["deepSleepGoalHours"] as? Float {
                self.deepSleepGoalHours = deepSleepGoalHours
            }
            
            if let deepSleepGoalMins = userData["deepSleepGoalMins"] as? Float {
                self.deepSleepGoalMins = deepSleepGoalMins
            }
            
        }
    }
}



struct SleepLogView: View {
    let sleepManager = SleepManager()
    @State private var samples: [HKCategorySample] = []
    //user data
    //TODO: add sleep attribute for date in Date extension for sleep object
    @State private var currentHrs : Int = 0
    @State private var currentMin : Int = 0

    //data variables
    @State private var sessionOn: Bool = false
    @State private var currentDate: Date = .init()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    @State private var createWeek: Bool = false
    
    @State private var manualLog: Bool = false
    @Namespace private var animation
    @State var selected = 0
    
   
    
    var colors = [Color.tranquilMistAccentTurquoise.opacity(0.6), Color.dreamyTwilightMidnightBlue]
    var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    var body: some View {
        
        NavigationView {
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [ .nightfallHarmonyRoyalPurple.opacity(0.8), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack (spacing: 20){
                   
                    VStack(alignment: .leading, spacing: 0, content: {
                        HeaderView()
                    }).vSpacing(.top)
                            
                    Text("Sleep Log")
                                .font(Font.custom("NovaSquare-Bold", size: 50))
                                .foregroundColor(.white.opacity(0.7))
                                
                            
                    Spacer()
                    VStack {
                        
                        Text("\(currentHrs) Hrs \(currentMin) Min")
                            .font(.system(size: 50, weight:.bold))
                            .foregroundColor(.tranquilMistMauve.opacity(0.7))

                        
                      /*  if (currentHrs > Int(viewModel.totalSleepGoalHours)) {
                            if let user = currUser {
                                //print("updating")
                               //user.updateMoons(rewardCount: 20)
                           }
                        }
                        else if (currentHrs == Int(viewModel.totalSleepGoalHours) && currentMin > Int(viewModel.totalSleepGoalMins)) {
                            if let user = currUser {
                                //print("updating")
                               user.updateMoons(rewardCount: 20)
                           }
                        }*/
                        
                        Spacer()
                        
                        NavigationLink(destination: SleepGraphView().navigationBarBackButtonHidden(true)) {
                            HStack {
                                Text("View Sleep Analysis").font(.system(size: 20, weight:.medium))
                                    .foregroundColor(.white)
                                Image(systemName: "arrow.right").foregroundColor(.white)
                                    .font(.system(size: 20,weight: .medium))
                            }.padding().background(Color.soothingNightLightGray.opacity(0.8)).cornerRadius(20)
                        
                        }
                    }.padding()
                    
                   
                    Button(action: {
                            manualLog.toggle()
                    }, label: {
                            Image(systemName: "plus")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.dreamyTwilightAccentViolet)
                            .frame(width: 55, height: 55)
                            .background(.white.shadow(.drop(color: .black.opacity(0.25), radius: 5, x: 10, y: 10)), in: .circle)
                                    })
                                    .padding(15)
                                
                                .onAppear(perform: {
                                    if weekSlider.isEmpty {
                                        let currentWeek = Date().fetchWeek()
                                        
                                        if let firstDate = currentWeek.first?.date {
                                            weekSlider.append(firstDate.createPreviousWeek())
                                        }
                                        
                                        weekSlider.append(currentWeek)
                                        
                                        if let lastDate = currentWeek.last?.date {
                                            weekSlider.append(lastDate.createNextWeek())
                                        }
                                    }
                                })
                                .sheet(isPresented: $manualLog, content: {
                                    ManualLogView()
                                        .presentationDetents([.height(300)])
                                        .interactiveDismissDisabled()
                                        .presentationCornerRadius(30)
                                        
                                })
                        
                    
                    HStack (spacing: 40){
                        NavigationLink(destination: SleepGraphView().navigationBarBackButtonHidden(true)) {
                            
                            Image(systemName: "chart.xyaxis.line")
                                .resizable()
                                .frame(width: 30, height: 35)
                                .foregroundColor(.white)
                            
                        }
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
                }
                // querey data
                .onAppear() {
                    sleepManager.querySleepData(completion: { totalSleepTime, deepSleepTime, coreSleepTime, remSleepTime in
                                        // Update UI with sleep data
                                        // For example:
                        currentHrs = Int(totalSleepTime ?? 0) / 3600
                        currentMin = (Int(totalSleepTime ?? 0) % 3600) / 60
                                    }, date: currentDate)
                }
            }
        }
        
        
            
        }
   
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(alignment: .leading, spacing: 15) {
            
            Text(currentDate.formatted(date: .complete, time: .omitted))
                .font(.callout)
                .fontWeight(.semibold)
                .textScale(.secondary)
                .foregroundStyle(.gray)
            
            /// Week Slider
            TabView(selection: $currentWeekIndex) {
                ForEach(weekSlider.indices, id: \.self) { index in
                    let week = weekSlider[index]
                    WeekView(week)
                        .padding(.horizontal, 15)
                        .tag(index)
                }
            }
            .padding(.horizontal, -15)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 90)
        }
        .hSpacing(.leading)
        .overlay(alignment: .topTrailing, content: {
            
                NavigationLink(destination: AccountInfoView().navigationBarBackButtonHidden(true)) {

                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 45, height: 45)
                        .clipShape(.circle)
                        .foregroundColor(.white)
                        .position(x: 320, y: 0)
                        
                   
                
                }.padding(.bottom)
            
        })
        .padding(15)
        .background(Color.dreamyTwilightMidnightBlue)
        .onChange(of: currentWeekIndex, initial: false) { oldValue, newValue in
            //Creating When it reaches first/last Page
            if newValue == 0 || newValue == (weekSlider.count - 1) {
                createWeek = true
            }
        }
    }
    @ViewBuilder
    func WeekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing: 0) {
            ForEach(week) { day in
                VStack(spacing: 8) {
                    Text(day.date.format("E"))
                        .font(.system(size: 20, weight: .medium))
                        .textScale(.secondary)
                        .foregroundStyle(.gray)
                    
                    Text(day.date.format("dd"))
                        .font(.callout)
                        .fontWeight(.bold)
                        .textScale(.secondary)
                        .foregroundStyle(isSameDate(day.date, currentDate) ? .white : .gray)
                        .frame(width: 35, height: 35)
                        .background(content: {
                            if isSameDate(day.date, currentDate) {
                                Circle()
                                    .fill(Color.dreamyTwilightAccentViolet)
                                    .matchedGeometryEffect(id: "TABINDICATOR", in: animation)
                            }
                            
                            //Today's date
                            if day.date.isToday {
                                Circle()
                                    .fill(.cyan)
                                    .frame(width: 5, height: 5)
                                    .vSpacing(.bottom)
                                    .offset(y: 12)
                            }
                        })
                        .background(Color.dreamyTwilightMidnightBlue.shadow(.drop(radius: 1)), in: .circle)
                }
                .hSpacing(.center)
                .contentShape(.rect)
                .onTapGesture {
                    currentHrs = 0
                    currentMin = 0
                    // query sleep data
                    sleepManager.querySleepData(completion: { totalSleepTime, deepSleepTime, coreSleepTime, remSleepTime in
                        DispatchQueue.main.async {
                            currentHrs = Int(totalSleepTime ?? 0) / 3600
                            currentMin = (Int(totalSleepTime ?? 0) % 3600) / 60
                        }
                    }, date: day.date)
                    
                    withAnimation(.snappy) {
                        currentDate = day.date
                    }
                }
            }
        }
        .background {
            GeometryReader {
                let minX = $0.frame(in: .global).minX
                
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self) { value in
                        if value.rounded() == 15 && createWeek {
                            paginateWeek()
                            createWeek = false
                        }
                    }
            }
        }
    }
    
    func paginateWeek() {
        if weekSlider.indices.contains(currentWeekIndex) {
            if let firstDate = weekSlider[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                weekSlider.insert(firstDate.createPreviousWeek(), at: 0)
                weekSlider.removeLast()
                currentWeekIndex = 1
            }
            if let lastDate = weekSlider[currentWeekIndex].last?.date, currentWeekIndex == (weekSlider.count - 1) {
                // Appending New Week at Last Index and Removing First Array Item
                weekSlider.append(lastDate.createNextWeek())
                weekSlider.removeFirst()
                currentWeekIndex = weekSlider.count - 2
            }
        }
        print(weekSlider.count)
    }
    
}

struct ManualLogView: View {
    //user data
    //TODO: add sleep attribute for date in Date extension for sleep object
    @State private var sleepStart = Date()
    @State private var sleepEnd = Date()
    @State private var totalDuration: TimeInterval = 0
    @StateObject private var viewModel = sleepLoggerModel()
    
    @State private var currentDate = Date()
    
    @State private var showError:Bool = false
    @State private var showCamera:Bool = false
    @State private var errorMess: String = ""
    @State private var sleepStartHours = 0
    @State private var sleepStartMins = 0
    @State private var sleepEndHours = 0
    @State private var sleepEndMins = 0
    @State private var durationHours = 0
    @State private var durationMinutes = 0

    
    
    //dismiss currentenvironment
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Button(action: {
            dismiss()
        }, label: {
            Image(systemName: "x.square")
                .font(.title)
                .foregroundColor(.nightfallHarmonyNavyBlue)
        }).position(x:340, y:40)
        
        VStack (spacing: 20){
            Text("Log Sleep Time").font(.system(size: 30, weight:.medium))
                .foregroundColor(.tranquilMistMauve)
            
            HStack {
                Text("Sleep Start:").font(.system(size: 20, weight: .bold)).foregroundColor(.moonlitSerenityLilac)
                DatePicker("", selection: $sleepStart, in: Date().addingTimeInterval(-(10000*10000))...Date(), displayedComponents: [.date, .hourAndMinute])
                    .labelsHidden()
            }
            //end sleep only after set start time
            HStack {
                Text("Sleep Finish:").font(.system(size: 20, weight: .bold)).foregroundColor(.moonlitSerenityLilac)
                DatePicker("", selection: $sleepEnd, in: sleepStart...Date(), displayedComponents: [.date, .hourAndMinute])
                            .labelsHidden()
            }
            //TODO: send manual sleep log times to firebase
            Button(action: {
                
                let calendar = Calendar.current
                    
                    // Start of the day for the sleep start and end dates
                    let startOfSleepStartDay = calendar.startOfDay(for: sleepStart)
                    let startOfSleepEndDay = calendar.startOfDay(for: sleepEnd)
                    
                    // If sleep session spans multiple days
                    if startOfSleepStartDay != startOfSleepEndDay {
                        // Calculate the duration for the first day
                        totalDuration = calendar.date(byAdding: .day, value: 1, to: startOfSleepStartDay)?.timeIntervalSince(sleepStart) ?? 0
                      
                        creatManualSession(sleepStart: sleepStart, sleepEnd: calendar.date(byAdding: .day, value: 1, to: startOfSleepStartDay) ?? sleepEnd, date: startOfSleepStartDay, duration: totalDuration)
                        print("Duration first day: \(totalDuration)")
                        // Calculate the duration for the last day
                        totalDuration = sleepEnd.timeIntervalSince(startOfSleepEndDay)
                        
                        print("Duration last day: \(totalDuration)")
                        creatManualSession(sleepStart: startOfSleepEndDay,  sleepEnd: sleepEnd, date: startOfSleepEndDay, duration: totalDuration)
                        
                    } else {
                        // Sleep session is within a single day
                        totalDuration = sleepEnd.timeIntervalSince(sleepStart)
                        
                        print("Total duration: \(totalDuration)")
                        creatManualSession(sleepStart: sleepStart, sleepEnd: sleepEnd, date: startOfSleepStartDay, duration: totalDuration)
    
                    }
                
                let components = calendar.dateComponents([.hour, .minute], from: sleepStart)
                let sleepStartHours = components.hour ?? 0
                let sleepStartMins = components.minute ?? 0
                let endComponents = calendar.dateComponents([.hour, .minute], from: sleepEnd)
                let sleepEndHours = endComponents.hour ?? 0
                let sleepEndMins = endComponents.minute ?? 0
                let totalDurationInSeconds = sleepEnd.timeIntervalSince(sleepStart)
                let durationHours = Int(totalDurationInSeconds) / 3600
                let durationMinutes = (Int(totalDurationInSeconds) % 3600) / 60
                print("dur: \(durationHours)")
                print("min: \(durationMinutes)")
                print("dur2: \(viewModel.totalSleepGoalHours)")
                print("min2: \(viewModel.totalSleepGoalMins)")
                if (abs(durationHours - Int(viewModel.totalSleepGoalHours)) < 5) {
                    if let user = currUser {
                        print("helllooo")
                        user.updateMoons(rewardCount: 20)
                        user.sleepGoalReached = true
                    }
                    else {
                        print("error2")
                    }
                }
                else {
                    print("hello.")
                }
                dismiss()
            }
                   , label: {
                    Text("Log Sleep!")
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.dreamyTwilightAccentViolet)
                    .frame(width: 150, height: 60)
                    .background(Color.nightfallHarmonySilverGray.opacity(0.3), in: .rect).cornerRadius(10)
                            })
                            .padding(15)
                                
            
        }.padding()
            .onAppear {
                viewModel.fetchUsername()
            }
    }
    func errorAlerts(_ error: Error)async{
        await MainActor.run(body: {
            errorMess = error.localizedDescription
            showError.toggle()
        })
    }
    
    //error handling -> error alerts (String version)
    func errorAlerts(_ error: String)async{
        await MainActor.run(body: {
            errorMess = error
            showError.toggle()
        })
    }
    
    func creatManualSession(sleepStart:Date, sleepEnd:Date, date:Date, duration:TimeInterval) {
        
        Task {
            do {
                guard currUser != nil else {
                    await errorAlerts("ERROR! Not signed in.")
                    return
                }
                print("in Task ", sleepStart, sleepEnd)
                
                if let user = currUser {
                    print("hereeeeee")
                   user.updateMoons(rewardCount: 1)
               }
               
                // new session object
                var newSession = SleepSession(sleepStart: sleepStart, sleepEnd:sleepEnd, date: date , manualInterval: duration)
                
                // Store sleep session
                try await newSession.addSleepSession()
                
            } catch {
                await errorAlerts(error)
            }
        }
    }
    
    
}




struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    SleepLogView()
}
