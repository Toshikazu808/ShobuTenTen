//
//  SettingsStack.swift
//  ShobuTenTen
//
//  Created by Ryan Kanno on 8/14/21.
//

import UIKit
import DropDown

class SettingsStack: UIView {
      
   @IBOutlet weak var songButton: UIButton!
   @IBOutlet weak var soundButton: UIButton!
   @IBOutlet weak var timeButton: UIButton!
   @IBOutlet weak var toggleSoundButton: UIButton!
   private var buttons = [UIButton]()
   
   private let toggleSoundIndex = 3
   private let songDropDown = DropDown()
   private let soundDropDown = DropDown()
   private let timeDropDown = DropDown()
   private var dropCollection = [DropDown]()
   
   override func awakeFromNib() {
      super.awakeFromNib()
      configure()
      setupDropDownViews()
   }
   
   private func configure() {
      buttons = [songButton, soundButton, timeButton, toggleSoundButton]
      buttons.forEach { button in
         button.layer.cornerRadius = 8
         button.layer.borderWidth = 2.5
         button.layer.borderColor = UIColor.white.cgColor
         button.translatesAutoresizingMaskIntoConstraints = false
      }
   }
   
   private func setupDropDownViews() {
      dropCollection = [songDropDown, soundDropDown, timeDropDown]
//      for i in 0..<dropCollection.count {
//         dropCollection[i].dataSource = Constants.dataSources[i]
//         dropCollection[i].anchorView = buttons[i]
//         dropCollection[i].direction = .any
//         dropCollection[i].cellHeight = buttons[i].frame.height
//         dropCollection[i].cornerRadius = 8
//         dropCollection[i].textColor = .white
//         dropCollection[i].backgroundColor = .systemGreen
//         dropCollection[i].selectionBackgroundColor = .systemGreen
//         dropCollection[i].separatorColor = .white
//         dropCollection[i].textFont = UIFont(
//            name: "Chalkboard SE", size: 40) ?? .systemFont(ofSize: 40)
//         dropCollection[i].bottomOffset = CGPoint(
//            x: 0, y: (dropCollection[i].anchorView?.plainView.bounds.height)!)
//         dropCollection[i].customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) in
//            cell.optionLabel.textAlignment = .center
//         }
//      }
   }
   
   @IBAction func songButtonTapped(_ sender: UIButton) {
      print(#function)
      songDropDown.show()
      songDropDown.selectionAction = { [weak self] (index: Int, item: String) in
         guard let _ = self else { return }
         Constants.defaults.setValue(item, forKey: Constants.savedSong)
         SoundManager.shared.changeAudio()
      }
   }
   
   @IBAction func soundButtonTapped(_ sender: UIButton) {
      soundDropDown.show()
      soundDropDown.selectionAction = { [weak self] (index: Int, item: String) in
         guard let _ = self else { return }
         Constants.defaults.setValue(item, forKey: Constants.savedSound)
         SoundManager.shared.playAttackSound()
      }
   }
   
   @IBAction func timeButtonTapped(_ sender: UIButton) {
      timeDropDown.show()
      timeDropDown.selectionAction = { [weak self] (index: Int, item: String) in
         guard let _ = self else { return }
         Constants.defaults.setValue(item, forKey: Constants.gameTimeKey)
      }
   }
   
   @IBAction func toggleSound(_ sender: UIButton) {
      if Global.shared.soundIsOn {
         Constants.defaults.setValue(false, forKey: Constants.soundOn)
         buttons[toggleSoundIndex].backgroundColor = .systemRed
         buttons[toggleSoundIndex].setTitle("Sound off", for: .normal)
      } else {
         Constants.defaults.setValue(true, forKey: Constants.soundOn)
         buttons[toggleSoundIndex].backgroundColor = .systemGreen
         buttons[toggleSoundIndex].setTitle("Sound on", for: .normal)
      }
      SoundManager.shared.changeAudio()
   }
}
