//
//  JournalPostView.swift
//  Serenova 2.0
//
//  Created by Ava Schrandt on 3/21/24.
//


import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage

class SleepScoreModel: ObservableObject {
    @Published var fullname = ""
    @Published var totalSleepGoalHours : Float = -1
    @Published var totalSleepGoalMins : Float = -1
    @Published var deepSleepGoalHours : Float = -1
    @Published var deepSleepGoalMins : Float = -1
    @Published var moonCount : Int = -1

    
    func fetchUsername(completion: @escaping () -> Void) {
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
                //currUser?.totalSleepGoalHours = totalSleepGoalHours
                
            }
            print("TOTAL SLEEP GOAL RETRIEVED: \(self.totalSleepGoalHours)")
            if let totalSleepGoalMins = userData["totalSleepGoalMins"] as? Float {
                self.totalSleepGoalMins = totalSleepGoalMins
                //currUser?.totalSleepGoalMins = totalSleepGoalMins
            }
            
            if let deepSleepGoalHours = userData["deepSleepGoalHours"] as? Float {
                self.deepSleepGoalHours = deepSleepGoalHours
                //currUser?.deepSleepGoalHours = deepSleepGoalHours
            }
            print("TOTAL SLEEP GOAL RETRIEVED: \(self.deepSleepGoalHours)")
            
            
            if let deepSleepGoalMins = userData["deepSleepGoalMins"] as? Float {
                self.deepSleepGoalMins = deepSleepGoalMins
                //currUser?.deepSleepGoalMins = deepSleepGoalMins
            }
            
            if let moonCount = userData["moonCount"]
                as? Int {
                self.moonCount = moonCount
            }
            self.objectWillChange.send()
                            
                            // Call the completion closure to indicate that data fetching is completed
                            completion()
            
        }
    }
}


//Create New Post View
struct SleepScoreView: View {
    /// callback
    //var onPos: (Post)->()
    
    @State var viewModel = SleepScoreModel()
    ///use app storage to get user data from firebase.  EX:
    //@AppStorage("userName") var userName: String = ""
    @State private var isLoading:Bool = false
    @State private var showError:Bool = false
    @State private var errorMess: String = ""
    
    @FocusState private var showkeyboard: Bool
    @Environment(\.dismiss) private var dismiss
    
    @State private var totalSleepMin:Int = 0
    @State private var otherSleepMin:Int = 0
    @State private var deepSleepMin:Int = 0
    @State private var coreSleepMin:Int = 0
    @State private var remSleepMin:Int = 0
    
