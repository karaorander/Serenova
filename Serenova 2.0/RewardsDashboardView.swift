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
                            NavigationLink(destination: RedeemOptionsView()) {
                                Text("Redeem Options")
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.gray)
                                    .cornerRadius(10)
                            }
                            
                            // Current Tasks Section
                            VStack {
                                TaskView(taskName: "Sleep Streak", moonReward: 100, iconName: "moon.zzz")
                                TaskView(taskName: "Wellness Warrior", moonReward: 50, iconName: "link")
                                TaskView(taskName: "Wellness Warrior", moonReward: 25, iconName: "speaker.wave.2")
                            }
                        }
                    }
                    .padding()
                }
                .navigationBarHidden(true)
            }
        }
    

    }
    // Get rewards (2D Array) from Firebase
    // Format: [ ["rewardName1", "rewardDescription1"], ["rewardName2", "rewardDescription2"] ]
    func getRewards() -> [[String]] {
        if let currUser = currUser {
            return currUser.rewards
        } else {
            return [[]]
        }
    }
    
    // Checks if the user has achieved any rewards
    func rewardsIsEmpty() -> Int {
        let currUser = currUser
        if (currUser?.rewards.count ?? 0) <= 0 {
            return 0
        } else {
            return 1
        }
    }
    

    func displayFriendRewards() {
        if let currUser = currUser {
            for friend in currUser.friends {
                var friendRewards = currUser.getFriendData(friendID: friend, data: "rewards")
            }
        }
    }
}

struct TaskView: View {
    var taskName: String
    var moonReward: Int
    var iconName: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30)
            Text(taskName)
            Spacer()
            Text("\(moonReward) Moons")
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
    }
}

struct RedeemOptionsView: View {
    var body: some View {
        Text("Redeem your moons here!")
        // Implementation of your redeem options view
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


    

