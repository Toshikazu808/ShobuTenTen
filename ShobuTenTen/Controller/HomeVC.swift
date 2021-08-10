//
//  ViewController.swift
//  ShobuTenTen
//
//  Created by Ryan Kanno on 8/8/21.
//

import UIKit
import AVFoundation
import DropDown

class HomeVC: UIViewController {
   
   @IBOutlet weak var tapBattleButton: UIButton!
   private var showSettings = false
   @IBOutlet weak var settingsView: UIView!
   @IBOutlet var settingsButtons: [UIButton]!
   private let toggleSoundIndex = 3
   private let songDropDown = DropDown()
   private let soundDropDown = DropDown()
   private let timeDropDown = DropDown()
   private var dropCollection = [DropDown]()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      SoundManager.shared.changeAudio()
      setupMainView()
      setupSettingsViews()
      setupDropDownViews()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.navigationController?.isNavigationBarHidden = true
   }
   
   private func setupMainView() {
      tapBattleButton.layer.cornerRadius = 14
      tapBattleButton.layer.masksToBounds = true
      tapBattleButton.layer.cornerRadius = tapBattleButton.frame.width / 2
   }
   
   private func setupSettingsViews() {
      settingsView.isHidden = true
      settingsView.alpha = 0
      let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
      settingsView.addGestureRecognizer(tap)
      settingsView.isUserInteractionEnabled = true
      
      settingsButtons.forEach { button in
         button.isHidden = true
         button.alpha = 0
         button.layer.cornerRadius = 8
         button.layer.borderWidth = 2.5
         button.layer.borderColor = UIColor.white.cgColor
      }
   }
   
   private func setupDropDownViews() {
      dropCollection = [songDropDown, soundDropDown, timeDropDown]
      for i in 0..<dropCollection.count {
         dropCollection[i].dataSource = Constants.dataSources[i]
         dropCollection[i].anchorView = settingsButtons[i]
         dropCollection[i].direction = .any
         dropCollection[i].cellHeight = settingsButtons[i].frame.height
         dropCollection[i].cornerRadius = 8
         dropCollection[i].textColor = .white
         dropCollection[i].backgroundColor = .systemGreen
         dropCollection[i].selectionBackgroundColor = .systemGreen
         dropCollection[i].separatorColor = .white
         dropCollection[i].textFont = UIFont(
            name: "Chalkboard SE", size: 40) ?? .systemFont(ofSize: 40)
         dropCollection[i].bottomOffset = CGPoint(
            x: 0, y: (dropCollection[i].anchorView?.plainView.bounds.height)!)
         dropCollection[i].customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) in
            cell.optionLabel.textAlignment = .center
         }
      }
   }
   
   // MARK: - Settings
   @IBAction func settingsTapped(_ sender: UIButton) {
      toggleSettingsViews()
      UIView.animate(withDuration: 0.4) { [weak self] in
         self?.settingsView.alpha = 0.5
         self?.settingsButtons.forEach { button in
            button.alpha = 1
         }
      }
   }
   
   @objc private func backgroundTapped() {
      UIView.animate(withDuration: 0.4) { [weak self] in
         self?.settingsView.alpha = 0
         self?.settingsButtons.forEach { button in
            button.alpha = 0
         }
      } completion: { [weak self] _ in
         self?.toggleSettingsViews()
      }
   }
   
   private func toggleSettingsViews() {
      if showSettings {
         settingsView.isHidden = true
         settingsButtons.forEach { button in
            button.isHidden = true
         }
         showSettings.toggle()
      } else {
         settingsView.isHidden = false
         settingsButtons.forEach { button in
            button.isHidden = false
         }
         showSettings.toggle()
      }
   }
   
   @IBAction func chooseSongTapped(_ sender: UIButton) {
      songDropDown.show()
      songDropDown.selectionAction = { [weak self] (index: Int, item: String) in
         guard let _ = self else { return }
         sender.setTitle(item, for: .normal)
         Constants.defaults.setValue(item, forKey: Constants.savedSong)
         SoundManager.shared.changeAudio()
      }
   }
   
   @IBAction func chooseSoundEffectTapped(_ sender: UIButton) {
      soundDropDown.show()
      soundDropDown.selectionAction = { [weak self] (index: Int, item: String) in
         guard let _ = self else { return }
         sender.setTitle(item, for: .normal)
         Constants.defaults.setValue(item, forKey: Constants.savedSound)
         SoundManager.shared.playAttackSound()
      }
   }
   
   @IBAction func chooseTimeTapped(_ sender: UIButton) {
      timeDropDown.show()
      timeDropDown.selectionAction = { [weak self] (index: Int, item: String) in
         guard let _ = self else { return }
         sender.setTitle(item, for: .normal)
         Constants.defaults.setValue(item, forKey: Constants.gameTimeKey)
      }
   }
   
   @IBAction func toggleSound(_ sender: UIButton) {
      if Constants.defaults.bool(forKey: Constants.soundOn) {
         Constants.defaults.setValue(false, forKey: Constants.soundOn)
         settingsButtons[toggleSoundIndex].backgroundColor = .systemRed
      } else {
         Constants.defaults.setValue(true, forKey: Constants.soundOn)
         settingsButtons[toggleSoundIndex].backgroundColor = .systemGreen
      }
      SoundManager.shared.changeAudio()
   }
}

