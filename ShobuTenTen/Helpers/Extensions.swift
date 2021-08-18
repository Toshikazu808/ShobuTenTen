//
//  Extensions.swift
//  ShobuTenTen
//
//  Created by Ryan Kanno on 8/9/21.
//

import UIKit
import DropDown

extension String {
   func getNumber() -> Int? {
      var num: Int?
      let pattern = #"(\d+)"#
      let regex = try! NSRegularExpression(pattern: pattern, options: [])
      if let match = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count)) {
         let newString = (self as NSString).substring(with: match.range)
         num = Int(newString)
      }
      return num
   }
}

extension UILabel {
   func pulsate() {
      let pulse = CASpringAnimation(keyPath: "transform.scale")
      pulse.duration = 0.2
      pulse.fromValue = 1
      pulse.toValue = 1.2
      pulse.autoreverses = true
      pulse.repeatCount = 0
      pulse.initialVelocity = 3
      pulse.damping = 1
      layer.add(pulse, forKey: nil)
   }
}

extension UIButton {
   func configureSettingsButton() {
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
}

extension UIViewController {
   
   func configureSettingsBackground(_ settingsBackground: SettingsBackgroundView) {
      self.view.addSubview(settingsBackground)
      settingsBackground.frame = self.view.frame
      settingsBackground.isHidden = false
      settingsBackground.alpha = 0.5
   }
   
   func configureSettingsStackView(stackView: UIStackView, buttons: [UIButton], dropDowns: [DropDown]) {
      self.view.addSubview(stackView)
      stackView.translatesAutoresizingMaskIntoConstraints = false
      stackView.clipsToBounds = true
      stackView.axis = .vertical
      stackView.spacing = 40
      stackView.alignment = .center
      stackView.isHidden = false
      stackView.alpha = 1
      NSLayoutConstraint.activate([
         stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
         stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
         stackView.widthAnchor.constraint(equalToConstant: 230)
      ])
      configureButtons(stackView, buttons)
//      configureDropDowns(dropDowns, buttons)
   }
   
   private func configureButtons(_ stackView: UIStackView, _ buttons: [UIButton]) {
      buttons.forEach { button in
         stackView.addArrangedSubview(button)
         button.isHidden = false
         button.alpha = 1
         button.translatesAutoresizingMaskIntoConstraints = false
         button.clipsToBounds = true
         button.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1).isActive = true
      }
   }
   
   private func configureDropDowns(_ dropDowns: [DropDown], _ buttons: [UIButton]) {
      for i in 0..<dropDowns.count {
         dropDowns[i].translatesAutoresizingMaskIntoConstraints = false
         dropDowns[i].dataSource = Constants.dataSources[i]
         dropDowns[i].anchorView = buttons[i]
         dropDowns[i].isHidden = false
         dropDowns[i].cellHeight = buttons[i].frame.height
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
   
   func toggleSettingsViews(showSettings: Bool, settingsBackground: SettingsBackgroundView, settingsStack: UIStackView, settingsButtons: [UIButton]) {
      if showSettings {
         settingsBackground.isHidden = true
         settingsStack.isHidden = true
         settingsButtons.forEach { button in
            button.isHidden = true
         }
      } else {
         settingsBackground.isHidden = false
         settingsStack.isHidden = false
         settingsButtons.forEach { button in
            button.isHidden = false
         }
      }
   }
   
   func showSongDropDown(songDropDown: DropDown) {
      print(#function)
      songDropDown.show()
      songDropDown.selectionAction = { [weak self] (index: Int, item: String) in
         guard let _ = self else { return }
         Constants.defaults.setValue(item, forKey: Constants.savedSong)
         SoundManager.shared.changeAudio()
      }
   }
   
   func showSoundDropDown(soundDropDown: DropDown) {
      print(#function)
      soundDropDown.show()
      soundDropDown.selectionAction = { [weak self] (index: Int, item: String) in
         guard let _ = self else { return }
         Constants.defaults.setValue(item, forKey: Constants.savedSound)
         SoundManager.shared.playAttackSound()
      }
   }
   
   func showTimeDropDown(timeDropDown: DropDown) {
      print(#function)
      timeDropDown.show()
      timeDropDown.selectionAction = { [weak self] (index: Int, item: String) in
         guard let _ = self else { return }
         Constants.defaults.setValue(item, forKey: Constants.gameTimeKey)
      }
   }
   
   func toggleSoundButton(toggleSoundButton: UIButton) {
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


