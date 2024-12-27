//
//  Takeit_SwiftUIApp.swift
//  Takeit SwiftUI
//
//  Created by 小田桐健太郎 on 2024/12/03.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct Takeit_SwiftUIApp: App {
    // register app delegate for Firebase setup
      @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


      var body: some Scene {
        WindowGroup {
          NavigationView {
            ContentView()
          }
        }
      }
}
