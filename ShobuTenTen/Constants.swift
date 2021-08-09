//
//  Constants.swift
//  ShobuTenTen
//
//  Created by Ryan Kanno on 8/9/21.
//

import Foundation

struct Constants {
   static let defaults = UserDefaults.standard
   static let gameTimeKey = "GameTime" // Save as Int
   static let volumeKey = "Volume" // Save as Bool
   static var gameTime = 10
   static var timer = Timer()
   static let dropDownDataSource = ["5 seconds", "10 seconds", "15 seconds"]

   static func evaluateScores() {
      
   }
}
