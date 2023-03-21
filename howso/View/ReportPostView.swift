//
//  ReportPostView.swift
//  howso
//
//  Created by Luke Morris on 3/20/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct ReportPostView: View {
    @ObservedObject private var ReportModel = reportService()
    var post: Post
    var body: some View {
        VStack {
            Text("Why are you reporting this post?")
                .font(.title2)
            Text("Please select the most relevant option.")
                .font(.caption)
        }
        .padding()
        .frame(maxWidth: .infinity)
        VStack {
            HStack {
                Button(action: {
                    Task {
                        await ReportModel.reportPost(postReport: PostReport(post: post, createdOn: Date(), createdBy: Auth.auth().currentUser!.uid, reason: "Harassment and/or hateful speech"))
                    }
                }, label: {
                    Text("Harassment and/or hateful speech")
                })
                .padding()
                .frame(maxWidth: .infinity)
                Spacer()
            }
            HStack {
                Button(action: {
                    Task {
                        await ReportModel.reportPost(postReport: PostReport(post: post, createdOn: Date(), createdBy: Auth.auth().currentUser!.uid, reason: "Spam"))
                    }
                }, label: {
                    Text("Spam")
                })
                .padding()
                .frame(maxWidth: .infinity)
                Spacer()
            }
            HStack {
                Button(action: {
                    Task {
                        await ReportModel.reportPost(postReport: PostReport(post: post, createdOn: Date(), createdBy: Auth.auth().currentUser!.uid, reason: "Violence or physical harm"))
                    }
                }, label: {
                    Text("Violence or physical harm")
                })
                .padding()
                .frame(maxWidth: .infinity)
                Spacer()
            }
            HStack {
                Button(action: {
                    Task {
                        await ReportModel.reportPost(postReport: PostReport(post: post, createdOn: Date(), createdBy: Auth.auth().currentUser!.uid, reason: "Adult content"))
                    }
                }, label: {
                    Text("Adult content")
                })
                .padding()
                .frame(maxWidth: .infinity)
                Spacer()
            }
            HStack {
                Button(action: {
                    Task {
                        await ReportModel.reportPost(postReport: PostReport(post: post, createdOn: Date(), createdBy: Auth.auth().currentUser!.uid, reason: "Other"))
                    }
                }, label: {
                    Text("Other")
                })
                .padding()
                .frame(maxWidth: .infinity)
                Spacer()
            }
        }
        .navigationTitle("Report Post")
    }
}
