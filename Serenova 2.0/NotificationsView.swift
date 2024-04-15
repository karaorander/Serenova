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
                    HStack {
                        NavigationLink(destination: SleepGoalsView().navigationBarBackButtonHidden(true)) {
                            
                            Image(systemName: "line.horizontal.3.decrease")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.white)
                            
                        }
                        Spacer()
                        
                        Text("Notifications")
                            .font(Font.custom("NovaSquareSlim-Bold", size: 35))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        NavigationLink(destination: 
                                        NotificationsSettingsView()
                            .navigationBarBackButtonHidden(true)) {
                            Image(systemName: "gearshape")
                                .resizable()
                                .fontWeight(.semibold)
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                        }
                        
                    }
                    .padding()
                    .padding(.horizontal, 15)
                    /*Text("Notifications")
                        .font(Font.custom("NovaSquareSlim-Bold", size: 35))
                        .foregroundColor(.white)
                        .padding()*/

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
                                    Spacer().frame(width: 5)
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
                                    Spacer().frame(width: 5)
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
                notificationsModel.getPreferences()
                notificationsModel.getNotifications()
            }
        }
    }
}

class NotificationsModel: ObservableObject {
    @Published var notifications: [String] = []
    @Published var friendNotifications: Bool = true
    @Published var messageNotifications: Bool = true
    
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
                            if let type = data["type"] as?
                                String {
                                if (type == "friend" && self.friendNotifications) || (type == "message" && self.messageNotifications) {
                                    if let message = data["message"] as? String {
                                        // Append the message to the temporary array
                                        tempArray.append(message)
                                    }
                                }
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
    
    func getPreferences() {
        guard let currentUser = Auth.auth().currentUser else {
            print("No authenticated user")
            return
        }

        let db = Database.database().reference()
        let userRef = db.child("User").child(currentUser.uid)

        userRef.observeSingleEvent(of: .value) { snapshot in
            guard let userData = snapshot.value as? [String: Any] else {
                print("Error fetching data: invalid data format")
                return
            }

            // Extracting friendNotifications and messageNotifications
            if let friendNotifications = userData["friendNotifications"] as? Bool {
                DispatchQueue.main.async {
                    self.friendNotifications = friendNotifications
                }
            }
            
            if let messageNotifications = userData["messageNotifications"] as? Bool {
                DispatchQueue.main.async {
                    self.messageNotifications = messageNotifications
                }
            }
        }
    }
    
    func storePreferences() {
        guard let currentUser = Auth.auth().currentUser else {
            print("No authenticated user")
            return
        }

        let db = Database.database().reference()
        let userRef = db.child("User").child(currentUser.uid)

        let userData: [String: Any] = [
            "friendNotifications": self.friendNotifications,
            "messageNotifications": self.messageNotifications
        ]

        userRef.updateChildValues(userData) { error, _ in
            if let error = error {
                print("Error updating user preferences: \(error)")
            } else {
                print("Preferences updated successfully")
            }
        }
    }
}

struct NotificationsSettingsView: View {
    @StateObject var notificationsModel = NotificationsModel()
    //@State private var friendsNotifications: Bool = notificationsModel.friendNotifications
    //@State private var messageNotifications: Bool = notificationsModel.messageNotifications
    
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
                    HStack {
                        Spacer().frame(width: 10)
                        NavigationLink(destination: NotificationsView()
                        .navigationBarBackButtonHidden(true)) {
                            Image(systemName: "chevron.backward")
                                .resizable()
                                .fontWeight(.semibold)
                                .frame(width: 15, height: 20)
                                .foregroundColor(.white)
                        }
                        
                        Text("Notification Settings")
                            .font(Font.custom("NovaSquareSlim-Bold", size: 30))
                            .foregroundColor(.white)
                            .padding()
                    }

                    /*if notificationsModel.notifications.isEmpty {
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
                    }*/
                    Spacer().frame(height: 30)
                    VStack{
                        //Friends Notification Toggle
                        Toggle(isOn: $notificationsModel.friendNotifications, label: {Text ("Friend Requests")})
                            .toggleStyle(SwitchToggleStyle(tint: .nightfallHarmonyNavyBlue))
                            .padding().frame(width:350, height: 40)
                            .fontWeight(.medium)
                        
                        //.background(Color.tranquilMistAshGray)
                            .foregroundColor(.tranquilMistAshGray).cornerRadius(5)
                            .brightness(0.3)
                        
                        //Message Notification Toggle
                        Toggle(isOn: $notificationsModel.messageNotifications, label: {Text ("Messages")})
                            .toggleStyle(SwitchToggleStyle(tint: .nightfallHarmonyNavyBlue))
                            .padding().frame(width:350, height: 40)
                            .fontWeight(.medium)
                        //.background(Color.tranquilMistAshGray)
                            .foregroundColor(.tranquilMistAshGray).cornerRadius(5)
                            .brightness(0.3)
                    }
                    
                    Spacer().frame(height:50)
                    
                    // Submit button
                    Button (action: {
                        notificationsModel.storePreferences()
                    }) {
                        Text("Submit")
                            .font(.system(size: 20)).fontWeight(.medium).frame(width: 300, height: 50).background(Color.soothingNightLightGray.opacity(0.6)).foregroundColor(.nightfallHarmonyNavyBlue.opacity(1)).cornerRadius(10)
                    }
                    Spacer()
                }
            }/*
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
            
        })*/
            .onAppear {
                notificationsModel.getPreferences()
            }
        }
    }
}


struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsSettingsView()
    }
}
