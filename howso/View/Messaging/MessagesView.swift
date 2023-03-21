//
//  MessagesView.swift
//  howso
//
//  Created by Luke Morris on 2/16/23.
//

import SwiftUI

struct MessagesView: View {
    @ObservedObject private var messageModel = messageService()
    var body: some View {
        VStack(spacing: 30) {
            /*ForEach(messageModel.conversations, id: \.id) { Post in
                PostView(post: Post)
                    .transition(.move(edge: .bottom))
            }*/
        }
        .padding()
    }
}

struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MessagesView()
    }
}
