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
    
    // UI Vars
    @State private var searchText = ""
    @State private var showFilterOptions: Bool = false
    @State private var showTagOptions: Bool = false
    
    //Filtering Options
    @State var filterOptions: [String] = ["None", "Most Recent", "Least Recent", "Most Popular"]
    @State var tagOptions: [String] = ["None", "Questions", "Tips", "Hacks", "Support", "Goals", "Midnight Thoughts"]
    @State private var filterOption: Int = 0
    @State private var tagOption: Int = 0
    
    // Query Vars
    @State private var searchPosts: [Post] = []
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
                                    Task {
                                        //await searchPosts(NUM_POSTS: queryNum)
                                        hasTriedSearch.toggle()
                                    }
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
                        .background(Color.soothingNightLightGray.opacity(0.8))
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
                    
                    ScrollViewReader { proxy in
                        // Sort Button
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                // Sort
                                Button {
                                    showFilterOptions.toggle()
                                } label: {
                                    Text("Sort")
                                        .foregroundColor(Color.white.opacity(0.8))
                                }
                                .padding(.vertical, 12).padding(.horizontal, 22)
                                .background(Color.dreamyTwilightOrchid)
                                .cornerRadius(10)
                                .buttonStyle(NoStyle())
                                
                                // Tags
                                Button {
                                    showTagOptions.toggle()
                                } label: {
                                    Text("Tags")
                                        .foregroundColor(Color.white.opacity(0.8))
                                }
                                .padding(.vertical, 12).padding(.horizontal, 22)
                                .background(Color.dreamyTwilightOrchid)
                                .cornerRadius(10)
                                .buttonStyle(NoStyle())
                                
                                
                                if filterOption > 0 && filterOption <= filterOptions.endIndex {
                                    HStack {
                                        Text(filterOptions[filterOption])
                                            .foregroundColor(Color.white.opacity(0.8))
                                        Button {
                                            filterOption = 0
                                        } label: {
                                            Image(systemName: "xmark")
                                                .resizable()
                                                .frame(width: 10, height: 10)
                                                .foregroundColor(Color.white.opacity(0.8))
                                        }
                                    }
                                    .padding(.vertical, 12).padding(.horizontal, 22)
                                    .background(Color.dreamyTwilightOrchid)
                                    .cornerRadius(10)
                                    .buttonStyle(NoStyle())
                                }
                                
                                if tagOption > 0 && tagOption <= tagOptions.endIndex {
                                    HStack {
                                        Text(tagOptions[tagOption])
                                            .foregroundColor(Color.white.opacity(0.8))
                                        Button {
                                            tagOption = 0
                                        } label: {
                                            Image(systemName: "xmark")
                                                .resizable()
                                                .frame(width: 10, height: 10)
                                                .foregroundColor(Color.white.opacity(0.8))
                                        }
                                    }
                                    .padding(.vertical, 12).padding(.horizontal, 22)
                                    .background(Color.dreamyTwilightOrchid)
                                    .cornerRadius(10)
                                    .buttonStyle(NoStyle())
                                }
                                
                                Spacer()
                                    .id("scrollEnd")
                            }
                            .onChange(of: tagOption) {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation {
                                        proxy.scrollTo("scrollEnd", anchor: .bottom)
                                    }
                                }
                            }
                            .onChange(of: filterOption) {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation {
                                        proxy.scrollTo("scrollEnd", anchor: .bottom)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .sheet(isPresented: $showFilterOptions, content: {
                            FilterOptionsView(filterOption: $filterOption)
                                .padding(.horizontal, 25)
                                .presentationDetents([.fraction(0.35)])
                        })
                        .sheet(isPresented: $showTagOptions, content: {
                            TagOptionsView(tagOption: $tagOption)
                                .padding(.horizontal, 25)
                                .presentationDetents([.fraction(0.55)])
                        })
                    }
                    
                    Spacer()
                    
                    /*
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
                   */
                }
            }
        }
        .onAppear() {
            Task {
                //searchPosts.removeAll()
                //await getAllPosts(NUM_POSTS: queryNum)
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
        filterOption = 0
    }
    
    /*
     * Function to get ALL posts from Firestore
     */
    func getAllPosts(NUM_POSTS: Int) async {
        // Database Reference
        let db = Firestore.firestore()
        
        do {
            // Fetch batch of posts from Firestore
            var query: Query! = db.collection("Posts")

            // Retrieve documents
            let postBatch = try await query.getDocuments()
            let newPosts = postBatch.documents.compactMap { post -> Post? in
                try? post.data(as: Post.self)
            }
            
            await MainActor.run(body: {
                searchPosts += newPosts
                lastPost = postBatch.documents.last
            })
            
        } catch {
            print (error.localizedDescription)
        }
        return
    }
}

struct FilterOptionsView: View {
    
    @Binding var filterOption: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Tags")
                    .font(.system(size: 24))
                    .foregroundColor(.dreamyTwilightOrchid)
                
                Spacer()
            }
            
            Divider()
                .padding(.vertical, 12)
            
            // Filter Option Buttons
            ForEach(1...SearchForumView().filterOptions.count - 1, id: \.self) { number in
                Button {
                    withAnimation {
                        filterOption = number
                    }
                } label: {
                    HStack {
                        Image(systemName: filterOption == number ? "moon.fill":"moon")
                            .foregroundColor(.dreamyTwilightOrchid)
                            .transition(.scale)
                        Text(SearchForumView().filterOptions[number])
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .padding(.vertical, 10)
                    }
                }
                .buttonStyle(NoStyle())
            }
        }
    }
}

struct TagOptionsView: View {
    
    @Binding var tagOption: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Sort")
                    .font(.system(size: 24))
                    .foregroundColor(.dreamyTwilightOrchid)
                
                Spacer()
            }
            
            Divider()
                .padding(.vertical, 12)
            
            // Filter Option Buttons
            ForEach(1...SearchForumView().tagOptions.count - 1, id: \.self) { number in
                Button {
                    withAnimation {
                        tagOption = number
                    }
                } label: {
                    HStack {
                        Image(systemName: tagOption == number ? "moon.fill":"moon")
                            .foregroundColor(.dreamyTwilightOrchid)
                            .transition(.scale)
                        Text(SearchForumView().tagOptions[number])
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                            .padding(.vertical, 10)
                    }
                }
                .buttonStyle(NoStyle())
            }
        }
    }
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
            Text("No Matches")
                .foregroundColor(.white)
                .font(.system(size: 30))
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            Spacer()
        }
    }
}

#Preview {
    SearchForumView()
}
