//
//  FriendRequestView.swift
//  Serenova 2.0
//
//  Created by Kara Orander on 3/24/24.
//

import SwiftUI

struct FriendRequestView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Color gradient
                LinearGradient(gradient: Gradient(colors: [.nightfallHarmonySilverGray.opacity(0.7), .nightfallHarmonyRoyalPurple.opacity(0.3), .dreamyTwilightMidnightBlue.opacity(0.5), .nightfallHarmonyNavyBlue.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    FriendRequestView()
}
