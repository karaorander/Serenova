//
//  RewardsDashboardView.swift
//  Serenova 2.0
//
//  Created by Voorhees, Mary Nicole on 3/18/24.
//

import SwiftUI

struct RewardsDashboardView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    
    
    func getRewards() -> [[String]] {
        if let currUser = currUser {
            return currUser.rewards
        } else {
            return [[]]
        }
    }
    
    func rewardsIsEmpty() -> Int {
        let currUser = currUser
        if (currUser?.rewards.count ?? 0) <= 0 {
            return 0
        } else {
            return 1
        }
    }
    
    func updateRewards(rewardName : String, rewardDescription : String) {
        let rewardsObj = [
            rewardName, rewardDescription
        ]
        
        if let currUser = currUser {
            var rewards = currUser.rewards
            rewards.append(rewardsObj)
            currUser.rewards = rewards
            
            currUser.updateValues(newValues: ["rewards" : rewards])
            
        } else {
            print("error")
        }
    }
}

#Preview {
    RewardsDashboardView()
}
