//
//  NavigationView.swift
//  howso
//
//  Created by Luke Morris on 5/23/22.
//

import SwiftUI

struct NavigationViewer: View {
    var body: some View {
        NavigationView {
            Text("Questions Here")
                .navigationBarTitle(Text("HowSo")
                    .font(.largeTitle)
                    .fontWeight(.bold), displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                    Button(action:{
                            // insert settings view here
                            print("Work in Progress")
                        }, label: {
                            Image(systemName: "gearshape.circle.fill")
                                .foregroundColor(Color(.systemGray))
                        })
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action:{
                            // insert hot/recent view here
                            print("Work in Progress")
                    }, label: {
                        Image(systemName: "flame.circle.fill")
                            .foregroundColor(Color(.systemOrange))
                    })
                }
            }
        }
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView()
    }
}
