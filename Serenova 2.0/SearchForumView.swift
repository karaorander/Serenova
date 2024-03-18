//
//  SearchForumView.swift
//  Serenova 2.0
//
//  Created by Cristina Corley on 3/14/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

struct SearchForumView: View {
    
    @State private var searchText = ""
    @State private var showFilterOptions: Bool = false
    @State private var filterOptions: [String] = ["None", "Most Recent", "Least Recent", "Most Popular"]
    @State private var filterOption: Int = 0
    
    // Query Vars
    @State private var searchPosts: [Post] = [/*Post(title: "SLEEP", content: "Zzzzz"),
                                              Post(title: "SERENOVA", content: "CONTENT"),
                                              Post(title: "TITLE", content: "CONTENT"),
                                              Post(title: "TITLE", content: "CONTENT"),
                                              Post(title: "TITLE", content: "CONTENT")*/]
    @State private var queryNum: Int = 25
    @State private var lastPost: DocumentSnapshot?
    @State private var hasTriedSearch: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [
                    .nightfallHarmonyRoyalPurple.opacity(0.7),
                    .dreamyTwilightMidnightBlue.opacity(0.7),
                    .dreamyTwilightOrchid]),
                     startPoint: .topLeading, endPoint: .bottomLeading)
                    .ignoresSafeArea()
                VStack {
                    // Search Bar
                    HStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .fontWeight(.semibold)
                                .foregroundColor(.dreamyTwilightOrchid)
                            TextField("Search", text: $searchText)
                                .foregroundColor(.black)
                                .onSubmit {
                                    clearSearch()
                                    hasTriedSearch.toggle()
                                }
                                .submitLabel(.search)
                            if !searchText.isEmpty {
                                Button(action:{clearSearch()}){
                                    Image(systemName: "multiply.circle.fill")
                                        .resizable()
                                        .frame(width: 18, height: 18)
                                        .foregroundColor(.dreamyTwilightOrchid)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(20)
                        
                        // Cancel Button
                        Button {
                            dismiss()
                        } label: {
                            Text("Cancel")
                                .font(.callout)
                                .foregroundColor(Color.dreamyTwilightOrchid)
                                .padding(.leading, 5)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding()
                    
                    // Sort Button
                    HStack {
                        Button {
                            showFilterOptions.toggle()
                        } label: {
                            Text("Sort")
                                .foregroundColor(Color.white.opacity(0.7))
                        }
                        .padding(.vertical, 12).padding(.horizontal, 22)
                        .background(Color.dreamyTwilightOrchid)
                        .cornerRadius(10)
                        .buttonStyle(NoStyle())
                        
                        
                        if filterOption == 1 || filterOption == 2 || filterOption == 3 {
                            HStack {
                                Text(filterOptions[filterOption])
                                    .foregroundColor(Color.white.opacity(0.7))
                                Button {
                                    filterOption = 0
                                } label: {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 10, height: 10)
                                        .foregroundColor(Color.white.opacity(0.7))
                                }
                            }
                            .padding(.vertical, 12).padding(.horizontal, 22)
                            .background(Color.dreamyTwilightOrchid)
                            .cornerRadius(10)
                            .buttonStyle(NoStyle())
                        }
                        
                        Spacer()
                    
                    }
                    .padding(.horizontal)//.padding(.bottom)
                    .sheet(isPresented: $showFilterOptions, content: {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Sort")
                                    .font(.system(size: 24))
                                    .foregroundColor(.dreamyTwilightOrchid)
                                
                                Spacer()
                            }
                            .padding(.bottom, 12)
                            
                            Divider()
                            
                            //Most Recent
                            Button {
                                withAnimation {
                                    filterOption = 1
                                }
                            } label: {
                                HStack {
                                    Image(systemName: filterOption == 1 ? "moon.fill":"moon")
                                        .foregroundColor(.dreamyTwilightOrchid)
                                        .transition(.scale)
                                    Text("Most Recent")
                                        .font(.system(size: 20))
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(.top, 12).padding(.bottom, 10)
                            .buttonStyle(NoStyle())
                            // Least Recent
                            Button {
                                withAnimation {
                                    filterOption = 2
                                }
                            } label: {
                                HStack {
                                    Image(systemName: filterOption == 2 ? "moon.fill":"moon")
                                        .foregroundColor(.dreamyTwilightOrchid)
                                        .transition(.scale)
                                    Text("Least Recent")
                                        .font(.system(size: 20))
                                        .foregroundColor(.black)
                                        .padding(.vertical, 10)
                                }
                            }
                            .buttonStyle(NoStyle())
                            // Most Popular
                            Button {
                                withAnimation {
                                    filterOption = 3
                                }
                            } label: {
                                HStack {
                                    Image(systemName: filterOption == 3 ? "moon.fill":"moon")
                                        .foregroundColor(.dreamyTwilightOrchid)
                                        .transition(.scale)
                                    Text("Most Popular")
                                        .font(.system(size: 20))
                                        .foregroundColor(.black)
                                        .padding(.vertical, 10)
                                }
                            }
                            .buttonStyle(NoStyle())
                        }
                        .padding(.horizontal, 25)
                        .presentationDetents([.fraction(0.35)])
                    })
                    
                    if hasTriedSearch && searchPosts.count == 0{
                        // Display "No Posts Found"
                        NoMatchesFoundView()
                            .padding(.bottom, 150)
                    } else if searchPosts.count > 0 {
                        List {
                            ForEach(searchPosts.indices, id: \.self) { index in
                                PostListingView(post: searchPosts[index])
                                    .onAppear {
                                        if index == searchPosts.count - 1 && lastPost != nil {
                                            Task {
                                                // TODO: Pagination
                                            }
                                        }
                                    }
                                    .padding(5)
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.soothingNightDeepIndigo)
                            )
                        }
                        .padding(8)
                        .listRowSpacing(5)
                        .listStyle(PlainListStyle())
                        .scrollIndicators(ScrollIndicatorVisibility.hidden)
                    }
                    Spacer()
                }
            }
        }
    }
    
    /*
     * Function to clear search bar and remove
     * all posts that have been retrieved.
     */
    func clearSearch() {
        searchText = ""
        searchPosts.removeAll()
        lastPost = nil
    }
    
    /*
     * Function to search for posts from Firestore
     * based on the filters provided.
     */
}

struct NoMatchesFoundView: View {
    var body: some View {
        VStack (alignment: .center){
            Spacer()
            Image(systemName: "moon.stars.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.white)
                .padding()
            Text("No Matches Found")
                .foregroundColor(.white)
                .font(.system(size: 25))
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
}

#Preview {
    SearchForumView()
}
