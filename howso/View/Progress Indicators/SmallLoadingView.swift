//
//  SmallLoadingView.swift
//  howso
//
//  Created by Luke Morris on 1/21/23.
//

import SwiftUI

struct SmallLoadingView: View {
    @State private var isAnimating = false
    var body: some View {
        VStack {
            Image("logoWhite")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25).aspectRatio(contentMode: .fit)
                .rotationEffect(.degrees(isAnimating ? 360: 0))
                .onAppear {
                    DispatchQueue.main.async {
                        withAnimation(Animation.easeOut(duration: 0.5).delay(0.5).repeatForever(autoreverses: false)) {
                            self.isAnimating = true
                        }
                    }
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [Color("primaryYellow"), .orange], startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.75))
    }
}

struct SmallLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        SmallLoadingView()
    }
}
