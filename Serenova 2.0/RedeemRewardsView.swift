//
//  RedeemRewardsView.swift
//  Serenova 2.0
//
//  Created by Ishwarya Samavedhi on 3/10/24.
//

import SwiftUI

struct RedeemRewardsView: View {
    @State private var moonBalance: Int = 75 // You would fetch this from your actual data source
    
    
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Redeem")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                
                // Placeholder for menu button
                Image(systemName: "line.horizontal.3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 25)
                    .foregroundColor(.blue)
            }
            .padding()

            ScrollView {
                VStack(spacing: 20) {
                    RewardOptionView(title: "Neon Color Pack", description: "Unlock more colorize to customize your app!", moonCost: 75)
                    RewardOptionView(title: "Fall Nature Sounds", description: "Unlock more sounds in the fall theme for your collection!", moonCost: 250)
                    RewardOptionView(title: "Wellness Upgrade", description: "Advance your wellness collection with even more articles", moonCost: 500)
                    RewardOptionView(title: "See anyones followers", description: "You can now access the feature where you see other user's follower count", moonCost: 1000)
                    RewardOptionView(title: "Promote your dream", description: "Get your dream to the top of the forum for a day so it gains alot of traction!", moonCost: 2500)
                }
                .padding(.top)
            }
        }
    }
}

struct RewardOptionView: View {
    let title: String
    let description: String
    let moonCost: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.blue)
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                Spacer()
                Text("\(moonCost)")
                    .foregroundColor(.blue)
                Image(systemName: "moon.fill")
                    .foregroundColor(.blue)
                
                Button(action: {
                    // action to redeem this option
                }) {
                    Text("REDEEM")
                        .bold()
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}


#Preview {
    RedeemRewardsView()
}
