//
//  Constants.swift
//  ShobuTenTen
//
//  Created by Ryan Kanno on 8/9/21.
//

import UIKit

struct Constants {
   private init() {}
   // MARK: - User Defaults
   static let defaults = UserDefaults.standard
   static var isOnboarded = "IsOnboarded" // Bool
   static var soundOn = "SoundOn" // Bool
   static let gameTimeKey = "GameTime" // Int
   static let savedSong = "Samurai" // String
   static let savedSound = "Sword" // String
   
   // MARK: - Segues
   static let segues = ["ToTapBattleVC", "ToSwipeBattleVC"]   
   
   // MARK: - Game variables
   static var songDataSource = ["Samurai", "Arcade", "Retro"]
   static let soundDataSource = ["Sword", "Pop"]
   static let timeDataSource = ["5 seconds", "10 seconds", "15 seconds"]
   static let dataSources = [songDataSource, soundDataSource, timeDataSource]
   
   static let winner = "Winner!"
   static let loser = "Better luck next time!"
   static let tie = "Tie!"   
}
