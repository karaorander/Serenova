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
                                    .fill(Color.dreamyTwilightMidnightBlue).padding()
                            )
                            
                            
                        }.background(Color.dreamyTwilightMidnightBlue)
                        .refreshable {
                            Task {
                                journalEntries = []
                                lastEntry = nil
                                await queryJournal(NUM_ENTRIES: queryNum)
                            }
                        }
                        .overlay(alignment: .bottom, content:  {NavigationLink(destination: createJournalView().navigationBarBackButtonHidden(true)) {
                            Image(systemName: "plus")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.dreamyTwilightMidnightBlue)
                                .frame(width: 50, height: 50)
                                .background(.white, in: .circle)
                                .padding()
                        }.isDetailLink(false)})
                    }
                    
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
                        NavigationLink(destination: ForumPostView().navigationBarBackButtonHidden(true)) {

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
            
        }.overlay(alignment: .bottom, content:  {NavigationLink(destination: createJournalView().navigationBarBackButtonHidden(true)) {
            Image(systemName: "plus")
                .fontWeight(.semibold)
                .foregroundStyle(Color.dreamyTwilightMidnightBlue)
                .frame(width: 50, height: 50)
                .background(.white, in: .circle)
                .padding()
        }.isDetailLink(false)})
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
                .interactiveDismissDisabled()
                
                
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
    @Environment(\.dismiss) private var dismiss
    

    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [
                .dreamyTwilightMidnightBlue,
                .dreamyTwilightMidnightBlue]),
                           startPoint: .topLeading, endPoint: .bottomLeading)
            .ignoresSafeArea()
            VStack {
                HStack {
                    Button{ dismiss()
                    } label: {
                        Image(systemName:
                                "chevron.left").hSpacing(.leading).foregroundColor(.white)
                    }.padding()
                    if !isEditing {
                        Button("Edit") {
                            editedContent = journal.journalContent
                            editedTitle = journal.journalTitle
                            isEditing = true
                        }
                        .padding()
                        .foregroundColor(.white)
                        Menu {
                            Button("Delete", role: .destructive) {
                                journal.deleteJournal()
                                dismiss()
                            }
                        } label: {
                            Text("Delete Entry").font(.callout).foregroundColor(Color.red)
                        }.padding()
                        
                    } else {
                        Button("Cancel") {
                            isEditing = false
                        }
                        .padding().foregroundColor(.white)
                    }
                }
                Spacer()
                ScrollView(.vertical, showsIndicators: false) {
                    Text("Journal Details")
                        .font(Font.custom("NovaSquareSlim-Bold", size: 35))
                        .foregroundColor(.white)
                    if !isEditing {
                        TextField(journal.journalTitle, text: $editedTitle)
                            .font(.system(size: 20)).fontWeight(.bold).foregroundColor(.white)
                            .padding()
                            .disabled(!isEditing)
                            .padding(.horizontal, 30)
                        TextField(journal.journalContent, text: $editedContent, axis: .vertical)
                            .padding()
                            .font(.system(size: 18)).fontWeight(.medium).foregroundColor(.white)
                            .disabled(!isEditing)
                            .padding(.horizontal, 30)
                    } else {
                        
                            TextField(journal.journalTitle, text: $editedTitle)
                                .font(.system(size: 25)).fontWeight(.bold).foregroundColor(.white)
                                .padding()
                                .disabled(!isEditing)
                                .padding(.horizontal, 30)
                                .background(.white.opacity(0.15)).cornerRadius(10).padding()
                       
                        TextField(journal.journalContent, text: $editedContent, axis: .vertical)
                            .font(.system(size: 18)).fontWeight(.medium).foregroundColor(.white)
                            .padding()
                            .disabled(!isEditing)
                            .padding(.horizontal, 30)
                            .background(.white.opacity(0.15)).cornerRadius(10).padding()
                    }
                        
                }
                
               Spacer()
                
                // Display editable text field only when editing mode is enabled
                if isEditing {
                    
                        // Save button to update the journal content
                        Button("Save") {
                            journal.updateValues(newValues: ["journalTitle" : editedTitle,
                                                             "journalContent" : editedContent])
                            isEditing = false
                        }
                        .padding().foregroundColor(.white)
                        .buttonStyle(NoStyle1())
                        
                       
                   
                } else {
                        // Save button to update the journal content
                        Button("") {
                            
                        }
                        .padding()
                        
                        
                    
                }
                Spacer()
            }.onAppear {
                editedContent = journal.journalContent
                editedTitle = journal.journalTitle
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


 
