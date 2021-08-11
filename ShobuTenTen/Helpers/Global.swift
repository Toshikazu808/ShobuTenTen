//
//  Global.swift
//  ShobuTenTen
//
//  Created by Ryan Kanno on 8/10/21.
//

import Foundation

final class Global {
   private init() {}
   static let shared = Global()
   
   var soundIsOn: Bool {
      return Constants.defaults.bool(forKey: Constants.soundOn)
   }
   var currentSong: String {
      return Constants.defaults.string(forKey: Constants.savedSong) ?? "Samurai"
   }
   var currentSound: String {
      return Constants.defaults.string(forKey: Constants.savedSound) ?? "Sword"
   }
}
