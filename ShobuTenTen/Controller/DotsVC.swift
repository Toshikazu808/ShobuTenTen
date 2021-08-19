//
//  DotsVC.swift
//  ShobuTenTen
//
//  Created by Ryan Kanno on 8/12/21.
//

import UIKit
import DropDown

final class DotsVC: UIViewController {
   
   // MARK: - Properties
   @IBOutlet weak var restartButton: UIButton!
   
   @IBOutlet weak var orangeTapView: UIView!
   @IBOutlet weak var blueTapView: UIView!
   
   @IBOutlet weak var orangeTapToStartLabel: UILabel!
   @IBOutlet weak var blueTapToStartLabel: UILabel!
   
   private var orangeDot = 0
   @IBOutlet var orangeButtons: [UIButton]!
   private var blueDot = 0
   @IBOutlet var blueButtons: [UIButton]!
   
   @IBOutlet var scoreAreaLines: [UIView]!
   @IBOutlet weak var orangeScore: UILabel!
   @IBOutlet weak var orangeScoreLabel: UILabel!
   @IBOutlet weak var blueScore: UILabel!
   
   @IBOutlet weak var orangeCountDownLabel: UILabel!
   @IBOutlet weak var blueCountDownLabel: UILabel!
   
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
   private var countDownSeconds = 3
   private var countDown = Timer()
   private var timer = Timer()
   private var gameStarted = false
   private var blueTeam = BlueTeam()
   private var orangeTeam = OrangeTeam()
   
   // MARK: - Lifecycle
   override func viewDidLoad() {
      super.viewDidLoad()
      setupOrangeTeam()
      setupBlueTeam()
      setupScoreView()
      setupSettingsView()
   }
   
