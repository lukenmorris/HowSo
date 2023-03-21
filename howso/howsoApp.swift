//
//  howsoApp.swift
//  howso
//
//  Created by Luke Morris on 5/15/22.
//

import SwiftUI

@main
struct howsoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(authService())
            //ContentView().environmentObject(service)
        }
    }
}
