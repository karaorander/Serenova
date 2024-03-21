//
//  JournalView.swift
//  Serenova 2.0
//
//  Created by Ava Schrandt on 3/21/24.
//



import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

struct JournalView: View {
    
    @State private var journalEntries: [Journal] = []
    @State private var queryNum: Int = 25
    @State private var lastEntry: DocumentSnapshot?
    
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
                        // TODO: Make Dropdown Menu with different options (e.g. Home)
                        NavigationLink(destination: SleepGoalsView().navigationBarBackButtonHidden(true)) {
                            
                            Image(systemName: "line.horizontal.3.decrease")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.white)
                            
                        }
                            
                        Spacer()
                        
                        Text("Journal")
                            .font(Font.custom("NovaSquareSlim-Bold", size: 35))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                       
                        
                    }
                    .padding()
                    .padding(.horizontal, 15)
                        
                    if journalEntries.count == 0 {
                        NoEntriesView1()
                    } else {
                        List {
                            ForEach(journalEntries, id: \.id) { entry in
                                JournalListingView(journal: entry)
                                    .onAppear {
                                        if lastEntry != nil {
                                            Task {
                                                await queryJournal(NUM_ENTRIES: queryNum)
                                            }
                                        }
                                    }
                                    .padding(5)
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .padding(8)
                            .listRowSpacing(10)
                            .listStyle(PlainListStyle())
                            .scrollIndicators(ScrollIndicatorVisibility.hidden)
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.soothingNightDeepIndigo)
                            )
                        }
                        .refreshable {
                            Task {
                                journalEntries = []
                                lastEntry = nil
                                await queryJournal(NUM_ENTRIES: queryNum)
                            }
                        }
                        .background(Color.dreamyTwilightMidnightBlue)
                    }

                    HStack(content: {
                        
                        
                        Spacer()
                        
                        NavigationLink(destination: JournalPostView().navigationBarBackButtonHidden(true)) {
                            Image(systemName: "plus")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.dreamyTwilightOrchid)
                                .frame(width: 50, height: 50)
                                .background(.white, in: .circle)
                        }.isDetailLink(false)
                        
                        Spacer()
                        
                        // TODO: Link to direct messages
                        //NavigationLink(destination: ForumPostView().navigationBarBackButtonHidden(true)) {
                        Image(systemName: "text.bubble.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                        //}.isDetailLink(false
                    })
                    .padding()
                    .padding(.horizontal, 15)
                    .hSpacing(.center)
                }
            }
            .onAppear() {
               UIRefreshControl.appearance().tintColor = .white
                Task {
                    if journalEntries.count == 0 {
                        await queryJournal(NUM_ENTRIES: queryNum)
                    }
                }
            }
        }
    }
    
    /*
     * Retrieves posts from Firebase
     */
    func queryJournal(NUM_ENTRIES: Int) async {
        // Database Reference
        let db = Firestore.firestore()
        
        do {
            var userId: String = ""
            if let user = Auth.auth().currentUser {
                // User is signed in
                userId = user.uid
                
               // print("User ID:", userId)
            } else {
                // No user is signed in
                print("No user signed in")
            }
            // Fetch batch of posts from Firestore
            var query: Query! = db.collection("Journal")
                .whereField("userId", isEqualTo: userId)
                .order(by: "timeStamp", descending: true)
                .limit(to: NUM_ENTRIES)
            
            if let lastEntry = lastEntry {
                query = query.start(afterDocument: lastEntry)
            }
            
            // Retrieve documents
            let journalBatch = try await query.getDocuments()
            let newEntries = journalBatch.documents.compactMap { post -> Journal? in
                try? post.data(as: Journal.self)
            }
            
            await MainActor.run(body: {
                journalEntries += newEntries
                lastEntry = journalBatch.documents.last
            })
            
        } catch {
            print (error.localizedDescription)
        }
        return
    }
}

struct NoEntriesView1: View {
    
