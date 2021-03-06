//
//  TapBattleVC.swift
//  ShobuTenTen
//
//  Created by Ryan Kanno on 8/9/21.
//

import UIKit
import DropDown

final class TapBattleVC: UIViewController {
   @IBOutlet weak var orangeButton: UILabel!
   @IBOutlet weak var blueButton: UILabel!
   
   @IBOutlet weak var orangePulseView: UIView!
   @IBOutlet weak var bluePulseView: UIView!
   
   @IBOutlet weak var orangeScore: UILabel!
   @IBOutlet weak var blueScore: UILabel!
   @IBOutlet weak var orangeScoreLabel: UILabel!
   @IBOutlet weak var restartButton: UIButton!
   
   private var showSettings = false
   @IBOutlet weak var settingsView: UIView!
   @IBOutlet weak var settingsStackView: UIStackView!
   @IBOutlet var settingsButtons: [UIButton]!
   private let toggleSoundIndex = 3
   
   private let songDropDown = DropDown()
   private let soundDropDown = DropDown()
   private let timeDropDown = DropDown()
   private var dropCollection = [DropDown]()
   
   private var secondsPassed = 0
   private var gameDuration: Int {
      return Constants.defaults.string(forKey: Constants.gameTimeKey)?.getNumber() ?? 5
   }
   private var timer = Timer()
   private var gameStarted = false
   private var blueTeam = BlueTeam()
   private var orangeTeam = OrangeTeam()
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupMainView()
      setupSettingsView()
      setupDropDownViews()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      // Play 3..2..1..GO video
   }
   
   override var shouldAutorotate: Bool { return false }
   override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
       return .portrait
   }
   override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
       return .portrait
   }
   
   private func setupMainView() {
      let orangeTap = UITapGestureRecognizer(target: self, action: #selector(orangeTapped))
      orangeButton.addGestureRecognizer(orangeTap)
      orangeButton.isUserInteractionEnabled = true
      orangeButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
      orangeButton.layer.cornerRadius = 8
      orangeButton.layer.masksToBounds = true
      orangePulseView.layer.cornerRadius = 8
      orangePulseView.alpha = 0
      orangeScore.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
      orangeScoreLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
      
      let blueTap = UITapGestureRecognizer(target: self, action: #selector(blueTapped))
      blueButton.addGestureRecognizer(blueTap)
      blueButton.isUserInteractionEnabled = true
      blueButton.layer.cornerRadius = 8
      blueButton.layer.masksToBounds = true
      bluePulseView.layer.cornerRadius = 8
      bluePulseView.alpha = 0      
      
      restartButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
      restartButton.layer.cornerRadius = restartButton.frame.width / 2
   }
   
   private func setupSettingsView() {
      settingsView.isHidden = true
      settingsView.alpha = 0
      let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
      settingsView.addGestureRecognizer(tap)
      settingsView.isUserInteractionEnabled = true
      settingsStackView.isHidden = true
      settingsStackView.alpha = 0
      
      settingsButtons.forEach { button in
         button.isHidden = true
         button.alpha = 0
         button.layer.cornerRadius = 8
         button.layer.borderWidth = 2.5
         button.layer.borderColor = UIColor.white.cgColor
      }
      if Global.shared.soundIsOn {
         settingsButtons[toggleSoundIndex].backgroundColor = .systemGreen
         settingsButtons[toggleSoundIndex].setTitle("Sound on", for: .normal)
      } else {
         settingsButtons[toggleSoundIndex].backgroundColor = .systemRed
         settingsButtons[toggleSoundIndex].setTitle("Sound off", for: .normal)
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
   
   @IBAction func backButtonTapped(_ sender: UIButton) {
      self.navigationController?.popViewController(animated: true)
   }
   
   // MARK: - Player Actions
   @objc private func orangeTapped() {
      if !gameStarted {
         gameStarted = true
         runTimer()
      }
      orangeTeam.score += 1
      orangeButton.text = "\(orangeTeam.score)"
      SoundManager.shared.playAttackSound()
   }
   
   @objc private func blueTapped() {
      if !gameStarted {
         gameStarted = true
         runTimer()
      }
      blueTeam.score += 1
      blueButton.text = "\(blueTeam.score)"
      SoundManager.shared.playAttackSound()
   }
   
   private func runTimer() {
      timer = Timer.scheduledTimer(
         timeInterval: 1,
         target: self,
         selector: #selector(pulse),
         userInfo: nil,
         repeats: true)
   }
   
   @objc private func pulse() {
      if secondsPassed == gameDuration {
         setGameFinished()
      } else {
         secondsPassed += 1
         UIView.animate(withDuration: 0.5) { [weak self] in
            self?.bluePulseView.alpha = 0
            self?.orangePulseView.alpha = 0
         } completion: { _ in
            UIView.animate(withDuration: 0.5) { [weak self] in
               self?.bluePulseView.alpha = 1
               self?.orangePulseView.alpha = 1
            }
         }
      }
   }
   
   private func setGameFinished() {
      timer.invalidate()
      gameStarted = false
      blueButton.isUserInteractionEnabled = false
      bluePulseView.backgroundColor = .red
      bluePulseView.alpha = 1
      orangeButton.isUserInteractionEnabled = false
      orangePulseView.backgroundColor = .red
      orangePulseView.alpha = 1      
      
      evaluateScores()
   }
   
   private func evaluateScores() {
      if blueTeam.score > orangeTeam.score {
         blueButton.text = Constants.winner
         BlueTeam.winCount += 1
         blueScore.text = "\(BlueTeam.winCount)"
         orangeButton.text = Constants.loser
      } else if blueTeam.score < orangeTeam.score {
         orangeButton.text = Constants.winner
         OrangeTeam.winCount += 1
         orangeScore.text = "\(OrangeTeam.winCount)"
         blueButton.text = Constants.loser
      } else {
         blueButton.text = Constants.tie
         orangeButton.text = Constants.tie
      }
   }
   
   // MARK: - Settings
   @IBAction func settingsTapped(_ sender: UIButton) {
      toggleSettingsViews()
      UIView.animate(withDuration: 0.4) { [weak self] in
         self?.settingsView.alpha = 0.5
         self?.settingsStackView.alpha = 1
         self?.settingsButtons.forEach { button in
            button.alpha = 1
         }
      }
   }
   
   @objc private func backgroundTapped() {
      UIView.animate(withDuration: 0.4) { [weak self] in
         self?.settingsView.alpha = 0
         self?.settingsStackView.alpha = 0
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
         settingsStackView.isHidden = true
         settingsButtons.forEach { button in
            button.isHidden = true
         }
      } else {
         settingsView.isHidden = false
         settingsStackView.isHidden = false
         settingsButtons.forEach { button in
            button.isHidden = false
         }
      }
      showSettings = showSettings == true ? false : true
   }
   
   @IBAction func chooseSongTapped(_ sender: UIButton) {
      songDropDown.show()
      songDropDown.selectionAction = { [weak self] (index: Int, item: String) in
         guard let _ = self else { return }
         Constants.defaults.setValue(item, forKey: Constants.savedSong)
         SoundManager.shared.changeAudio()
      }
   }
   
   @IBAction func chooseSoundEffectTapped(_ sender: UIButton) {
      soundDropDown.show()
      soundDropDown.selectionAction = { [weak self] (index: Int, item: String) in
         guard let _ = self else { return }
         Constants.defaults.setValue(item, forKey: Constants.savedSound)
         SoundManager.shared.playAttackSound()
      }
   }
   
   @IBAction func chooseTimeTapped(_ sender: UIButton) {
      timeDropDown.show()
      timeDropDown.selectionAction = { [weak self] (index: Int, item: String) in
         guard let _ = self else { return }
         Constants.defaults.setValue(item, forKey: Constants.gameTimeKey)
      }
   }
   
   @IBAction func toggleSound(_ sender: UIButton) {
      if Global.shared.soundIsOn {
         Constants.defaults.setValue(false, forKey: Constants.soundOn)
         settingsButtons[toggleSoundIndex].backgroundColor = .systemRed
         settingsButtons[toggleSoundIndex].setTitle("Sound off", for: .normal)
      } else {
         Constants.defaults.setValue(true, forKey: Constants.soundOn)
         settingsButtons[toggleSoundIndex].backgroundColor = .systemGreen
         settingsButtons[toggleSoundIndex].setTitle("Sound on", for: .normal)
      }
      SoundManager.shared.changeAudio()
   }
   
   @IBAction func restartTapped(_ sender: UIButton) {
      gameStarted = false
      secondsPassed = 0
      blueTeam.score = 0
      orangeTeam.score = 0
      orangeButton.isUserInteractionEnabled = true
      blueButton.isUserInteractionEnabled = true
      UIView.animate(withDuration: 0.5) { [weak self] in
         self?.blueButton.text = "Tap!"
         self?.orangeButton.text = "Tap!"
         self?.bluePulseView.alpha = 0
         self?.bluePulseView.backgroundColor = .white
         self?.orangePulseView.alpha = 0
         self?.orangePulseView.backgroundColor = .white
      }
   }
}
