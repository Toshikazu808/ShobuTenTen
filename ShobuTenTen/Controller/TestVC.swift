//
//  TestVC.swift
//  ShobuTenTen
//
//  Created by Ryan Kanno on 8/12/21.
//

import UIKit
import DropDown

class TestVC: UIViewController {
   private var showSettings = false
   private let settingsBackground = SettingsBackgroundView()
   
   private let songButton = SongButton()
   private let soundButton = SoundButton()
   private let timeButton = TimeButton()
   private let toggleSoundButton = ToggleSoundButton()
   private var settingsButtons = [UIButton]()
   private let settingsStack = UIStackView()
   
   private let songDropDown = DropDown()
   private let soundDropDown = DropDown()
   private let timeDropDown = DropDown()
   private var dropDowns = [DropDown]()
   
   
   // MARK: - Lifecycle
   override func viewDidLoad() {
      super.viewDidLoad()
      settingsBackground.delegate = self
      songButton.delegate = self
      soundButton.delegate = self
      timeButton.delegate = self
      toggleSoundButton.delegate = self
      settingsButtons = [songButton, soundButton, timeButton, toggleSoundButton]
      dropDowns = [songDropDown, soundDropDown, timeDropDown]
      
      configureSettingsBackground(settingsBackground)
      configureSettingsStackView(stackView: settingsStack, buttons: settingsButtons, dropDowns: dropDowns)
      configureDropDowns()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      self.navigationController?.isNavigationBarHidden = false
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      self.navigationController?.isNavigationBarHidden = true
   }
   
   private func configureDropDowns() {
      for i in 0..<dropDowns.count {
         dropDowns[i].translatesAutoresizingMaskIntoConstraints = false
         dropDowns[i].dataSource = Constants.dataSources[i]
         dropDowns[i].anchorView = settingsButtons[i]
         dropDowns[i].isHidden = false
         dropDowns[i].cellHeight = settingsButtons[i].frame.height
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
   
   @IBAction func showSettingsView(_ sender: UIButton) {
      toggleSettingsViews()
   }
   
   private func toggleSettingsViews() {
      toggleSettingsViews(
         showSettings: showSettings,
         settingsBackground: settingsBackground,
         settingsStack: settingsStack,
         settingsButtons: settingsButtons)
      showSettings.toggle()
   }
}

extension TestVC: SettingsBackgroundViewDelegate {
   func backgroundTapped() {
      print(#function)
      UIView.animate(withDuration: 0.4) { [weak self] in
         self?.settingsBackground.alpha = 0
         self?.settingsStack.alpha = 0
         self?.settingsButtons.forEach { button in
            button.alpha = 0
         }
      } completion: { [weak self] _ in
         self?.toggleSettingsViews()
      }
   }
}

extension TestVC: SongButtonDelegate, SoundButtonDelegate, TimeButtonDelegate, ToggleSoundButtonDelegate {
   func songButtonTapped() {
      print(#function)
//      showSongDropDown(songDropDown: songDropDown)
      songDropDown.show()
      songDropDown.selectionAction = { [weak self] (index: Int, item: String) in
         guard let _ = self else { return }
         Constants.defaults.setValue(item, forKey: Constants.savedSong)
         SoundManager.shared.changeAudio()
      }
   }
   
   func soundButtonTapped() {
      print(#function)
      showSoundDropDown(soundDropDown: soundDropDown)
   }
   
   func timeButtonTapped() {
      print(#function)
      showTimeDropDown(timeDropDown: timeDropDown)
   }
   
   func toggleSoundButtonTapped() {
      print(#function)
      toggleSoundButton(toggleSoundButton: toggleSoundButton)
   }
}
