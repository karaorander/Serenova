//
//  NotificationsView.swift
//  Serenova 2.0
//
//  Created by Ishwarya Samavedhi on 3/27/24.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth

struct NotificationsView: View {
    @StateObject var notificationsModel = NotificationsModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [
                    .moonlitSerenitySteelBlue.opacity(0.7),
                    .dreamyTwilightMidnightBlue.opacity(0.7),
                    .dreamyTwilightMidnightBlue]),
                startPoint: .topLeading, endPoint: .bottomLeading)
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    Text("Notifications")
                        .font(Font.custom("NovaSquareSlim-Bold", size: 35))
                        .foregroundColor(.white)
                        .padding()

                    if notificationsModel.notifications.isEmpty {
                        Spacer()
                        Text("No Notifications")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                        Spacer()
                    } else {
                        List(notificationsModel.notifications, id: \.self) { notification in
                            Text(notification)
                                .foregroundColor(Color.nightfallHarmonyRoyalPurple)
                                .listRowBackground(Color.tranquilMistAshGray)
                        }
                        .listStyle(PlainListStyle())
                    }

                    // Navigation Links at the bottom, similar to JournalView
                    HStack(spacing: 40) {
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
                    }
                    .padding()
                    .background(Color.dreamyTwilightMidnightBlue)
                }
            }
            .onAppear {
                notificationsModel.updateNoti()
            }
        }
    }
}

class NotificationsModel: ObservableObject {
    @Published var notifications: [String] = []

    func updateNoti() {
        if let currentUser = Auth.auth().currentUser {
            let db = Database.database().reference()
            let id = currentUser.uid
            let ur = db.child("User").child(id)
            ur.observeSingleEvent(of: .value) { snapshot in
                guard let userData = snapshot.value as? [String: Any] else {
                    print("Error fetching data")
                    return
                }
                
                if let notifications = userData["notifications"] as? [String] {
                    DispatchQueue.main.async {
                        self.notifications = notifications
                    }
                }
            }
        } else {
            // Handle the case where there's no authenticated user
            print("No authenticated user")
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
