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
var goal_stats = [
    GoalStats(id: 0, title: "Deep Sleep", currentData: 0, goal: 1 /*CGFloat(getTotalGoal())*/, color: .dreamyTwilightLavenderPurple),
    GoalStats(id: 1, title: "Total Sleep", currentData: 0, goal: 1 /*CGFloat(getDeepGoal())*/, color: .soothingNightAccentBlue)
]

class GoalViewModel: ObservableObject {
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

let articles = [
    Article(articleTitle: "The Importance of Deep Sleep", articleLink: "https://www.medicalnewstoday.com/articles/325363", articlePreview: "Deep sleep plays a crucial role in your overall health...", articleTags: ["Health", "Sleep"], articleId: "1"),
    Article(articleTitle: "5 Tips for Better Sleep Hygiene", articleLink: "https://www.medicalnewstoday.com/articles/325363", articlePreview: "Improving your sleep hygiene can lead to better sleep quality...", articleTags: ["Tips", "Hygiene"], articleId: "2"),
    // Add more articles as needed
]

struct ArticleRow: View {
    var article: Article

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(article.articleTitle)
                .font(.headline)
                .foregroundColor(.primary)
            Text(article.articlePreview)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct ArticleCard: View {
    var article: Article

    var body: some View {
        VStack {
            // Placeholder for an article image
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(height: 120)
                .cornerRadius(12)
                .overlay(
                    Text(article.articleTitle) // Consider adding a Text Overlay for the title or use a separate Text view below
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(),
                    alignment: .bottomLeading
                )

            Text(article.articlePreview)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding([.horizontal, .bottom])
                .frame(width: 250, alignment: .leading) // Fixed width for alignment in horizontal scroll
        }
        .background(Color.white) // Card background
        .cornerRadius(12)
        .shadow(radius: 5) // Shadow for depth
        .padding(.vertical, 5) // Slight vertical padding
    }
}

//potential opening screen
struct SleepGoalsView: View {
    @StateObject private var viewModel = GoalViewModel()
    
    @State var selected = 0
    var colors = [Color.tranquilMistAccentTurquoise.opacity(0.6), Color.dreamyTwilightMidnightBlue]
    var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    
    @State private var total_query_sleep: Int = 0
    @State private var total_query_deep: Int = 0
    let sleepManager = SleepManager()
    
    
    @State private var viewSleepScore:Bool = false
    
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
                                            .trim(from: 0, to: min(1, goal.goal > 0 ? (goal.currentData / goal.goal) : 0))
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
                                    Text("Goal: \(getHrs(value:goal.goal)) Hrs")
                                        .font(.system(size:15, weight: .bold))
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
                        NavigationLink (destination: SleepScoreView().navigationBarBackButtonHidden(true)) {
                            HStack {
                                Text("View Today's Sleep Score").font(.system(size: 18)).fontWeight(.medium)
                                    .foregroundColor(.nightfallHarmonyNavyBlue)
                                    .cornerRadius(10)
                                Image(systemName: "arrow.right").foregroundColor(.white)
                            }.frame(width: 320, height: 50)
                                .background(Color.tranquilMistAshGray)
                                .foregroundColor(.nightfallHarmonyNavyBlue)
                                .cornerRadius(10)
                        }
                        
                        
                    }.padding()
                    
                    
                    HStack {
                        VStack {
                            Text("Your Moon Count: \(viewModel.moonCount)").font(.system(size: 18)).fontWeight(.medium)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            Image(systemName: "star").foregroundColor(.white)
                            
                        }
                    }.frame(width: 320, height: 200)
                        .background(Color.dreamyTwilightMidnightBlue)
                        .foregroundColor(.nightfallHarmonyNavyBlue)
                        .cornerRadius(10)
                    
