//
//  AccountInfoView.swift
//  Serenova 2.0
//
//  Created by Kara Orander on 2/16/24.
//

import SwiftUI
import Firebase

struct AccountInfoView: View {
    @State private var color_theme = "Dreamy Twilight"
    // TODO: Get username, full name, email, notification preferences from database
    @State public var myusername = "MYUSERNAME"
    @State public var myemail = "MYEMAIL"
    @State private var fullname = "MYNAME"
    @State private var notifications: Bool = false
    @State private var toggleIsOn: Bool = false

    @State private var showImagePicker: Bool = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State var userImageData: Data?
    @State var userImageURL: URL?

    init() {
        fetchUsername();
    }

    func fetchUsername() {
        if let user = Auth.auth().currentUser {
            let username = user.displayName
            // Do something with the username
            print("Username: \(username ?? "No username available")")
            if (username != nil) {
                myusername = (username ?? "No username found")
            }
            if (user.email != nil) {
                myemail = (user.email ?? "No username found")
            } else {
                print("No email")
            }
        } else {
            // No user is signed in
            print("No user signed in")
        }
    }

    var body: some View {
        VStack{
            NavigationView{
                ZStack{
                    LinearGradient(gradient: Gradient(colors: [.dreamyTwilightMidnightBlue.opacity(0.2), .nightfallHarmonyNavyBlue.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                    VStack {
                        Text("Account Info")
                            .font(Font.custom("NovaSquare-Bold", size: 40))

                            .frame(height: 2.0, alignment: .leading)
                            .padding()
                        Spacer().frame(height: 20)

                        // Color drop down menu
                        // Color theme stored in $color_theme
                        VStack {
                            HStack {
                                Button {
                                    color_theme = "Moonlit Serenity"
                                } label: {
                                    Circle()
                                        .foregroundColor(.moonlitSerenitySteelBlue)
                                        .frame(height: 30)
                                }
                                Button {
                                    color_theme = "Soothing Night"
                                } label: {
                                    Circle()
                                        .foregroundColor(.soothingNightAccentBlue)
                                        .frame(height: 30)
                                }
                                Button {
                                    color_theme = "Tranquil Mist"
                                } label: {
                                    Circle()
                                        .foregroundColor(.tranquilMistTealBlue)
                                        .frame(height: 30)
                                }
                                Button {
                                    color_theme = "Dreamy Twilight"
                                } label: {
                                    Circle()
                                        .foregroundColor(.dreamyTwilightLavenderPurple)
                                        .frame(height: 30)
                                }
                                Button {
                                    color_theme = "Nightfall Harmony"
                                } label: {
                                    Circle()
                                        .foregroundColor(.nightfallHarmonyRoyalPurple)
                                        .frame(height: 30)
                                }
                            }

                            Spacer().frame(height:30)
                        }

                        Button {
                            showImagePicker.toggle()
                        } label : {
                            Image(.userprofileimage)
                            .resizable()
                            .frame(width:90, height, alignment: .center)

                        }.hSpacing(.center)
                        .vSpacing(.center)
                        .photosPicker(isPresented: $showImagePicker, selection: $selectedPhoto)
                        .onChange(of: selectedPhoto) { newValue in
                            if let newValue {
                                Task{
                                    if let rawImageData = try? await newValue.loadTransferable(type: Data.self), let image = UIImage(data: rawImageData), let compressedImageData = image.jpegData(compressionQuality: 0.5) {
                                        await MainActor.run(body: {
                                            userImageData = compressedImageData
                                            selectedPhoto = nil
                                        })
                                    }
                                }
                            }
                        }
                        //Shows Full Name
                        Text("\(fullname)")
                            .font(.system(size: 25))
                            .fontWeight(.medium)
                            .padding()

                        // Username Field
                        Text("Username: \(myusername)")
                            .padding()
                            .font(.system(size: 17)).fontWeight(.medium).frame(width: 300, height: 40, alignment: .leading).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(5)

                        // Email
                        Text("Email: \(myemail)")
                            .padding()
                            .font(.system(size: 17)).fontWeight(.medium).frame(width: 300, height: 40, alignment: .leading).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(5)

                        // Reset Password Button
                        NavigationLink(destination: ResetPasswordView()){
                            HStack{
                                Text("Reset Password")
                                    .padding()
                                Spacer()
                                Image(systemName:
                                        "arrow.right")
                                .padding()
                            }
                            .font(.system(size: 17)).fontWeight(.medium).frame(width: 300, height: 40, alignment: .leading).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(5)
                        }

                        //Notification Toggle
                        Toggle(isOn: $toggleIsOn, label: {Text ("Notifications")})
                            .toggleStyle(SwitchToggleStyle(tint: .moonlitSerenityCharcoalGray))
                            .padding().frame(width:300, height: 40)
                            .fontWeight(.medium)
                            .background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(5)
                        //TODO: need to enable push notifications

                        // Bio Button
                        NavigationLink(destination: BioInfoView()){
                            HStack{
                                Text("Bio")
                                    .padding()
                                Spacer()
                                Image(systemName:
                                        "arrow.right")
                                .padding()
                            }
                            .font(.system(size: 17)).fontWeight(.medium).frame(width: 300, height: 40, alignment: .leading).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(5)
                        }

                        // Rewards Page
                        NavigationLink(destination: ResetPasswordView()){
                            HStack{
                                Text("Rewards Dashboard")
                                    .padding()
                                Spacer()
                                Image(systemName:
                                        "arrow.right")
                                .padding()
                            }
                            .font(.system(size: 17)).fontWeight(.medium).frame(width: 300, height: 40, alignment: .leading).background(Color.tranquilMistAshGray).foregroundColor(.nightfallHarmonyNavyBlue).cornerRadius(5)
                        }
                    }
                    Spacer()

                //Menu Bar
                }.overlay(alignment: .bottom, content: {

                    HStack (spacing: 40){

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
                }.padding()
                .hSpacing(.center)
                .background(Color.dreamyTwilightMidnightBlue)

            })

            }.buttonStyle(PlainButtonStyle())

        }
    }

        func addProfilePicture() {
            showkeyboard = false
            isLoading = true

            //var user = get user

            if let userImageData = userImageData {
                storeImage(userID: user.getUserID()) { success in
                    // If image upload was successful ...
                    if success {
                        // Set imageURL
                        if let userImageURL = userImageURL {
                            user.setUserImageURL(imageURL: userImageURL)
                        }
                        // error?
                    } else {
                        print("Error! Could not upload image!")
                        return
                    }
                }
            } else {
                // Create post
                //newPost.createPost()
            }

            /*
            Task {
                do {

                } catch {
                    await errorAlerts(error)
                }
            }
            */
        }

        /*
         * Function to store image in Firebase Storage
         */
        func storeImage(userID: String, completion: @escaping (Bool) -> Void) {
            //Create reference to user bucket
            let storageRef = Storage.storage().reference()

            // Create a reference to the file you want to upload
            let userImageRef = storageRef.child("userImages/\(userID)/\(UUID().uuidString).jpg")

            // Upload image
            if let userImageData = userImageData {
                let uploadTask = userImageRef.putData(userImageData, metadata: nil) { (metadata, error) in
                    guard let metadata = metadata else {
                        // Error
                        completion(false)
                        return
                    }
                    // Metadata
                    let size = metadata.size
                    // URL
                    userImageRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            // Error
                            completion(false)
                            return
                        }
                        userImageURL = url
                        completion(true)
                    }
                }
            }
        }
}

struct BioInfoView: View {
    @State private var biotext = "Write your bio here!"
    private let data: [String] = ["Early Bird", "Night Owl"]
    private let preferenceColumns = [GridItem(.adaptive(minimum: 130))]
    @State private var sleepPreference = "Early Bird"
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.dreamyTwilightMidnightBlue.opacity(0.2), .nightfallHarmonyNavyBlue.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                        Text("Bio")
                        .font(Font.custom("NovaSquare-Bold", size: 40))
                            .frame(height: 2.0, alignment: .leading)
                            .padding()
                    Spacer().frame(height: 25)
                        Text("Add a brief description of yourself!")
                        .font(.system(size: 20))

