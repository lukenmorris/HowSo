//
//  PostView.swift
//  howso
//
//  Created by Luke Morris on 5/23/22.
//

import SwiftUI
import SwiftDate

struct PostView: View {
    @State var post: Post
    @State var resultsHidden: Bool = true
    @State var userAgreed: Bool = false
    @State var userDisagreed: Bool = false
    @State var progressValue: Float = 0.0
    @State var redValue: Float = 0.0
    @State var greenValue: Float = 0.0
    @State var presentPopup = false
    @State var isCommentViewActive = false
    @State var isReportPostViewActive = false
    @State var agreeExists = true
    @State var disagreeExists = true
    @State var agreeReaction = false
    @State var disagreeReaction = false
    @State var clickOnReaction = false
    @State private var postAuthor: User?
    @State var isReportViewActive = false
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var postModel = postService()
    @ObservedObject private var commentModel = commentService()
    let primaryYellow = Color(red: 255/255, green: 231/255, blue: 111/255)
    var body: some View {
        VStack(alignment: .leading) {
            let date = RelativeDateTimeFormatter().localizedString(for: post.createdOn , relativeTo: Date.now)
            Text(date)
                .font(.caption)
            Text(post.statement)
                .bold()
                .multilineTextAlignment(.center)
            HStack {
                Image("default-pic")
                    .resizable()
                    .frame(width: 30, height: 30)
                Text(postAuthor?.username ?? "")
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            VStack {
                if clickOnReaction {
                    if agreeExists {
                        GreenProgressBar(value: $progressValue).frame(maxWidth: .infinity).padding(.bottom)
                            .padding(.bottom)
                    } else {
                        RedProgressBar(value: $progressValue).frame(maxWidth: .infinity).padding(.bottom)
                            .padding(.bottom)
                    }
                } else if agreeExists {
                    GreenProgressBar(value: $greenValue).frame(maxWidth: .infinity).padding(.bottom)
                        .padding(.bottom)
                        .transition(.scale)
                } else if disagreeExists {
                    HStack {
                        RedProgressBar(value: $redValue).frame(maxWidth: .infinity).padding(.bottom)
                    }
                    .padding(.bottom)
                    .transition(.scale)
                } else {
                    HStack {
                        Button(action: {
                            Task {
                                await postModel.agreePost(postID: post.id!)
                            }
                            post.agreeCount = post.agreeCount + 1
                            clickOnReaction = true
                            agreeExists = true
                            startProgressBar()
                        }) {
                            Text("👍")
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                                .padding()
                                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                        }
                        Spacer()
                        Button(action: {
                            Task {
                                await postModel.disagreePost(postID: post.id!)
                            }
                            post.disagreeCount = post.disagreeCount + 1
                            withAnimation(.easeIn(duration: 2)) {
                                clickOnReaction = true
                                disagreeExists = true
                            }
                            startProgressBar()
                        }) {
                            Text("👎")
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                                .padding()
                                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                        }
                    }
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                }
            }
            .padding(.bottom)
            .padding(.leading)
            .padding(.trailing)
            Divider()
            HStack {
                HStack {
                    if post.commentCount == 1 {
                        Text("\(post.commentCount) comment")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        Text("\(post.commentCount) comments")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                Spacer()
                HStack {
                    Button(action: {
                        commentModel.comments.removeAll()
                        isCommentViewActive = true
                    }) {
                        Image(systemName: "bubble.left.fill")
                            .foregroundStyle(
                                .linearGradient(colors: [Color("primaryYellow"), .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    .opacity(0.75))
                    }
                    Menu {
                        Button("Report", action: {
                            isReportPostViewActive = true
                        })
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(
                                .linearGradient(colors: [Color("primaryYellow"), .orange], startPoint: .topLeading, endPoint: .bottomTrailing)
                                    .opacity(0.75))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .sheet(isPresented: $isCommentViewActive) {
            PostFullView(post: post, isCommentViewActive: $isCommentViewActive)
                .task {
                    await postModel.addView(postID: post.id ?? "")
                }
        }
        .sheet(isPresented: $isReportPostViewActive) {
            ReportPostView(post: post)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .task {
            if await postModel.checkIfAgreeExists(postID: post.id ?? "") == false {
                self.agreeExists = false
            }
            if await postModel.checkIfDisagreeExists(postID: post.id ?? "") == false{
                self.disagreeExists = false
            }
        }
        .onAppear() {
            Task {
                try await self.postAuthor = postModel.getPostAuthor(userID: post.createdBy)
                calcPercentage()
            }
        }
        .background(.white)
        /*.background(
            LinearGradient(
                colors: [Color("primaryYellow"), .orange], startPoint: .topLeading, endPoint: .bottomTrailing).opacity(0.75))*/
        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous)).shadow(radius: 10)
    }
    func startProgressBar() {
        if disagreeExists {
            Timer.scheduledTimer(withTimeInterval: 0.015, repeats: true) {
                timer in
                self.progressValue += 0.01
                if self.progressValue >= redValue {
                    timer.invalidate()
                }
            }
        } else {
            Timer.scheduledTimer(withTimeInterval: 0.015, repeats: true) {
                timer in
                self.progressValue += 0.01
                if self.progressValue >= greenValue {
                    timer.invalidate()
                }
            }
        }
    }
    func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let newDateString = dateFormatter.string(from: post.createdOn)
        return newDateString
    }
    func calcPercentage() {
        if agreeExists {
            self.greenValue = Float(post.agreeCount)/Float(post.reactionCount)
        } else {
            self.redValue = Float(post.disagreeCount)/Float(post.reactionCount)
        }
    }
}

struct RedProgressBar: View {
    @Binding var value: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 25)
                    .opacity(0.75)
                    .foregroundColor(Color(.systemGreen))
                    .overlay(
                        Text("👍")
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                            .padding())
                RoundedRectangle(cornerRadius: 25).frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width))
                    .foregroundColor(Color(.systemRed))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .overlay(
                        Text("👎")
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                            .padding())
            }
            .frame(height: 50)
        }
    }
}

struct GreenProgressBar: View {
    @Binding var value: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 25)
                    .opacity(0.75)
                    .foregroundColor(Color(.systemRed))
                    .overlay(
                        Text("👎")
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                            .padding())
                RoundedRectangle(cornerRadius: 25).frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width))
                    .foregroundColor(Color(.systemGreen))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .overlay(
                        Text("👍")
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                            .padding())
            }
            .frame(height: 50)
        }
    }
}

/*struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: post.totalCount = 5, post.agreeCount = 5, post.createdOn = )
    }
}*/
