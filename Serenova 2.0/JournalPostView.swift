//
//  JournalPostView.swift
//  Serenova 2.0
//
//  Created by Ava Schrandt on 3/21/24.
//


import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage

//Create New Post View
struct JournalPostView: View {
    /// callback
    //var onPos: (Post)->()

    @State var journalText: String = ""
    @State var journalTitle: String = ""


    ///use app storage to get user data from firebase.  EX:
    //@AppStorage("userName") var userName: String = ""
    @State private var isLoading:Bool = false
    @State private var showError:Bool = false
    @State private var errorMess: String = ""

    @FocusState private var showkeyboard: Bool

    @State private var isCreatingPost: Bool = false
    @State private var isPosted: Bool = false

    @State var tagOptions: [String] = ["None", "Questions", "Tips", "Hacks", "Support", "Goals", "Midnight Thoughts"]
    @State private var tagOption: Int = 0
    @State private var showTagOptions: Bool = false

    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView{
            ZStack {
                LinearGradient(gradient: Gradient(colors: [
                    .nightfallHarmonyRoyalPurple.opacity(0.7),
                    .dreamyTwilightMidnightBlue.opacity(0.7),
                    .dreamyTwilightOrchid]),
                     startPoint: .topLeading, endPoint: .bottomLeading)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Menu {
                            Button("Delete Entry", role: .destructive) {
                                dismiss()
                            }
                        } label: {
                            Text("Cancel").font(.callout).foregroundColor(Color.dreamyTwilightOrchid)
                        }
                        NavigationLink ("", destination: ForumView().navigationBarBackButtonHidden(true), isActive: $isPosted)
                        Spacer()
                        Button(action: {
                            createJournal()
                            isCreatingPost = true
                            dismiss()
                        }) {
                            Text("Create Entry").font(.callout)
                                .foregroundColor(.dreamyTwilightOrchid)
                                .padding(.horizontal,20)
                                .padding(.vertical, 6)
                                .background(.white, in: Capsule())
                        }
                        .disabled(journalText == "" || journalTitle == "")
                        .opacity((journalText == "" || journalTitle == "") ? 0.4 : 1)
                    }.padding(.horizontal, 15).padding(.vertical, 10)
                    ScrollView(.vertical, showsIndicators:false) {
                        VStack(spacing: 15){
                            HStack {
                                TextField("Title", text: $journalTitle)
                                    .fontWeight(.bold)
                                    .focused($showkeyboard)
                            }.padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                            // Tags

                            HStack {
                                TextField("What's on your mind?", text: $journalText, axis: .vertical)
                                    .focused($showkeyboard)
                                    .frame(minHeight: 150, alignment: .top)
                            }.padding()
                                .foregroundColor(.black)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                        }.padding(15)


                    }

                    Divider()

                }.vSpacing(.top)

                    //.alert(errorMess, isPresented: $showImagePicker, actions: {})
                    .alert(
                        "Post Creation Failure",
                        isPresented: $showError
                    ) {
                        Button("OK") {}
                    } message: {
                        Text(errorMess)
                    }
                /*
                    if isCreatingPost {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .tint(.white)
                            .scaleEffect(2)
                    }
                 */
                }

        }
    }
    //error handling -> error alerts
    func errorAlerts(_ error: Error)async{
        await MainActor.run(body: {
            errorMess = error.localizedDescription
            showError.toggle()
        })
    }

    //error handling -> error alerts (String version)
    func errorAlerts(_ error: String)async{
        await MainActor.run(body: {
            errorMess = error
            showError.toggle()
        })
    }

    func createJournal() {
        showkeyboard = false
        isLoading = true

        Task {
            do {
                // TESTING IN PREVIEW MODE:
                // Comment out the guard below and use
                // the second constructor for Post (uncomment it)

                guard currUser != nil else {
                    await errorAlerts("ERROR! Not signed in.")
                    return
                }

                // Create new Post Object
                //var newPost = Post(title: postTitle, content: postText
                                   //authorUsername: currUser.username,
                                   //authorID: currUser.userID,
                                   //authorProfilePhoto: currUser.profileURL)

                let newEntry = Journal(journalTitle: journalTitle, journalContent: journalText)
                try await newEntry.addJournalEntry()

                // Store Image & Get DownloadURL

            } catch {
                await errorAlerts(error)
            }
        }
    }

    /*
     * Function to store image in Firebase Storage
     */

}


#Preview {
    ForumPostView()
}
