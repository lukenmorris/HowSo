//
//  ProfilePicView.swift
//  howso
//
//  Created by Luke Morris on 12/29/22.
//

import SwiftUI
import PhotosUI
import FirebaseStorage

struct ProfilePicView: View {
    @EnvironmentObject var loginData : authService
    @ObservedObject var storageManager = profilePictureService()
    @Environment(\.presentationMode) var presentationMode
    @State private var isPerformingTask = false
    @State private var isHomeViewActive = false
    @State var image: UIImage?
    @State private var showSheet = false
    
    var body: some View {
        NavigationView {
            NavigationLink(destination: HomeView(), isActive: $isHomeViewActive) {
                Text("").hidden()
            }
        }
        VStack {
            VStack {
                Text("Add a profile picture")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                if image != nil {
                    Image(uiImage: self.image!)
                        .resizable()
                        .cornerRadius(50)
                        .padding(.all, 4)
                        .frame(width: 250, height: 250)
                        .frame(maxHeight: .infinity)
                        .background(Color.black.opacity(0.2))
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .padding(8)
                        .onTapGesture {
                            showSheet = true
                        }
                } else {
                    Image("")
                        .resizable()
                        .cornerRadius(50)
                        .padding(.all, 4)
                        .frame(width: 250, height: 250)
                        .frame(maxHeight: .infinity)
                        .background(Color.black.opacity(0.2))
                        .aspectRatio(contentMode: .fill)
                        .clipShape(Circle())
                        .padding(8)
                        .onTapGesture {
                            showSheet = true
                        }
                }
            }
            Spacer()
            VStack {
                Button (action: {
                    storageManager.uploadProfilePicture(image: image!)
                }){
                    Text("Upload picture")
                        .font(.headline)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .frame(height: 50)
                        .background(LinearGradient(colors: [Color("primaryYellow"), .orange], startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.75))
                        .cornerRadius(16)
                        .foregroundColor(.white)
                }
                .disabled(self.image == nil)
                Button(action: {
                    Task {
                        loginData.authState = .logged
                        loginData.listenToAuthState()
                    }
                }) {
                    Text("Skip")
                        .fontWeight(.bold)
                        .padding()
                }
                if loginData.error {
                    AlertView(msg: loginData.errorMsg, show: $loginData.error)
                }
            }
            .frame(maxHeight: .infinity)
        }
        .sheet(isPresented: $showSheet) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
            }
        }

struct ProfilePicView_Previews: PreviewProvider {
    static var previews: some View {
            ProfilePicView().environmentObject(authService())
    }
}
