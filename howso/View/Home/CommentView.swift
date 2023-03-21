//
//  CommentView.swift
//  howso
//
//  Created by Luke Morris on 1/16/23.
//

import SwiftUI

struct CommentView: View {
    @ObservedObject private var commentModel = commentService()
    var comment: Comment
    @State private var commentAuthor: User?
    var body: some View {
        VStack {
            HStack {
                Image("default-pic")
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .leading)
                    .padding(.bottom)
                VStack {
                    HStack {
                        Text(commentAuthor?.username ?? "")
                            .bold()
                            .frame(alignment: .leading)
                        Spacer()
                        let date = RelativeDateTimeFormatter().localizedString(for: comment.postedOn, relativeTo: Date.now)
                        Text(date)
                            .frame(alignment: .trailing)
                    }
                    .onAppear() {
                        Task {
                            self.commentAuthor = try await commentModel.getCommentAuthor(userID: comment.postedBy)!
                        }
                    }
                    .frame(maxWidth: .infinity)
                    HStack {
                        Text(comment.commentText)
                        Spacer()
                    }
                    HStack {
                        Button(action: {
                            // button action
                        }) {
                            Text("Reply")
                                .font(.callout)
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(alignment: .leading)
                }
            }
        }
        .padding()
        .background(Color.green.opacity(0.25))
        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
    }
}

/*struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView()
    }
}
*/
