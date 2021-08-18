//
//  SettingsButton.swift
//  ShobuTenTen
//
//  Created by Ryan Kanno on 8/14/21.
//

import UIKit

protocol SettingsButtonDelegate: AnyObject {
   func songTapped()
   func soundTapped()
   func timeTapped()
   func toggleSoundTapped()
}

final class SettingsButton: UIButton {
   weak var delegate: SettingsButtonDelegate?
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      self.titleLabel?.font = UIFont(name: "Chalkboard SE", size: 40) ?? .systemFont(ofSize: 40)
      self.setTitleColor(.white, for: .normal)
      self.backgroundColor = .systemGreen
      self.layer.cornerRadius = 8
      self.layer.borderWidth = 2.5
      self.layer.borderColor = UIColor.white.cgColor
      self.alpha = 0
      self.isHidden = true
      self.clipsToBounds = true
      self.translatesAutoresizingMaskIntoConstraints = false
      self.isUserInteractionEnabled = true
   }
   
   convenience init(buttonTitle: String) {
      self.init()
      self.setTitle(buttonTitle, for: .normal)
      addActions(per: buttonTitle)
   }
   
   required init?(coder: NSCoder) {
      fatalError()
   }
   
   private func addActions(per buttonTitle: String) {
      switch buttonTitle {
      case "Song":
         let songTapped = UITapGestureRecognizer(target: self, action: #selector(songTapped))
         self.addGestureRecognizer(songTapped)
      case "Sound":
         let songTapped = UITapGestureRecognizer(target: self, action: #selector(soundTapped))
         self.addGestureRecognizer(songTapped)
      case "Time":
         let songTapped = UITapGestureRecognizer(target: self, action: #selector(timeTapped))
         self.addGestureRecognizer(songTapped)
      case "Sound on", "Sound off":
         let songTapped = UITapGestureRecognizer(target: self, action: #selector(toggleSoundTapped))
         self.addGestureRecognizer(songTapped)
      default:
         break
      }
   }
   
   @objc private func songTapped() {
      delegate?.songTapped()
   }
   
   @objc private func soundTapped() {
      delegate?.soundTapped()
   }
   
   @objc private func timeTapped() {
      delegate?.timeTapped()
   }
   
   @objc private func toggleSoundTapped() {
      delegate?.toggleSoundTapped()
   }
}
