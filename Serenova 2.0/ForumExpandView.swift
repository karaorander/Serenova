//
//  ForumExpandView.swift
//  Serenova 2.0
//
//  Created by Wilson, Caitlin Vail on 3/21/24.
// Shows a post in fullscreen when a user clicks on a post

import Foundation

import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage

//Create New Post View
struct ForumPostView: View {
    /// callback
    //var onPos: (Post)->()
    
    @State var postText: String = ""
    @State var postTitle: String = ""
    @State var postImageData: Data?
    @State var postImageURL: URL?
    
    ///use app storage to get user data from firebase.  EX:
    //@AppStorage("userName") var userName: String = ""
    @State private var isLoading:Bool = false
    @State private var showError:Bool = false
    @State private var showCamera:Bool = false
    @State private var errorMess: String = ""
    @State private var showImagePicker: Bool = false
    @State private var selectedPhoto: PhotosPickerItem?
    @FocusState private var showkeyboard: Bool
    
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationView{
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [.nightfallHarmonySilverGray.opacity(0.9), .nightfallHarmonyRoyalPurple.opacity(0.5), .dreamyTwilightMidnightBlue.opacity(0.7), .nightfallHarmonyNavyBlue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Menu {
                          
                        } label: {
                            NavigationLink(destination: ForumView().navigationBarBackButtonHidden(true)) {
                                Text("Back").font(.callout).foregroundColor(Color.nightfallHarmonyNavyBlue)
                            }
                        }.hSpacing(.leading)
                        
                        .disabled(postText == "" || postTitle == "")
                        .opacity((postText == "" || postTitle == "") ? 0.4 : 1)
                    }.padding(.horizontal, 15).padding(.vertical, 10)
                        .background{
                            Rectangle()
                                .fill(.white.opacity(0.1))
                                .ignoresSafeArea()
                        }
                    ScrollView(.vertical, showsIndicators:false) {
                        VStack(spacing: 15){
                            HStack {
                                TextField(postTitle)
                                    .fontWeight(.bold)
                    
                                    
                            }.padding()
                                .background(.gray.opacity(0.15))
                                .cornerRadius(10)
                            HStack {
                                TextField(postText)
                            }.padding()
                                .background(.gray.opacity(0.15))
                                .cornerRadius(10)
                            if let postImageData, let image = UIImage(data: postImageData) {
                                GeometryReader{
                                    let size = $0.size
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width:size.width, height: size.height)
                                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                        .overlay(alignment: .topTrailing) {
                                            Button {
                                                withAnimation(.easeInOut(duration:0.25)) {
                                                    self.postImageData = nil
                                                }
                                            } label: {
                                                Image(systemName: "trash").font(.system(size: 20, weight: .bold))
                                                    .foregroundColor(.red)
                                                    .background(.white.opacity(0.5)).cornerRadius(5)
                                            }
                                            .padding(10)
                                        }
                                    
                                }.clipped()
                                    .frame(height: 220)
                            } else {
                                Spacer()
                                Button {
                                    showImagePicker.toggle()
                                }label : {
                                    Image(systemName: "photo")
                                        
                                        .foregroundColor(.soothingNightLightGray)
                                        .font(.system(size: 200))
                                        .background(.white.opacity(0.1))
                                        .cornerRadius(10)
                                        
                                }.hSpacing(.center)
                                    .vSpacing(.center)
                                    
                                
                                    
                            }
                        }.padding(15)
                        
                    }
                    Divider()
                    HStack {
                        NavigationLink(destination: ForumView().navigationBarBackButtonHidden(true)) {
                            Button("Done") {
                            }.foregroundColor(.white)
                        }
                    }.padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background{
                            Rectangle()
                                .fill(.white.opacity(0.1))
                                .ignoresSafeArea()
                        }
                }.vSpacing(.top)
                    
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
    
    }
    
    /*
     * Function to store image in Firebase Storage
     */
    func storeImage(postID: String) async throws {
        //Create reference to postMedia bucket
        let storageRef = Storage.storage().reference()
        
        // Create a reference to the file you want to upload
        let postImageRef = storageRef.child("postMedia/\(postID)/\(UUID().uuidString).jpg")

        // Upload image
        if let postImageData = postImageData {
            try await postImageRef.putDataAsync(postImageData)
            try await postImageURL = postImageRef.downloadURL()
        }
    }
}


#Preview {
    ForumPostView()
}

//TODO: Add comments section for other users
