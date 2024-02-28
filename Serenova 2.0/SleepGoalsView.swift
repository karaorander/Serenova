//
//  SleepLogView.swift
//  Serenova 2.0
//
//  Created by Ava Schrandt on 2/21/24.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseDatabaseSwift

// Get username
class GoalViewModel: ObservableObject {
    @Published var fullname = ""

    
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
            
        }
    }
}


//potential opening screen
struct SleepGoalsView: View {
    @StateObject private var viewModel = AccountInfoViewModel()
    
    @State var selected = 0
    var colors = [Color.tranquilMistAccentTurquoise.opacity(0.6), Color.dreamyTwilightMidnightBlue]
    var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    var body: some View {

        
        NavigationView {
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [ .nightfallHarmonyRoyalPurple.opacity(0.8), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
               
                VStack {
                ScrollView(.vertical, showsIndicators: false){
                    
                    VStack {
                        
                        Text("Hello, \(viewModel.fullname)")
                            .font(Font.custom("NovaSquare-Bold", size: 100))
                            .foregroundColor(.white.opacity(0.7))
                            .scaledToFit().minimumScaleFactor(0.01)
                            .lineLimit(1)
                            .overlay(alignment: .topTrailing, content: {
                                
                                    NavigationLink(destination: AccountInfoView().navigationBarBackButtonHidden(true)) {

                                        Image(systemName: "person.crop.circle.fill")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 45, height: 45)
                                            .clipShape(.circle)
                                            .foregroundColor(.white)
                                            .position(x:300, y:0)
                                    
                                    }.padding(.bottom)
                                
                            })
                        
                        //Daily Sleep Columns
                        VStack (alignment: .leading, spacing:2){
                            Text("Daily Sleep in Hours").font(.system(size: 15, weight: .heavy)).foregroundColor(.dreamyTwilightMidnightBlue)
                            HStack() {
                                ForEach(sleep_data, id: \.self) {data in
                                    VStack {
                                        VStack {
                                            Spacer(minLength: 0)
                                            if selected == data.id{
                                                Text(getHrs(value: data.sleepMinutes)).foregroundColor(.nightfallHarmonyNavyBlue).padding(.bottom, 5).font(.caption)
                                            }
                                            
                                            RoundedShape().fill(LinearGradient(gradient: Gradient(colors: selected == data.id ? colors : [Color.nightfallHarmonyNavyBlue.opacity(0.1)]), startPoint: .top, endPoint: .bottom))
                                            //max height = 200
                                                .frame(height: getheight(value: data.sleepMinutes))
                                            Text(data.day).font(.caption).foregroundColor(.nightfallHarmonyNavyBlue)
                                            
                                        }
                                        .frame(height: 200)
                                        .onTapGesture {
                                            withAnimation(.easeOut) {
                                                selected = data.id
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }.padding().background(Color.white.opacity(0.06)).cornerRadius(10)
                        
                        //Sleep Goals
                        Spacer(minLength: 30)
                        HStack {
                            Text("This week's sleep goals")
                                .font(.system(size: 25, weight: .black))
                                .foregroundColor(.dreamyTwilightMidnightBlue.opacity(0.9))
                                .lineLimit(1)
                            Image(systemName: "moon.stars.fill").foregroundColor(.white)
                        }
                        //sleep goals circle grid
                        LazyVGrid(columns: columns, spacing: 30) {
                            ForEach(goal_stats) {goal in
                                VStack(spacing: 22) {
                                    HStack {
                                        Text(goal.title).font(.system(size: 22)).fontWeight(.bold).foregroundColor(.white.opacity(0.8))
                                    }
                                    ZStack {
                                        Circle()
                                            .trim(from: 0, to: 1)
                                            .stroke(goal.color.opacity(0.3), lineWidth: 15)
                                            .frame(width: (UIScreen.main.bounds.width - 150)/2, height: (UIScreen.main.bounds.width - 150)/2)
                                        Circle()
                                            .trim(from: 0, to: (goal.currentData/goal.goal))
                                            .stroke(goal.color, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                                            .frame(width: (UIScreen.main.bounds.width - 150)/2, height: (UIScreen.main.bounds.width - 150)/2)
                                        Text("\(getPercent(current: goal.currentData, Goal: goal.goal))%")
                                            .font(.system(size: 22))
                                            .fontWeight(.bold).foregroundStyle(goal.color)
                                            .rotationEffect(.init(degrees: 90))
                                    }
                                    .rotationEffect(.init(degrees: -90))
                                    Text(getHrs(value:goal.currentData) + " Hrs")
                                        .font(.system(size:22, weight: .bold))
                                        .foregroundColor(goal.color)
                                }.padding()
                                    .background(.white.opacity(0.06))
                                    .cornerRadius(15)
                                    .shadow(color: .white.opacity(0.1), radius: 10)
                            }
                        }
                        .padding()
                        NavigationLink (destination: EditGoalsView().navigationBarBackButtonHidden(true)) {
                            HStack {
                                Text("Edit Sleep Goals").font(.system(size: 18)).fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                Image(systemName: "arrow.right").foregroundColor(.white)
                            }.frame(width: 320, height: 50)
                                .background(Color.tranquilMistAshGray)
                                .foregroundColor(.nightfallHarmonyNavyBlue)
                                .cornerRadius(10)
                        }
                    }.padding()
                }
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
                .onAppear {
                    viewModel.fetchUsername()
                }
        }
    }
        
    }
    //calc percent
    func getPercent(current: CGFloat, Goal: CGFloat) ->String{
        let per = (current / Goal) * 100
        return String(format: "%.1f", per)
    }
    func getheight(value: CGFloat)->CGFloat{
        //val in minutes
        let hrs = CGFloat(value / 1440) * 300
        return hrs
    }
    func getHrs(value: CGFloat)->String {
        let hrs = value / 60
        return String(format: "%.1f", hrs)
    }
}


//New view
struct EditGoalsView: View {
    @State var selectedDate = Date()
    @State var total_hrs: Int = 0
    @State var total_min: Int = 0
    @State var deep_hrs: Int = 0
    @State var deep_min: Int = 0
    
    
    
    var body: some View {
        
        
        
        NavigationView {
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [ .nightfallHarmonyRoyalPurple.opacity(0.8), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                
                NavigationLink (destination: SleepGoalsView().navigationBarBackButtonHidden(true)) {
                    Image(systemName: "arrow.left").foregroundColor(.white).position(x:40, y: 20).font(.system(size: 22, weight: .bold))
                    
                }
                
                VStack (spacing: 30){
                    HStack{
                        Text("Let's set your weekly goals").font(.system(size:22, weight: .bold)).foregroundColor(.dreamyTwilightMidnightBlue.opacity(0.9))
                        Image(systemName: "zzz").foregroundColor(.white).font(.system(size: 20, weight: .bold))
                    }
                    VStack (alignment:.leading, spacing: 25){
                        VStack(alignment: .leading, spacing: 15){
                            Text("Total Sleep: \(total_hrs)hrs \(total_min) min").font(.system(size: 20, weight: .bold)).foregroundColor(.white)
                            HStack {
                                Text("Hrs:").font(.system(size: 20, weight: .bold)).foregroundColor(.moonlitSerenityLilac)
                                Stepper("", value: $total_hrs, in: 1...400, step: 1).labelsHidden().background(.white.opacity(0.6)).cornerRadius(20)
                                Text("Min:").font(.system(size: 20, weight: .bold)).foregroundColor(.moonlitSerenityLilac)
                                Stepper("", value: $total_min, in: 0...400, step: 1).labelsHidden().background(.white.opacity(0.6)).cornerRadius(20)
                            }
                            
                            
                        }
                        VStack(alignment: .leading, spacing: 15){
                            Text("Total Deep Sleep: \(deep_hrs)hrs \(deep_min) min").font(.system(size: 20, weight: .bold)).foregroundColor(.white)
                            HStack {
                                Text("Hrs:").font(.system(size: 20, weight: .bold)).foregroundColor(.moonlitSerenityLilac)
                                Stepper("", value: $deep_hrs, in: 1...400, step: 1).labelsHidden().background(.white.opacity(0.6)).cornerRadius(20)
                                Text("Min:").font(.system(size: 20, weight: .bold)).foregroundColor(.moonlitSerenityLilac)
                                Stepper("", value: $deep_min, in: 0...400, step: 1).labelsHidden().background(.white.opacity(0.6)).cornerRadius(20)
                            }
                            
                            
                        }
                    }.padding().background(.white.opacity(0.06)).cornerRadius(15)
                        .shadow(color: .white.opacity(0.1), radius: 10)
                    NavigationLink (destination: SleepGoalsView().navigationBarBackButtonHidden(true)) {
                        HStack {
                            Text("Save Goals").font(.system(size: 18)).fontWeight(.medium).foregroundColor(.white).cornerRadius(10)
                            // saveGoals(goal)
                        }.frame(width: 320, height: 50).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(10)
                    }
                    
                    
                }
                
            }
        }
    }
}


//circle shape
struct RoundedShape: Shape {
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 5, height: 5))
        return Path(path.cgPath)
    }
}
//daily Sample data
//TODO: get sleep data
struct Daily: Hashable {
    var id : Int
    var day : String
    var sleepMinutes : CGFloat
    var deepSleepMinutes : CGFloat
    var remMinutes : CGFloat
}
var sleep_data = [
    Daily(id: 0, day: "Day 1", sleepMinutes: 600, deepSleepMinutes: 300, remMinutes: 300),
    Daily(id: 1, day: "Day 2", sleepMinutes: 400, deepSleepMinutes: 150, remMinutes: 250),
    Daily(id: 2, day: "Day 3", sleepMinutes: 500, deepSleepMinutes: 300, remMinutes: 200),
    Daily(id: 3, day: "Day 4", sleepMinutes: 300, deepSleepMinutes: 220, remMinutes: 80),
    Daily(id: 4, day: "Day 5", sleepMinutes: 450, deepSleepMinutes: 300, remMinutes: 150),
    Daily(id: 5, day: "Day 6", sleepMinutes: 600, deepSleepMinutes: 400, remMinutes: 200),
    Daily(id: 6, day: "Day 7", sleepMinutes: 320, deepSleepMinutes: 300, remMinutes: 20)
]

struct GoalStats: Identifiable {
    var id: Int
    var title: String
    var currentData : CGFloat
    var goal: CGFloat
    var color : Color
}
 
//goals sample data
//TODO: get sleep data
var goal_stats = [
    GoalStats(id: 0, title: "Deep Sleep", currentData: 300, goal: 2100, color: .dreamyTwilightLavenderPurple),
    GoalStats(id: 1, title: "Total Sleep", currentData: 500, goal: 4000, color: .soothingNightAccentBlue)
]


//func saveGoals(goal: int) {
//    var ref = Database.database().reference()
//    // could store as object to hold more info
//     ref.child("SleepGoals").setValue(goal)
//}
//
//// TODO: read from API to get other value for comparison
//func readValueGoal() {
//    var ref = Database.database().reference()
//
//    var goal = ref.child("SleepGoals")
//    child.observeSingleEvent(of: .value) { snapshot in
//        self.value = snapshot.value as? int ?? "Error"
//    }
//
//}

#Preview {
    SleepGoalsView()
}
