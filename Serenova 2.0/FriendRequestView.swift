//
//  FriendRequestView.swift
//  Serenova 2.0
//
//  Created by Kara Orander on 3/24/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

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
    
    func queryRequests(NUM_REQUESTS: Int) async {
        // Database Reference
    }
}

struct NoRequestsView: View {
    var body: some View {
        VStack (alignment: .center){
            Spacer()
            Image(systemName: "moon.stars.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.white)
                .padding()
            Text("No Posts Yet")
                .foregroundColor(.white)
                .font(.system(size: 30))
                .fontWeight(.semibold)
            Spacer()
        }
    }
}

#Preview {
    FriendRequestView()
}
