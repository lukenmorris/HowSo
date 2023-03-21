//
//  Verification.swift
//  howso
//
//  Created by Luke Morris on 7/16/22.
//

import SwiftUI
import Combine

struct VerificationView: View {
    @State var loginData : authService
    @Environment(\.presentationMode) var presentationMode
    @State private var isPerformingTask = false
    @StateObject var keyService = verifyKeyService()
    @State var cooldownActive = false
    var body: some View {
        VStack{
            VStack{
                Text("Enter OTP Code")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Text("Code sent to \(loginData.phone_number)")
                    .foregroundColor(.gray)
                    .font(.callout)
                    .fontWeight(.light)
                    .padding(.bottom)
            }
            .padding()
            Spacer()
            OtpTextFieldView(phoneViewModel: loginData)
                .padding()
            Spacer()
            if loginData.timerExpired == true {
                HStack(spacing: 6){
                    
                    Text("Didn't receive code?")
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        loginData.code = ""
                        loginData.requestCode()
                        loginData.startTimer()
                    }) {
                        Text("Request Again")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                    .disabled(isPerformingTask)
                }
            } else {
                Text("Next request available in \(loginData.timeStr)")
                    .fontWeight(.semibold)
                    .onReceive(loginData.codeCooldownTimer) { _ in
                        loginData.countDownString()
                    }
            }
            
            if loginData.loading {
                ProgressView()
            } else {
                Button(action: {
                    loginData.verifyCode()
                }) {
                    Text("Verify")
                        .foregroundColor(.black)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 30)
                        .background(Color(.systemYellow))
                        .cornerRadius(15)
                        .opacity(isPerformingTask ? 0 : 1)
                }
                .disabled(isPerformingTask)
                .padding()
            }
        }
        .background(Color.white)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        if loginData.error{
            AlertView(msg: loginData.errorMsg, show: $loginData.error)
        }
    }
}

// getting Code At Each Index....

public struct OtpTextFieldView: View {
    enum FocusField: Hashable {
        case field
    }
    @ObservedObject var phoneViewModel: authService
    @FocusState private var focusedField: FocusField?
    
    init(phoneViewModel: authService) {
        self.phoneViewModel = phoneViewModel
    }
    
    private var backgroundTextField: some View {
        
        return TextField("", text: $phoneViewModel.code)
            .frame(width: 0, height: 0, alignment: .center)
            .font(Font.system(size: 0))
            .accentColor(.blue)
            .foregroundColor(.blue)
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .onReceive(Just(phoneViewModel.code)) { _ in phoneViewModel.limitText(6) }
            .focused($focusedField, equals: .field)
            .task {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
                {
                    self.focusedField = .field
                }
            }
            .padding()
    }
    
    public var body: some View {
        ZStack(alignment: .center) {
            backgroundTextField
            HStack {
                ForEach(0..<6) { index in
                    ZStack {
                        Text(phoneViewModel.getCode(index: index))
                            .font(Font.system(size: 27))
                            .fontWeight(.semibold)
                        Rectangle()
                            .frame(height: 2)
                            .padding(.trailing, 5)
                            .padding(.leading, 5)
                            .opacity(phoneViewModel.code.count <= index ? 1 : 0)
                    }
                }
            }
        }
    }
}

struct Verification_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView(loginData: authService()).environmentObject(authService())
            .previewDevice("iPhone 13 Pro Max")
    }
}
