//
//  GetStartedView.swift
//  howso
//
//  Created by Luke Morris on 7/13/22.
//

import SwiftUI

struct GetStartedView: View {
    @EnvironmentObject var authViewModel : authService
    @Environment(\.presentationMode) var presentationMode
    @State private var isLoginViewActive = false
    let primaryYellow = Color(red: 255/255, green: 155/255, blue: 41/255)
    var body: some View {
        GeometryReader { geo in
            Spacer()
            VStack {
                VStack {
                    Image("clipartstart")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width / 1.05, height: UIScreen.main.bounds.width)
                        .padding()
                    Text("Welcome")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(width: UIScreen.main.bounds.width / 1.125, alignment: .leading)
                    Text("to HowSo")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .frame(width: UIScreen.main.bounds.width / 1.125, alignment: .leading)
                    Text("Discover how other people think with anonymity and randomness.")
                        .fontWeight(.light)
                        .frame(width: UIScreen.main.bounds.width / 1.125, height: 50, alignment: .leading)
                        .padding(.bottom)
                    NavigationLink(destination: LoginView().environmentObject(authViewModel), isActive: $isLoginViewActive) {
                        Text("").hidden()
                    }
                }
                .padding(.bottom)
                .background(Image("backgroundstart").resizable().scaledToFill().frame(maxWidth: .infinity, maxHeight: .infinity).ignoresSafeArea(.all))
                Spacer()
                VStack {
                    Button(action: {
                        isLoginViewActive = true
                    }) {
                        Text("GET STARTED")
                            .fontWeight(.bold)
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding()
                    }
                    .background(Color("primaryYellow"))
                    .cornerRadius(35)
                    .padding()
                    .clipShape(Capsule())
                    
                    Text("By pressing the button above, you certify that you are 13+ years of age and agree to our terms of use.")
                        .font(.footnote)
                        .fontWeight(.thin)
                        .frame(width: UIScreen.main.bounds.width / 1.125, height: 50, alignment: .leading)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
           // NavigationLink(destination: LoginView().navigationBarTitle("", displayMode: .inline)) {
        }
    }
}

/*struct GetStartedView_Previews: PreviewProvider {
    static var previews: some View {
        GetStartedView()
            
    }
}*/
