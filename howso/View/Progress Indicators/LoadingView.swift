//
//  LoadingView.swift
//  howso
//
//  Created by Luke Morris on 1/10/23.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    var body: some View {
        VStack {
            Spacer()
            Image("logoWhite")
                .resizable()
                .frame(width: 150, height: 150).padding(40).aspectRatio(contentMode: .fit)
                .rotationEffect(.degrees(isAnimating ? 360: 0))
                .onAppear {
                    withAnimation(Animation.easeOut(duration: 0.5).delay(0.5).repeatForever(autoreverses: false)) {
                        self.isAnimating = true
                    }
                }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(LinearGradient(colors: [Color("primaryYellow"), .orange], startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.75))
        .ignoresSafeArea()
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