                    Spacer().frame(height: 25)
                    TextField("\(biotext)",text: $biotext)
                        .padding()
                        .frame(width: 330, height: 200, alignment: .topLeading)
                        .background(.white.opacity(0.15))
                        .cornerRadius(10)
                    Spacer().frame(height: 40)

                    // Submit Bio button
                    Button ("Submit", action: {
                        // TODO: Store BIO in database
                    })
                    .font(.system(size: 20)).fontWeight(.medium).frame(width: 300, height: 50).background(Color.soothingNightLightGray.opacity(0.6)).foregroundColor(.nightfallHarmonyNavyBlue.opacity(1)).cornerRadius(10)

                    Spacer().frame(height: 60)
                    // Night Owl or Early Bird Question
                    Text("Night Owl or Early Bird?")
                        .font(Font.custom("NovaSquare-Bold", size: 25))
                    Spacer().frame(height: 30)

                    LazyVGrid(columns: preferenceColumns, spacing: 20) {
                        ForEach(data, id: \.self) { option in
                            Button(action: {
                                self.sleepPreference = option == self.sleepPreference ? "Early Bird" : option
                            }) {
                                Text(option)
                                    .padding().frame(width: 150, height: 50).foregroundColor(.white)
                            }

                            .background(self.sleepPreference == option ? Color.soothingNightLightGray.opacity(0.5) : Color.nightfallHarmonyRoyalPurple.opacity(0.8))
                            .cornerRadius(10)
                        }
                        // TODO: Store night owl early bird preference
                    }
                }

            }
        }
    }
}


#Preview {
    AccountInfoView()
}
