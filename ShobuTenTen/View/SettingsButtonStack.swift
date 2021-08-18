//
//  SettingsButtonStack.swift
//  ShobuTenTen
//
//  Created by Ryan Kanno on 8/14/21.
//

import UIKit
import DropDown

class SettingsButtonStack: UIStackView {
   
   let songButton = SettingsButton(buttonTitle: "Song")
   let soundButton = SettingsButton(buttonTitle: "Sound")
   let timeButton = SettingsButton(buttonTitle: "Time")
   let toggleSoundButton = SettingsButton(buttonTitle: "Sound on")
   var buttons = [SettingsButton]()
   
   let songDropDown = DropDown()
   let soundDropDown = DropDown()
   let timeDropDown = DropDown()
   var dropDowns = [DropDown]()
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      self.axis = .vertical
      self.spacing = 40
      self.alignment = .center
      self.distribution = .fillEqually
      self.alpha = 1
      self.isHidden = false
      self.clipsToBounds = true
      self.translatesAutoresizingMaskIntoConstraints = false
      self.isUserInteractionEnabled = true
      buttons = [songButton, soundButton, timeButton, toggleSoundButton]
      dropDowns = [songDropDown, soundDropDown, timeDropDown]
      addArrangedButtons()
      addGestureRecognizers()
      // setupDropDowns must be done after constraints are set in the parent view
   }
   
   required init(coder: NSCoder) {
      fatalError()
   }
   
   private func addArrangedButtons() {
      buttons.forEach { button in
         self.addArrangedSubview(button)
         button.widthAnchor.constraint(
            equalTo: self.widthAnchor,
            multiplier: 1).isActive = true
      }
   }
   
   private func addGestureRecognizers() {
      let tapGestureRecognizers = [
         UITapGestureRecognizer(target: self, action: #selector(chooseSongTapped)),
         UITapGestureRecognizer(target: self, action: #selector(chooseSoundEffectTapped)),
         UITapGestureRecognizer(target: self, action: #selector(chooseTimeTapped)),
         UITapGestureRecognizer(target: self, action: #selector(toggleSound))
      ]
      for i in 0..<buttons.count {
         buttons[i].addGestureRecognizer(tapGestureRecognizers[i])
      }      
   }
   
   public func setupDropDowns() {
      for i in 0..<dropDowns.count {
         dropDowns[i].dataSource = Constants.dataSources[i]
         dropDowns[i].anchorView = buttons[i]
         dropDowns[i].isHidden = false
         dropDowns[i].cellHeight = self.frame.height
         dropDowns[i].direction = .any
         dropDowns[i].cornerRadius = 8
         dropDowns[i].textColor = .white
         dropDowns[i].backgroundColor = .systemGreen
         dropDowns[i].selectionBackgroundColor = .systemGreen
         dropDowns[i].separatorColor = .white
         dropDowns[i].textFont = UIFont(name: "Chalkboard SE", size: 40) ?? .systemFont(ofSize: 40)
         dropDowns[i].bottomOffset = CGPoint(x: 0, y: (dropDowns[i].anchorView?.plainView.bounds.height)!)
         dropDowns[i].customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) in
            cell.optionLabel.textAlignment = .center
         }
      }
   }
   
   @objc private func chooseSongTapped() {
      print(#function)
      songDropDown.show()
      songDropDown.selectionAction = { [weak self] (index: Int, item: String) in
         guard let _ = self else { return }
         Constants.defaults.setValue(item, forKey: Constants.savedSong)
         SoundManager.shared.changeAudio()
      }
   }
   
   @objc private func chooseSoundEffectTapped() {
      print(#function)
      soundDropDown.show()
      soundDropDown.selectionAction = { [weak self] (index: Int, item: String) in
         guard let _ = self else { return }
         Constants.defaults.setValue(item, forKey: Constants.savedSound)
         SoundManager.shared.playAttackSound()
      }
   }
   
   @objc private func chooseTimeTapped() {
      print(#function)
      timeDropDown.show()
      timeDropDown.selectionAction = { [weak self] (index: Int, item: String) in
         guard let _ = self else { return }
         Constants.defaults.setValue(item, forKey: Constants.gameTimeKey)
      }
   }
   
   @objc private func toggleSound() {
      print(#function)
      if Global.shared.soundIsOn {
         Constants.defaults.setValue(false, forKey: Constants.soundOn)
         toggleSoundButton.backgroundColor = .systemRed
         toggleSoundButton.setTitle("Sound off", for: .normal)
      } else {
         Constants.defaults.setValue(true, forKey: Constants.soundOn)
         toggleSoundButton.backgroundColor = .systemGreen
         toggleSoundButton.setTitle("Sound on", for: .normal)
      }
   }
}

