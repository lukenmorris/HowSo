//
//  AppDelegate.swift
//  howso
//
//  Created by Luke Morris on 12/31/22.
//

import UIKit
import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
      let appearance = UINavigationBarAppearance()
      appearance.configureWithOpaqueBackground()
      appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
      appearance.backgroundColor = .systemYellow
      UINavigationBar.appearance().tintColor = .systemYellow
      UINavigationBar.appearance().standardAppearance = appearance
      UINavigationBar.appearance().scrollEdgeAppearance =       UINavigationBar.appearance().standardAppearance
      UINavigationBar.appearance().prefersLargeTitles = false
      UINavigationBar.appearance().compactAppearance = appearance
      UINavigationBar.appearance().backIndicatorImage = UIImage(systemName: "arrow.left")
      UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.left")
      UIBarButtonItem.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).tintColor = .black
      UINavigationBar.appearance().tintColor = UIColor.black
      UINavigationBarAppearance().backButtonAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 40, vertical: 0)
      UIBarButtonItem.appearance().setTitleTextAttributes([
          NSAttributedString.Key.foregroundColor: UIColor.clear
      ], for: .normal)
      if #available(iOS 15.0, *) {
          let appearance = UITabBarAppearance()
          UITabBar.appearance().scrollEdgeAppearance = appearance
      }
    return true
  }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    }
}