                    VStack {
                        Text("Related Articles")
                            .font(.system(size:24, weight: .bold))
                            .fontWeight(.bold)
                            .foregroundColor(.nightfallHarmonyNavyBlue.opacity(0.8)) // Adjust text color as needed
                            .padding(.top)
                            .frame(maxWidth: .infinity) // Use maxWidth to allow the text to center
                            .multilineTextAlignment(.center) // Center alignment for the text

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) { // Maintain spacing between article boxes
                                ForEach(articles, id: \.articleId) { article in
                                    Link(destination: URL(string: article.articleLink)!) {
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(article.articleTitle)
                                                .font(.headline)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white) // Adjust text color as needed
                                                .lineLimit(2) // Limit title to 2 lines

                                            Text(article.articlePreview)
                                                .font(.subheadline)
                                                .foregroundColor(.white.opacity(0.7)) // Adjust text color as needed
                                                .lineLimit(3) // Limit preview text to 3 lines
                                        }
                                        .padding()
                                        .background(Color.moonlitSerenityLilac.opacity(0.1)) // Set background color
                                        .cornerRadius(10)
                                        .shadow(radius: 2)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.bottom)
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
                        NavigationLink(destination: ForumView().navigationBarBackButtonHidden(true)) {

                                Image(systemName: "person.2")
                                    .resizable()
                                    .frame(width: 45, height: 30)
                                    .foregroundColor(.white)
                            
                        }
                        NavigationLink(destination: JournalView().navigationBarBackButtonHidden(true)) {

                            Image(systemName: "book.closed")
                                .resizable()
                                .frame(width: 30, height: 40)
                                .foregroundColor(.white)
                        
                    }
                }.padding()
                .hSpacing(.center)
                .background(Color.dreamyTwilightMidnightBlue)
                    
            }
                
        }
        }.onAppear {
            viewModel.fetchUsername{
                getTotalSleep()
                
                print("GOAL: \(getTotalGoal())")
                print("SLEEP: \(total_query_sleep)")
            }
            
        }
        
        
    }
    //calc percent
    func getPercent(current: CGFloat, Goal: CGFloat) ->String{
         if Goal == 0 {
             return String(format: "No Goals!")
        }
        var per = (current / Goal) * 100
        if per < 0 {
            per = 0
        } else if per > 100 {
            per = 100
        }
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
    
    func getTotalSleep() {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let startOfWeek = calendar.date(byAdding: .day, value: -weekday + 1, to: today)!
        let endOfWeek = calendar.date(byAdding: .day, value: 7 - weekday, to: today)!
        
        var currentDate = startOfWeek
        
        let group = DispatchGroup()
        
        while currentDate <= endOfWeek {
            group.enter()
            
            sleepManager.querySleepData(completion: { totalSleepTime, deepSleepTime, coreSleepTime, remSleepTime in
                total_query_sleep += Int(totalSleepTime ?? 0) / 60
                total_query_deep += Int(deepSleepTime ?? 0) / 60
                
                group.leave() // Leave the dispatch group when the query completes
            }, date: currentDate)
            
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        group.notify(queue: .main) {
            
            print("TOTAL QUERY SLEEP: \(total_query_sleep)")
            print("TOTAL QUERY DEEP: \(total_query_deep)")
            goal_stats[0].currentData = CGFloat(total_query_deep)
            goal_stats[1].currentData = CGFloat(total_query_sleep)
            

            updateGoalStats()
            /*if (getDeepGoal() <= Float(total_query_deep)) {
                currUser?.updateMoons(rewardCount: 50)
            }
            if (getDeepGoal() <= Float(total_query_deep)) {
                currUser?.updateMoons(rewardCount: 50)
            }*/
        }
    }
    
    func updateGoalStats() {
        goal_stats = [
            GoalStats(id: 0, title: "Deep Sleep", currentData: CGFloat(total_query_deep), goal: CGFloat(getDeepGoal()), color: .dreamyTwilightLavenderPurple),
            GoalStats(id: 1, title: "Total Sleep", currentData: CGFloat(total_query_sleep), goal: CGFloat(getTotalGoal()), color: .soothingNightAccentBlue)
        ]
        
    }
    
    
    func getTotalGoal() -> Float{
        if let currUser = currUser {
            var totalGoal = (viewModel.totalSleepGoalHours * 60) + viewModel.totalSleepGoalMins
            goal_stats[1].goal = CGFloat(totalGoal)
            if (totalGoal < 0) {
                return 0
            } else {
                return totalGoal
            }
        } else {
            return 0
        }
    }

    func getDeepGoal() -> Float{
        if let currUser = currUser {
            var deepGoal = (viewModel.deepSleepGoalHours * 60) + viewModel.deepSleepGoalMins
            goal_stats[0].goal = CGFloat(deepGoal)
            if (deepGoal < 0) {
                return 0
            } else {
                return deepGoal
            }
        } else {
            return 0
        }
    }
    
    
}


//New view
struct EditGoalsView: View {
    @StateObject private var viewModel = GoalViewModel()
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
                            Button(action:{
                                //save goals
                                //fetch new data
                                saveGoals{
                                    viewModel.fetchUsername{}
                                }
                            }){
                                Text("Save Goals").font(.system(size: 18)).fontWeight(.medium).foregroundColor(.white).cornerRadius(10)
                                
                            }.frame(width: 320, height: 50).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(10)
                        }
                        
                    }
                    
                }
            }
            
        }
        
    }
    
    
    func saveGoals(completion: @escaping () -> Void) {
        if let currUser = currUser {
            currUser.totalSleepGoalHours = Float(total_hrs)
            currUser.totalSleepGoalMins = Float(total_min)
            currUser.deepSleepGoalHours = Float(deep_hrs)
            currUser.deepSleepGoalMins = Float(deep_min)
            currUser.updateValues(newValues: ["totalSleepGoalHours" :
                                                currUser.totalSleepGoalHours,
                                              "totalSleepGoalMins" : currUser.totalSleepGoalMins,
                                              "deepSleepGoalHours" : currUser.deepSleepGoalHours,
                                              "deepSleepGoalMins" : currUser.deepSleepGoalMins])
        } else {
            print("error")
        }
        completion()
    }
    
    func getTotalGoal() -> Float{
        if let currUser = currUser {
            var totalGoal = (viewModel.totalSleepGoalHours * 60) + viewModel.totalSleepGoalMins
            if (totalGoal < 0) {
                return 0
            } else {
                return totalGoal
            }
        } else {
            return 0
        }
    }

    func getDeepGoal() -> Float{
        if let currUser = currUser {
            var deepGoal = (viewModel.deepSleepGoalHours * 60) + viewModel.deepSleepGoalMins
            if (deepGoal < 0) {
                return 0
            } else {
                return deepGoal
            }
        } else {
            return 0
        }
    }
    
    // description and name format can be changed
    func metTotalGoal() {
        var currentData = goal_stats[1].currentData
        if (getTotalGoal() >= Float(currentData)) {
            currUser?.updateMoons(rewardCount: 50)
        }
    }
    
    // description and name format can be changed
    func metDeepGoal() {
        var currentData = goal_stats[0].currentData
        if (getDeepGoal() >= Float(currentData)) {
            currUser?.updateMoons(rewardCount: 50)
        }
    }

}

    private var viewModel = AccountInfoViewModel()
    
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