    @State private var deepSleepScore:Int = 0
    @State private var coreSleepScore:Int = 0
    @State private var remSleepScore:Int = 0
    @State private var otherSleepScore:Int = 0
    
    
    @State private var sleepScore:Int = 0
    
    
    var body: some View {
        NavigationView{
            ZStack {
                Color.dreamyTwilightMidnightBlue.opacity(0.7)
                    .ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false){
                    VStack (spacing: 10){
                        
                        HStack {
                            Button(action:{
                                dismiss()
                            }){
                                Image(systemName: "chevron.left").foregroundColor(.white)
                            }
                            Text("X's Sleep Score")
                                .font(Font.custom("NovaSquareSlim-Bold", size: 25))
                                .foregroundColor(.white)
                                .scaledToFit().minimumScaleFactor(0.01)
                                .lineLimit(1).hSpacing(.center)
                            
                            
                        }.padding()
                        
                        VStack {
                            HStack {
                                Image(systemName: "zzz").foregroundColor(.tranquilMistMauve).padding(.leading)
                                Text("Welcome to your daily sleep score! This score is based off of the quality of recorded sleep in the past day.")
                                    .font(Font.system(size: 12, weight: .bold))
                                    .foregroundColor(.tranquilMistMauve)
                                    .frame(width: 300, alignment: .center)
                                    .lineSpacing(4)
                                    .padding(.top)
                                    .padding(.trailing)
                            }
                            HStack {
                                Image(systemName: "star.fill").foregroundColor(.nightfallHarmonyNavyBlue).font(.system(size: 12)).padding(.leading)
                                Text("Log your sleep and check back here to see today's score and to learn more about last night's sleep cycle! 💫")
                                    .font(Font.system(size: 12, weight: .medium))
                                    .foregroundColor(.nightfallHarmonyNavyBlue)
                                    .frame(width: 300, alignment: .center)
                                    .lineSpacing(4)
                                    .padding(.vertical)
                                    .padding(.trailing)
                            }
                            
                        }.background(.white.opacity(0.06))
                            .cornerRadius(15)
                            .shadow(color: .white.opacity(0.1), radius: 10)
                        Spacer()
                        Text("Today's Score")
                            .font(Font.custom("NovaSquareSlim-Bold", size: 30))
                            .foregroundColor(.pink).opacity(0.5)
                            .scaledToFit().minimumScaleFactor(0.01)
                            .lineLimit(1)
                        Text("\(sleepScore)")
                            .font(.system(size: 75))
                            .foregroundColor(.white)
                            .scaledToFit().minimumScaleFactor(0.01)
                            .lineLimit(1)
                            .padding()
                            .frame(width: 200, height: 200).background(Color.tranquilMistAshGray.opacity(0.1)).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(100)
                        Spacer()
                        VStack {
                            Text("Deep sleep score:\(deepSleepScore)")
                            Text("Light sleep score: \(coreSleepScore)")
                            Text("REM sleep score:\(remSleepMin)")
                            Text("Other sleep: \(otherSleepScore)")
                        }
                        
                        
                        Spacer()
                        
                        VStack {
                            Text("Analyzing the stages:").foregroundColor(.dreamyTwilightMidnightBlue)
                                .font(.system(size: 20, weight: .bold))
                                .hSpacing(.leading)
                                .padding()
                            Text("\(totalSleepMin) minutes in total\n\(deepSleepMin) minutes spent in deep sleep\n\(coreSleepMin) minutes spent in light sleep\n\(remSleepMin) minutes spent in REM").foregroundColor(.white).font(.system(size: 20,weight:.medium))
                            Spacer()
                            
                        }.background(.white.opacity(0.06))
                            .cornerRadius(15)
                            .shadow(color: .white.opacity(0.1), radius: 10).padding()
                            
                        
                        
                        
                        
                    }
                }
            }

        }.onAppear() {
            sleepManager.querySleepData(completion: { totalSleepTime, deepSleepTime, coreSleepTime, remSleepTime in
                DispatchQueue.main.async {
                    totalSleepMin = (Int(totalSleepTime ?? 0)) / 60
                    deepSleepMin = (Int(deepSleepTime ?? 0)) / 60
                    coreSleepMin = (Int(coreSleepTime ?? 0)) / 60
                    remSleepMin = (Int(totalSleepTime ?? 0)) / 60
                    otherSleepMin = totalSleepMin-(deepSleepMin + coreSleepMin + remSleepMin)
                    if totalSleepMin == 0 {
                        sleepScore = 0
                    } else {
                        sleepScore = calculateSleepScore(deepSleepMinutes: deepSleepMin, otherSleepMinutes: otherSleepMin, coreSleepMinutes: coreSleepMin, remSleepMinutes: remSleepMin, totalSleepMinutes: totalSleepMin)
                    }
                }
            }, date: Date())
            
        }
    }
    //error handling -> error alerts
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
    
    func calculateSleepScore(deepSleepMinutes: Int, otherSleepMinutes: Int, coreSleepMinutes: Int, remSleepMinutes: Int, totalSleepMinutes: Int) -> Int {
        // Define weights for each sleep stage
        let deepSleepWeight = 0.4
        let lightSleepWeight = 0.3
        let coreSleepWeight = 0.2
        let remSleepWeight = 0.1

        // Normalize sleep minutes
        let totalMinutes = deepSleepMinutes + otherSleepMinutes + coreSleepMinutes + remSleepMinutes
        let deepSleepNormalized = Double(deepSleepMinutes) / Double(totalMinutes)
        let lightSleepNormalized = Double(otherSleepMinutes) / Double(totalMinutes)
        let coreSleepNormalized = Double(coreSleepMinutes) / Double(totalMinutes)
        let remSleepNormalized = Double(remSleepMinutes) / Double(totalMinutes)

        // Calculate stage scores
        deepSleepScore = Int(deepSleepNormalized * deepSleepWeight)
        otherSleepScore = Int(lightSleepNormalized * lightSleepWeight)
        coreSleepScore = Int(coreSleepNormalized * coreSleepWeight)
        remSleepScore = Int(remSleepNormalized * remSleepWeight)

        // Combine stage scores
        sleepScore = Int((deepSleepScore + otherSleepScore + coreSleepScore + remSleepScore) * 100)

        return sleepScore
    }

    
}


#Preview {
    SleepScoreView()
}
