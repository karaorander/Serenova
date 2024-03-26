//
//  RewardsView.swift
//  Serenova 2.0
//
//  Created by Ishwarya Samavedhi on 3/10/24.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

class MoonProgressViewModel: ObservableObject {
    @Published var moonCount : Int = -1
    @Published var sleepGoalReached : Bool = false
    
    func fetchMoons() {
        let db = Database.database().reference()
        let id = Auth.auth().currentUser!.uid
        let ur = db.child("User").child(id)
        ur.observeSingleEvent(of: .value) { snapshot in
            guard let userData = snapshot.value as? [String: Any] else {
                print("Error fetching data")
                return
            }
            
            if let moonCount = userData["moonCount"] as? Int {
                self.moonCount = moonCount
            }
            
            if let sleepGoalReached = userData["sleepGoalReached"] as? Bool {
                self.sleepGoalReached = sleepGoalReached
            }
        }
    }
}


struct MoonProgressView: View {
    //var moons: Int
    static let moonThresholds: [Int] = [25, 50, 100, 300, 500]
    @StateObject private var viewModel = MoonProgressViewModel()

    var body: some View {
        HStack {
            ForEach(Self.moonThresholds, id: \.self) { threshold in
                ZStack {
                    // Draw the moon or checkmark
                    if viewModel.moonCount >= threshold {
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                    } else {
                        Image(systemName: "moon.fill")
                            .foregroundColor(.gray)
                    }

                    // Text for the number
                    Text("\(threshold)")
                        .offset(y: 20) // Adjust the offset as needed
                        .font(.caption)
                        .foregroundColor(.black)
                }

                // Draw the line between moons
                if threshold != Self.moonThresholds.last {
                    Rectangle()
                        .fill(viewModel.moonCount >= threshold ? Color.green : Color.gray)
                        .frame(height: 2)
                        .flexibleHorizontalPadding()
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

extension View {
    func flexibleHorizontalPadding() -> some View {
        self.padding(.horizontal, UIScreen.main.bounds.width / CGFloat(MoonProgressView.moonThresholds.count * 3))
    }
}


    

struct RewardsDashboardView: View {
    //@State private var moonBalance: Int = 75
    @StateObject private var viewModel = MoonProgressViewModel()
    var body: some View {
        VStack {
            NavigationView {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [.dreamyTwilightMidnightBlue.opacity(0.2), .nightfallHarmonyNavyBlue.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                    
                    // Main content
                    VStack {
                        Text("Rewards")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding()
                        
                        MoonProgressView()
                            .padding()
                        // Moon balance
                        HStack {
                            Text("\(viewModel.moonCount)")
                                .font(.system(size: 50))
                                .fontWeight(.heavy)
                            Image(systemName: "moon.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 50)
                        }
                        .padding()
                        
                        // Redeem Options and Current Tasks
                        VStack(spacing: 20) {
                            // Redeem Options Button
                            NavigationLink(destination: RedeemRewardsView()) {
                                Text("Redeem Options")
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.gray)
                                    .cornerRadius(10)
                            }
                            
                            // Current Tasks Section
                            VStack {
                                TaskView(taskName: "Sleep Log Daily Goal", moonReward: 20, iconName: "moon.zzz", description: "Be in 5 hours of your sleep goal range to get 20 moons!", color: viewModel.sleepGoalReached ? .green : .black)
                                TaskView(taskName: "Wellness Warrior", moonReward: 50, iconName: "link", description: "Complete 5 wellness activities this week to earn 50 moons.", color: .black)
                                TaskView(taskName: "Mindfulness Master", moonReward: 25, iconName: "speaker.wave.2", description: "Participate in a 10-minute mindfulness session to earn 25 moons.", color: .black)
                            }
                            .onAppear {
                                viewModel.fetchMoons()
                            }
                        }
                    }
                    .padding()
                }
                .navigationBarHidden(true)
            }
        }
        .onAppear {
            viewModel.fetchMoons()
        }
    }
    
    // Checks if the user has achieved any rewards
    func rewardsIsEmpty() -> Int {
        let currUser = currUser
        if currUser?.moonCount == 0 {
            return 0
        } else {
            return 1
        }
    }
    

    // Gets all MoonCounts for every UserID in the list of Friends
    func getFriendsRewardCount() -> [Int] {
        var friendsRewards = [Int]()
        if let currUser = currUser {
            for friend in currUser.friends {
                friendsRewards.append(Int(currUser.getFriendData(friendID: friend, data: "moonCount")) ?? 0)
            }
        }
        return friendsRewards
    }
    
}

struct PopoverContentView: View {
    var taskName: String
    var description: String
    var iconName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: iconName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
                Text(taskName)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            Divider()
            Text(description)
                .font(.body)
            Spacer()
        }
        .frame(width: 300, height: 200) // Adjust the size of the popover content as needed
        .padding()
        .background(Color.blue.opacity(0.2)) // Change the background color here
        .cornerRadius(12) // Add rounded corners to the background
        .padding() // Add some padding around the popover content to avoid edge-to-edge coloring
    }
}

struct TaskView: View {
    var taskName: String
    var moonReward: Int
    var iconName: String
    var description: String
    var color: Color
    @State private var showPopover = false

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
                .foregroundColor(color)
            Text(taskName)
                .foregroundColor(color)
            Spacer()
            Text("\(moonReward) Moons")
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
        .onTapGesture {
            self.showPopover = true
        }
        .popover(isPresented: $showPopover) {
            PopoverContentView(taskName: taskName, description: description, iconName: iconName)
                .padding()
        }
    }
}


// Preview provider for Xcode
struct RewardsDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        RewardsDashboardView()
    }
}

#Preview {
    RewardsDashboardView()
}


    

