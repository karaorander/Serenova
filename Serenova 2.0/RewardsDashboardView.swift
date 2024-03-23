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
    
    
    /*
     * TODO: Function that checks if a User is a friend
     */

    func displayFriendRewards() {
        if let currUser = currUser {
            for friend in currUser.friends {
                var friendRewards = currUser.getFriendData(friendID: friend, data: "rewards")
            }
        }
    }
}

#Preview {
    RewardsDashboardView()
}