    var body: some View {
        VStack (alignment: .center){
            Spacer()
            Image(systemName: "moon.zzz.fill")
                .resizable()
                .frame(width: 55, height: 60)
                .foregroundColor(.white)
                .padding()
            Text("Create your first entry")
                .foregroundColor(.white)
                .font(.system(size: 25))
                .fontWeight(.semibold)
            Spacer()
        }
    }
}


struct JournalListingView: View {
    
    let journal: Journal
    
    
    @State private var isClicked: Bool = false
    @State private var selectedJournal: Journal?
    var body: some View {
        Button (action: {isClicked.toggle()
            selectedJournal = journal}) {
            VStack(alignment: .leading) {
                HStack {
                
                    
                    VStack(alignment: .leading){
                        Text("\(journal.getRealTime())")
                            .font(.system(size: 13))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                    }
                }
                .padding(.vertical, 10)
            
                // Post preview content
                Text(journal.journalTitle)
                    .font(.custom("NovaSquareSlim-Bold", size: 20))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color.nightfallHarmonyRoyalPurple)
                    .padding(.bottom, 2)
                    .brightness(0.3)
                    .saturation(1.5)
                // Limit word count of preview to: 50 characters
                if journal.journalContent.count <= 55 {
                    Text(journal.journalContent)
                        .foregroundColor(.white)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .padding(.bottom, 8)
                } else {
                    Text(journal.journalContent.prefix(55) + "...")
                        .foregroundColor(.white)
                        .multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                        .padding(.bottom, 8)
                }
                
                
                
                
            }
        }
        .buttonStyle(NoStyle1())
        .listRowSeparator(.hidden)
        .sheet(isPresented: $isClicked, content: {
            JournalDetailsView(journal: journal)
                //.interactiveDismissDisabled()
                .presentationCornerRadius(30)
                
        })
        // TODO: Link to Post page
        //NavigationLink(destination: ForumPostView().navigationBarBackButtonHidden(true))
    }
    
    
}
struct JournalDetailsView: View {
    let journal: Journal
        @State private var editedContent: String = ""
    @State private var editedTitle: String = ""
        @State private var isEditing: Bool = false

    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [
                .moonlitSerenitySteelBlue.opacity(0.7),
                .dreamyTwilightMidnightBlue.opacity(0.7),
                .dreamyTwilightMidnightBlue]),
                           startPoint: .topLeading, endPoint: .bottomLeading)
            .ignoresSafeArea()
            VStack {
                
                Spacer()
                Text("Journal Details")
                    .font(Font.custom("NovaSquareSlim-Bold", size: 35))
                    .foregroundColor(.white)
                
                TextField(journal.journalTitle, text: $editedTitle)
                    .font(.system(size: 20)).fontWeight(.bold).foregroundColor(.black)
                    .padding()
                    .disabled(!isEditing)
                
                TextField(journal.journalContent, text: $editedContent)
                    .font(.system(size: 18)).fontWeight(.medium).foregroundColor(.black)
                    .disabled(!isEditing)
                    .padding()
                
                // Edit button to enable editing mode
                Button("Edit") {
                    editedContent = journal.journalContent
                    editedTitle = journal.journalTitle
                    isEditing = true
                }
                .padding()
                
                // Display editable text field only when editing mode is enabled
                if isEditing {
                    
                    
                    // Save button to update the journal content
                    Button("Save") {
                        // Update the journal content in Firestore
                        // Here you can implement the code to update the journal content in Firestore
                        // firestore.updateJournalContent(journalId: journal.id, newContent: editedContent)
                        // After saving, exit editing mode
                        isEditing = false
                    }
                    .padding()
                    
                    // Cancel button to exit editing mode without saving changes
                    Button("Cancel") {
                        isEditing = false
                    }
                    .padding()
                   
                }
                Spacer()
            }
        }
    }
}

struct NoStyle1: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
    }
}

#Preview {
    JournalView()
}


 
