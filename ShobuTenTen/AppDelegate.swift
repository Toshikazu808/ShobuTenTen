//
//  AppDelegate.swift
//  ShobuTenTen
//
//  Created by Ryan Kanno on 8/8/21.
//

import UIKit

   @main
class AppDelegate: UIResponder, UIApplicationDelegate {
   
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      // Override point for customization after application launch.
      setInitialDefaults()
      return true
   }

   // MARK: UISceneSession Lifecycle

   func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
      // Called when a new scene session is being created.
      // Use this method to select a configuration to create the new scene with.
      return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
   }

   func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
      // Called when the user discards a scene session.
      // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
      // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
   }
   
   private func setInitialDefaults() {
      if !Constants.defaults.bool(forKey: Constants.isOnboarded) {
         Constants.defaults.setValue(true, forKey: Constants.isOnboarded)
         Constants.defaults.setValue(true, forKey: Constants.soundOn)
         Constants.defaults.setValue("Samurai", forKey: Constants.savedSong)
         Constants.defaults.setValue("Sword", forKey: Constants.savedSound)
         Constants.defaults.setValue("5 seconds", forKey: Constants.gameTimeKey)
      }
   }
}