   private func setupOrangeTeam() {
      orangeCountDownLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
      orangeTapToStartLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
      let tap = UITapGestureRecognizer(target: self, action: #selector(tapToStart))
      orangeTapToStartLabel.addGestureRecognizer(tap)
      orangeTapToStartLabel.isUserInteractionEnabled = true
      orangeButtons.forEach { dot in
         dot.layer.cornerRadius = 20
         dot.alpha = 0
      }
      orangeTapView.layer.borderWidth = 3.5
      orangeTapView.layer.borderColor = UIColor.white.cgColor
      orangeTapView.layer.cornerRadius = 8
   }
   
   private func setupBlueTeam() {
      let tap = UITapGestureRecognizer(target: self, action: #selector(tapToStart))
      blueTapToStartLabel.addGestureRecognizer(tap)
      blueTapToStartLabel.isUserInteractionEnabled = true
      blueButtons.forEach { dot in
         dot.layer.cornerRadius = 20
         dot.alpha = 0
      }
      blueTapView.layer.borderWidth = 3.5
      blueTapView.layer.borderColor = UIColor.white.cgColor
      blueTapView.layer.cornerRadius = 8
   }
   
   private func setupScoreView() {
      scoreAreaLines.forEach { line in
         line.backgroundColor = .white
         line.alpha = 1
         line.isHidden = false
      }
      
      orangeScore.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
      orangeScoreLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
      restartButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
      restartButton.layer.cornerRadius = restartButton.frame.width * 0.5
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
   
   // MARK: - Animations
   @objc private func tapToStart() {
      gameStarted = true
      orangeTapToStartLabel.isHidden = true
      blueTapToStartLabel.isHidden = true
      countDown = Timer.scheduledTimer(
         timeInterval: 1,
         target: self,
         selector: #selector(changeNumber),
         userInfo: nil,
         repeats: true)
   }
   
   @objc private func changeNumber() {
      if countDownSeconds > 0 {
         orangeCountDownLabel.isHidden = false
         orangeCountDownLabel.alpha = 1
         orangeCountDownLabel.text = "\(countDownSeconds)"
         orangeCountDownLabel.pulsate()
         
         blueCountDownLabel.isHidden = false
         blueCountDownLabel.alpha = 1
         blueCountDownLabel.text = "\(countDownSeconds)"
         blueCountDownLabel.pulsate()
         countDownSeconds -= 1
      } else if countDownSeconds == 0 {
         orangeCountDownLabel.text = "Tap!"
         orangeCountDownLabel.pulsate()
         
         blueCountDownLabel.text = "Tap!"
         blueCountDownLabel.pulsate()
         countDownSeconds -= 1
      } else {
         countDown.invalidate()
         UIView.animate(withDuration: 0.5) { [weak self] in
            self?.orangeCountDownLabel.alpha = 0
            self?.blueCountDownLabel.alpha = 0
         } completion: { [weak self] _ in
            self?.orangeCountDownLabel.isHidden = true
            self?.blueCountDownLabel.isHidden = true
            self?.countDownSeconds = 3
            self?.setInitialDots()
            self?.runTimer()
         }
      }
   }
   
   private func setInitialDots() {
      orangeDot = Int.random(in: 0..<orangeButtons.count)
      orangeButtons[orangeDot].alpha = 1
      blueDot = Int.random(in: 0..<blueButtons.count)
      blueButtons[blueDot].alpha = 1
   }
   
   private func runTimer() {
      timer = Timer.scheduledTimer(
         timeInterval: 1,
         target: self,
         selector: #selector(pulseBackground),
         userInfo: nil,
         repeats: true)
   }
   
   @objc private func pulseBackground() {
      if secondsPassed == gameDuration {
         setGameFinished()
      } else {
         secondsPassed += 1
         UIView.animate(withDuration: 0.5) { [weak self] in
            self?.scoreAreaLines.forEach{ line in
               line.alpha = 0.1
            }
         } completion: { _ in
            UIView.animate(withDuration: 0.5) { [weak self] in
               self?.scoreAreaLines.forEach { line in
                  line.alpha = 1
               }
            }
         }
      }
   }
   
   private func flashButtons() {
      UIView.animate(withDuration: 0.1) { [weak self] in
         for i in 0..<self!.orangeButtons.count {
            self?.orangeButtons[i].alpha = 1
            self?.blueButtons[i].alpha = 1
         }
         self?.orangeTapToStartLabel.alpha = 0
         self?.blueTapToStartLabel.alpha = 0
      } completion: { _ in
         UIView.animate(withDuration: 1) { [weak self] in
            for i in 0..<self!.orangeButtons.count {
               self?.orangeButtons[i].alpha = 0
               self?.blueButtons[i].alpha = 0
            }
            if self!.blueTeam.score > self!.orangeTeam.score {
               self?.orangeTapToStartLabel.text = Constants.loser
               self?.blueTapToStartLabel.text = Constants.winner
            } else if self!.blueTeam.score < self!.orangeTeam.score {
               self?.orangeTapToStartLabel.text = Constants.winner
               self?.blueTapToStartLabel.text = Constants.loser
            } else {
               self?.orangeTapToStartLabel.text = Constants.tie
               self?.blueTapToStartLabel.text = Constants.tie
            }
            self?.orangeTapToStartLabel.alpha = 1
            self?.blueTapToStartLabel.alpha = 1
         }
      }
   }
   
   // MARK: - Evaluate
   private func setGameFinished() {
      timer.invalidate()
      gameStarted = false
      orangeTapView.alpha = 1
      orangeTapView.layer.borderColor = UIColor.red.cgColor
      blueTapView.alpha = 1
      blueTapView.layer.borderColor = UIColor.red.cgColor
      orangeTapToStartLabel.isHidden = false
      orangeTapToStartLabel.text = ""
      blueTapToStartLabel.isHidden = false
      blueTapToStartLabel.text = ""
      
      for i in 0..<orangeButtons.count {
         orangeButtons[i].alpha = 0
         blueButtons[i].alpha = 0
      }
      evaluateScores()
      flashButtons()
   }
   
   private func evaluateScores() {
      if blueTeam.score > orangeTeam.score {
         BlueTeam.winCount += 1
         blueScore.text = "\(BlueTeam.winCount)"
      } else if blueTeam.score < orangeTeam.score {
         OrangeTeam.winCount += 1
         orangeScore.text = "\(OrangeTeam.winCount)"
      }
   }
   
   // MARK: - Player Actions
   @IBAction private func orangeButtonTapped(_ sender: UIButton) {
      print(#function)
      orangeTeam.score += 1
      UIView.animate(withDuration: 0.15) { [weak self] in
         self?.orangeButtons[sender.tag].alpha = 0
      } completion: { [weak self] _ in
         UIView.animate(withDuration: 0.15) {
            var num = Int.random(in: 0..<self!.orangeButtons.count)
            while self?.orangeDot == num {
               num = Int.random(in: 0..<self!.orangeButtons.count)
            }
            self?.orangeButtons[num].alpha = 1
         }
      }
   }
   
   @IBAction private func blueButtonTapped(_ sender: UIButton) {
      blueTeam.score += 1
      UIView.animate(withDuration: 0.15) { [weak self] in
         self?.blueButtons[sender.tag].alpha = 0
      } completion: { [weak self] _ in
         UIView.animate(withDuration: 0.15) {
            var num = Int.random(in: 0..<self!.blueButtons.count)
            while self?.blueDot == num {
               num = Int.random(in: 0..<self!.blueButtons.count)
            }
            self?.blueButtons[num].alpha = 1
         }
      }
   }
   
   @IBAction private func backButtonTapped(_ sender: UIButton) {
      self.navigationController?.popViewController(animated: true)
   }
   
   @IBAction private func restartTapped(_ sender: UIButton) {
      gameStarted = false
      countDownSeconds = 3
      secondsPassed = 0
      orangeTeam.score = 0
      blueTeam.score = 0
      orangeTapView.layer.borderColor = UIColor.white.cgColor
      blueTapView.layer.borderColor = UIColor.white.cgColor
      orangeTapToStartLabel.text = "Tap!"
      orangeTapToStartLabel.isHidden = false
      orangeTapToStartLabel.alpha = 1
      blueTapToStartLabel.text = "Tap!"
      blueTapToStartLabel.isHidden = false
      blueTapToStartLabel.alpha = 1
   }
   
   // MARK: - Settings
   @IBAction private func settingsTapped(_ sender: UIButton) {
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
   
   @IBAction private func chooseSongTapped(_ sender: UIButton) {
      songDropDown.show()
      songDropDown.selectionAction = { [weak self] (index: Int, item: String) in
         guard let _ = self else { return }
         Constants.defaults.setValue(item, forKey: Constants.savedSong)
         SoundManager.shared.changeAudio()
      }
   }
   
   @IBAction private func chooseSoundTapped(_ sender: UIButton) {
      soundDropDown.show()
      soundDropDown.selectionAction = { [weak self] (index: Int, item: String) in
         guard let _ = self else { return }
         Constants.defaults.setValue(item, forKey: Constants.savedSound)
         SoundManager.shared.playAttackSound()
      }
   }
   
   @IBAction private func chooseTimeTapped(_ sender: UIButton) {
      timeDropDown.show()
      timeDropDown.selectionAction = { [weak self] (index: Int, item: String) in
         guard let _ = self else { return }
         Constants.defaults.setValue(item, forKey: Constants.gameTimeKey)
      }
   }
   
   @IBAction private func toggleSound(_ sender: UIButton) {
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
}

