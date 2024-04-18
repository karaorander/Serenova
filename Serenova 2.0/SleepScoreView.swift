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
    @State private var exportTitle: String = ""
    @State private var exportContent: String = ""
    
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
                            Text("\(viewModel.fullname)'s Sleep Score")
                                .font(Font.custom("NovaSquareSlim-Bold", size: 25))
                                .foregroundColor(.white)
                                .scaledToFit().minimumScaleFactor(0.01)
                                .lineLimit(1).hSpacing(.center)
                            NavigationLink(destination: ForumPostView(postText: exportContent, postTitle: exportTitle).navigationBarBackButtonHidden(true)) {
                                Image(systemName: "square.and.arrow.up")
                                    .resizable()
                                    .frame(width: 20, height: 25)
                                    .foregroundColor(.white)
                            }.isDetailLink(false)
                            
                        }.padding()
                        
                        VStack {
                            HStack {
                                Image(systemName: "zzz").foregroundColor(.tranquilMistMauve).padding(.leading).padding(.top)
                                Text("Welcome to your daily sleep score!")
                                    .font(Font.system(size: 14, weight: .bold))
                                    .foregroundColor(.tranquilMistMauve)
                                    .frame(width: 300, alignment: .leading)
                                    .lineSpacing(4)
                                    .padding(.top)
                                    .padding(.trailing)
                            }
                            HStack {
                                Image(systemName: "").foregroundColor(.nightfallHarmonyNavyBlue).font(.system(size: 12)).padding(.leading)
                                Text("Log your sleep and check back here to see today's score and to learn more about last night's sleep cycle! 💫")
                                    .font(Font.system(size: 12, weight: .medium))
                                    .foregroundColor(.nightfallHarmonyNavyBlue)
                                    .frame(width: 300, alignment: .leading)
                                    .lineSpacing(4)
                                    .padding(.vertical)
                                    .padding(.trailing)
                            }
                            
                        }.background(.white.opacity(0.06))
                            .cornerRadius(15)
                            .shadow(color: .white.opacity(0.1), radius: 10)
                        Spacer()
                        
                        Text("\(sleepScore)")
                            .font(.system(size: 75))
                            .foregroundColor(.white)
                            .scaledToFit().minimumScaleFactor(0.01)
                            .lineLimit(1)
                            .padding()
                            .frame(width: 200, height: 200).background(Color.tranquilMistAshGray.opacity(0.1)).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(100)
                        Text("Today's Score")
                            .font(Font.custom("NovaSquareSlim-Bold", size: 30))
                            .foregroundColor(.moonlitSerenitySteelBlue).opacity(0.9)
                            .scaledToFit().minimumScaleFactor(0.01)
                            .lineLimit(1)
                        Spacer()
                        
                        
                        Spacer()
                        
                        VStack {
                            Text("Analyzing the stages:").foregroundColor(.dreamyTwilightMidnightBlue)
                                .font(.system(size: 20, weight: .bold))
                                .hSpacing(.leading)
                                .padding(.leading).padding(.top)
                            Text("\(totalSleepMin) minutes in total\n\(deepSleepMin) minutes spent in deep sleep\n\(coreSleepMin) minutes spent in light sleep\n\(remSleepMin) minutes spent in REM").foregroundColor(.white).font(.system(size: 14,weight:.medium))
                                .hSpacing(.leading).padding(.leading)
                            Spacer()
                            
                           
                        }.background(.white.opacity(0.06))
                            .cornerRadius(15)
                            .shadow(color: .white.opacity(0.1), radius: 10).padding()
                        VStack {
                           
                            Text("How it's weighted").foregroundColor(.dreamyTwilightMidnightBlue)
                                .font(.system(size: 20, weight: .bold)).hSpacing(.leading).padding(.leading).padding(.top)
                            Text("Recommended sleep for adults is 7-9 hours.  This score is normalized to the ideal 8hrs of sleep!").foregroundColor(.white).font(.system(size: 14,weight:.medium)).hSpacing(.leading).padding(.leading).lineSpacing(4)
                            Spacer()
                            Text("Your score calculated as follows:\n +100 for 8hrs+ of total sleep\n +10 for every hour in deep sleep\n +5 for every hour in light sleep\n +5 for every hour in REM").foregroundColor(.gray).font(.system(size: 14,weight:.bold)).hSpacing(.leading).padding(.leading).lineSpacing(4).padding(.bottom)
                            
                        }.background(Color.tranquilMistMauve.opacity(0.1))
                            .cornerRadius(15)
                            .shadow(color: .tranquilMistMauve.opacity(0.1), radius: 10).padding()
                            
                        
                        
                        
                        
                    }
                }
            }

        }.onAppear() {
            viewModel.fetchUsername {
                sleepManager.querySleepData(completion: { totalSleepTime, deepSleepTime, coreSleepTime, remSleepTime in
                    DispatchQueue.main.async {
                       
                        totalSleepMin = (Int(totalSleepTime ?? 0)) / 60
                        print(totalSleepMin)
                        deepSleepMin = (Int(deepSleepTime ?? 0)) / 60
                        coreSleepMin = (Int(coreSleepTime ?? 0)) / 60
                        remSleepMin = (Int(remSleepTime ?? 0)) / 60
                        otherSleepMin = (Int(totalSleepTime ?? 0)) / 60-(((Int(deepSleepTime ?? 0)) / 60) +
                                                                         ((Int(coreSleepTime ?? 0)) / 60) + ((Int(remSleepTime ?? 0)) / 60))
                        if totalSleepMin == 0 {
                            sleepScore = 0
                        } else {
                            sleepScore = calculateSleepScore(deepSleepMinutes: (Int(deepSleepTime ?? 0)) / 60, coreSleepMinutes: (Int(coreSleepTime ?? 0)) / 60, remSleepMinutes: (Int(remSleepTime ?? 0)) / 60, totalSleepMinutes: (Int(totalSleepTime ?? 0)) / 60)
                        }
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "EEEE, MMM d"
                        let dateString = dateFormatter.string(from: Date())
                        exportTitle = "\(viewModel.fullname)'s Sleep: \(dateString)"
                        exportContent = "💫 \(viewModel.fullname)'s sleep score of the day: \(sleepScore)\n\nThe breakdown:\n\(totalSleepMin) minutes in total\n\(deepSleepMin) minutes spent in deep sleep\n\(coreSleepMin) minutes spent in light sleep\n\(remSleepMin) minutes spent in REM"
                    }
                }, date: Date())
            }
            
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
    
    func calculateSleepScore(deepSleepMinutes: Int, coreSleepMinutes: Int, remSleepMinutes: Int, totalSleepMinutes: Int) -> Int {
        var deviation:Int = 0
        
        let idealSleepDuration = 8 * 60
        // Calc deviation from ideal sleep duration
         deviation = 0
        if(!(totalSleepMinutes > idealSleepDuration)) {
            deviation = abs(totalSleepMinutes - idealSleepDuration)
        }
        

        
        let otherSleepMinutes = totalSleepMinutes - (deepSleepMinutes + coreSleepMinutes + remSleepMinutes) - deviation

        
        let deepSleepWeight = 10
        let otherSleepWeight = 5
        let coreSleepWeight = 5
        let remSleepWeight = 5

        let deepSleepHours = deepSleepMinutes / 60
        let otherSleepHours = otherSleepMinutes / 60
        let coreSleepHours = coreSleepMinutes / 60
        let remSleepHours = remSleepMinutes / 60

        let deepSleepScore = deepSleepHours * deepSleepWeight
        let otherSleepScore = otherSleepHours * otherSleepWeight
        let coreSleepScore = coreSleepHours * coreSleepWeight
        let remSleepScore = remSleepHours * remSleepWeight
        

        // combine stage scores
        var combinedScore = 100
        combinedScore -= max(0, deviation / 10)
        combinedScore += deepSleepScore + coreSleepScore + remSleepScore

        return combinedScore
    }

    
}


#Preview {
    SleepScoreView()
}
