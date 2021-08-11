//
//  SoundManager.swift
//  ShobuTenTen
//
//  Created by Ryan Kanno on 8/9/21.
//

import Foundation
import AVFoundation
import UserNotifications

final class SoundManager {
   static let shared = SoundManager()
   private init() {}
   private var songPlayer: AVAudioPlayer?
   private var effectLayer0: AVAudioPlayer?
   private var effectLayer1: AVAudioPlayer?
   private var effectLayer2: AVAudioPlayer?
   private var effectLayer3: AVAudioPlayer?
   private var effectLayer4: AVAudioPlayer?
   private var soundEffectRotater = 0
   
   let center = UNUserNotificationCenter.current()
   let songDidEnd = NSNotification.Name.AVPlayerItemDidPlayToEndTime
   let notify = NotificationCenter.default
   private var timer = Timer()
   private let songTimeIntervals: [String: TimeInterval] = [
      "Samurai": 149,
      "Arcade": 184,
      "Retro": 220
   ]
      
   public func changeAudio() {
      if Global.shared.soundIsOn {
         playMusic()
      } else {
         stopMusic()
         center.removeAllPendingNotificationRequests()
         timer.invalidate()
      }
   }
   
   @objc private func playMusic() {
      timer = Timer.scheduledTimer(
         timeInterval: 0,
         target: self,
         selector: #selector(playMp3),
         userInfo: nil,
         repeats: false)
   }
   
   @objc private func playMp3() {
      if let url = Bundle.main.url(forResource: Global.shared.currentSong, withExtension: "mp3") {
         let song = AVPlayerItem(url: url)
         do {
            songPlayer = try AVAudioPlayer(contentsOf: url)
            songPlayer?.play()
            notify.addObserver(self, selector: #selector(playMusic), name: songDidEnd, object: song)
         } catch let error {
            print("Error playing song: \(error)")
         }
      } else {
         print("Unable to create url for song: \(Global.shared.currentSong)")
      }
   }
   
   private func stopMusic() {
      songPlayer?.stop()
      timer.invalidate()
   }
      
   public func playAttackSound() {
      if Global.shared.soundIsOn {
         soundEffectRotater += 1
         if soundEffectRotater > 4 {
            soundEffectRotater = 0
         }
         switch soundEffectRotater {
         case 0:
            playSoundLayer0()
         case 1:
            playSoundLayer1()
         case 2:
            playSoundLayer2()
         case 3:
            playSoundLayer3()
         case 4:
            playSoundLayer4()
         default:
            break
         }
      }
   }
   
   private func playSoundLayer0() {
      if let url = Bundle.main.url(forResource: Global.shared.currentSound, withExtension: "m4a") {
         do {
            effectLayer0 = try AVAudioPlayer(contentsOf: url)
            effectLayer0?.play()
         } catch let error {
            print("Error playing sound effect: \(error)")
         }
      } else {
         print("Unable to create url for sound: \(Global.shared.currentSound)")
      }
   }
   
   private func playSoundLayer1() {
      if let url = Bundle.main.url(forResource: Global.shared.currentSound, withExtension: "m4a") {
         do {
            effectLayer1 = try AVAudioPlayer(contentsOf: url)
            effectLayer1?.play()
         } catch let error {
            print("Error playing sound effect: \(error)")
         }
      } else {
         print("Unable to create url for sound: \(Global.shared.currentSound)")
      }
   }
   
   private func playSoundLayer2() {
      if let url = Bundle.main.url(forResource: Global.shared.currentSound, withExtension: "m4a") {
         do {
            effectLayer2 = try AVAudioPlayer(contentsOf: url)
            effectLayer2?.play()
         } catch let error {
            print("Error playing sound effect: \(error)")
         }
      } else {
         print("Unable to create url for sound: \(Global.shared.currentSound)")
      }
   }
   
   private func playSoundLayer3() {
      if let url = Bundle.main.url(forResource: Global.shared.currentSound, withExtension: "m4a") {
         do {
            effectLayer3 = try AVAudioPlayer(contentsOf: url)
            effectLayer3?.play()
         } catch let error {
            print("Error playing sound effect: \(error)")
         }
      } else {
         print("Unable to create url for sound: \(Global.shared.currentSound)")
      }
   }
   
   private func playSoundLayer4() {
      if let url = Bundle.main.url(forResource: Global.shared.currentSound, withExtension: "m4a") {
         do {
            effectLayer4 = try AVAudioPlayer(contentsOf: url)
            effectLayer4?.play()
         } catch let error {
            print("Error playing sound effect: \(error)")
         }
      } else {
         print("Unable to create url for sound: \(Global.shared.currentSound)")
      }
   }
}
