//
//  NotificationsView.swift
//  Serenova 2.0
//
//  Created by Ishwarya Samavedhi on 3/27/24.
//

import SwiftUI
import FirebaseDatabase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

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
                        VStack {
                            List(notificationsModel.notifications, id: \.self) { notification in
                                HStack {
                                    Text(notification)
                                        .foregroundColor(Color.nightfallHarmonyRoyalPurple.opacity(0.8))
                                        .listRowBackground(
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.nightfallHarmonyRoyalPurple.opacity(0.5))
                                                .brightness(0.5)
                                        )
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        // Call removeNotification on the clicked notification
                                        notificationsModel.removeNotification(notification)
                                    }) {
                                        Text("Seen")
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background(Color.blue.opacity(0.7))
                                            .foregroundColor(.white)
                                            .cornerRadius(5)
                                    }
                                }
                                .listRowInsets(EdgeInsets())  // Add this line if needed to ensure correct layout
                            }
                        }
                    }
                }
                              
            }
            .overlay(alignment: .bottom, content: {
            
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
            
        })
            .onAppear {
                notificationsModel.getNotifications()
            }
        }
    }
}

class NotificationsModel: ObservableObject {
    @Published var notifications: [String] = []

    /*func updateNoti() {
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
    }*/
    
    func getNotifications() {
            if let currentUser = Auth.auth().currentUser {
                let db = Firestore.firestore()
                let currentUserID = currentUser.uid
                
                // Reference to the "notifications" collection for the current user
                let notificationsCollectionRef = db.collection("FriendRequests").document(currentUserID).collection("notifications")
                
                // Fetch all documents from the "notifications" collection
                notificationsCollectionRef.getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        var tempArray = [String]()
                        
                        // Iterate through each document in the "notifications" collection
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            if let message = data["message"] as? String {
                                // Append the message to the temporary array
                                tempArray.append(message)
                            }
                        }
                        
                        // Update the published property on the main queue
                        DispatchQueue.main.async {
                            self.notifications = tempArray
                        }
                    }
                }
            } else {
                print("No authenticated user")
            }
        }
    
    func removeNotification(_ notification: String) {
        // Check if the notification exists in the notifications array
        if let index = notifications.firstIndex(of: notification) {
            // Remove the notification from the array
            notifications.remove(at: index)
            
            // Remove the notification from Firestore
            if let currentUser = Auth.auth().currentUser {
                let db = Firestore.firestore()
                let currentUserID = currentUser.uid
                
                // Reference to the "notifications" collection for the current user
                let notificationsCollectionRef = db.collection("FriendRequests").document(currentUserID).collection("notifications")
                
                // Find the document to delete by message
                notificationsCollectionRef.whereField("message", isEqualTo: notification).getDocuments { querySnapshot, error in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        for document in querySnapshot!.documents {
                            // Delete the document
                            document.reference.delete { error in
                                if let error = error {
                                    print("Error deleting document: \(error)")
                                } else {
                                    print("Notification successfully deleted")
                                }
                            }
                        }
                    }
                }
            } else {
                print("No authenticated user")
            }
        }
    }
}


struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
