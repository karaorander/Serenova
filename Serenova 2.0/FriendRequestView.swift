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

class RequestViewModel: ObservableObject {
    @Published var friendRequestsArray = [Friend]()

       func getRequests() {
           if let currentUser = Auth.auth().currentUser {
               let db = Firestore.firestore()
               let currentUserID = Auth.auth().currentUser!.uid
               
               // Reference to the "FriendRequests" collection for the current user
               let friendRequestsCollectionRef = db.collection("FriendRequests").document(currentUserID)
               
               // Fetch all documents from the "friendRequests" subcollection
               friendRequestsCollectionRef.collection("friendRequests").getDocuments { (querySnapshot, error) in
                   if let error = error {
                       print("Error getting documents: \(error)")
                   } else {
                       var tempArray = [Friend]()
                       
                       // Iterate through each document in the "friendRequests" subcollection
                       for document in querySnapshot!.documents {
                           let data = document.data()
                           let friendID = data["friendid"] as? String ?? ""
                           let requesterName = data["requesterName"] as? String ?? ""
                           
                           // Create a Friend object
                           let friend = Friend(friendID: friendID, requesterName: requesterName)
                           
                           // Append to the temporary array
                           tempArray.append(friend)
                       }
                       
                       // Update the published property on the main queue
                       DispatchQueue.main.async {
                           self.friendRequestsArray = tempArray
                       }
                   }
               }
           }
       }
}

struct FriendRequestView: View {
    @StateObject private var viewModel = RequestViewModel()
    var body: some View {
        NavigationView {
            ZStack {
                // Color gradient
                LinearGradient(gradient: Gradient(colors: [.nightfallHarmonySilverGray.opacity(0.8), .nightfallHarmonyRoyalPurple.opacity(0.4), .dreamyTwilightMidnightBlue.opacity(0.6), .nightfallHarmonyNavyBlue.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                            
                        Spacer()
                        
                        Text("Friend Requests")
                            .font(Font.custom("NovaSquareSlim-Bold", size: 35))
                            .foregroundColor(.white)
                        
                        Spacer()
                        // TODO: This is the search for when a user wants to search for a request to follow another user
                        /*
                        NavigationLink(destination: SearchForumView().navigationBarBackButtonHidden(true)) {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .fontWeight(.semibold)
                                .frame(width: 25, height: 25)
                                .foregroundColor(.white)
                        }*/
                        
                    }
                    .padding()
                    .padding(.horizontal, 15)
                    
                            if viewModel.friendRequestsArray.isEmpty {
                                NoRequestsView()
                            } else {
                                List {
                                    ForEach(viewModel.friendRequestsArray, id: \.self) { friendRequest in
                                        requestView(friendRequest: friendRequest)
                                            .padding(5)
                                    }
                                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                                    .listRowBackground(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.soothingNightDeepIndigo.opacity(0.5))
                                    )
                                }
                                .padding(8)
                                .listRowSpacing(5)
                                .listStyle(PlainListStyle())
                                .scrollIndicators(ScrollIndicatorVisibility.hidden)
                            }
                        }
                        .onAppear {
                            viewModel.getRequests()
                        }
            }
        }
    }
}

class Friend: Codable, Hashable {
    public var friendID: String = ""
    public var requesterName: String = ""
    
    init(friendID: String, requesterName: String) {
            self.friendID = friendID
            self.requesterName = requesterName
        }

    // Implementing Hashable protocol
    func hash(into hasher: inout Hasher) {
        hasher.combine(friendID)
    }

    static func == (lhs: Friend, rhs: Friend) -> Bool {
        return lhs.friendID == rhs.friendID
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

struct requestView: View {
    var friendRequest: Friend
    
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                Text(friendRequest.requesterName)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color.nightfallHarmonyRoyalPurple.opacity(0.9))
                    .padding(.bottom, 2)
                    .brightness(0.5)
                    //.saturation(0.3)
                
                Spacer()
                HStack {
                    Button ("Approve", action: {
                        
                    })
                    .font(.system(size: 15)).fontWeight(.medium).frame(width: 90, height: 30)
                    .background(Color.soothingNightLightGray.opacity(0.4).brightness(0.5))
                    .foregroundColor(.nightfallHarmonyRoyalPurple.opacity(1))
                    .cornerRadius(10)
                    
                    Button ("Deny", action: {
                        
                    })
                    .font(.system(size: 15)).fontWeight(.medium).frame(width: 90, height: 30)
                    .background(Color.soothingNightLightGray.opacity(0.4).brightness(0.5))
                    .foregroundColor(.nightfallHarmonyRoyalPurple.opacity(1))
                    .cornerRadius(10)
                }
            }
        }
    }
}

#Preview {
    FriendRequestView()
}
