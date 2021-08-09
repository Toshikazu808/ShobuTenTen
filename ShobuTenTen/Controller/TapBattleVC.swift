//
//  TapBattleVC.swift
//  ShobuTenTen
//
//  Created by Ryan Kanno on 8/9/21.
//

import UIKit
import DropDown

class TapBattleVC: UIViewController {
   
   @IBOutlet weak var blueButton: UILabel!
   @IBOutlet weak var orangeButton: UILabel!
   
   @IBOutlet weak var bluePulseView: UIView!
   @IBOutlet weak var orangePulseView: UIView!
   
   @IBOutlet weak var blueScoreLabel: UILabel!
   @IBOutlet weak var blueScore: UILabel!
   @IBOutlet weak var orangeScoreLabel: UILabel!
   @IBOutlet weak var orangeScore: UILabel!
   @IBOutlet weak var restartButtonSmall: UIButton!
   
   private var showSettings = false
   @IBOutlet weak var settingsView: UIView!
   @IBOutlet weak var restartButton: UIButton!
   @IBOutlet weak var chooseTimeButton: UIButton!
   private let timeDropDown = DropDown()
   
   private var blueTeam = BlueTeam()
   private var orangeTeam = OrangeTeam()
   private var gameDuration = 5
   private var gameStarted = false
   private var secondsPassed = 0
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupMainView()
      setupSettingsView()
      setupDefaults()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      // Play 3..2..1..GO video
   }
   
   override var shouldAutorotate: Bool {
       return false
   }
   override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
       return .portrait
   }
   override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
       return .portrait
   }
   
   private func setupMainView() {
      let blueTap = UITapGestureRecognizer(target: self, action: #selector(blueTapped))
      blueButton.addGestureRecognizer(blueTap)
      blueButton.isUserInteractionEnabled = true
      blueButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
      blueButton.layer.cornerRadius = 8
      blueButton.layer.masksToBounds = true
      bluePulseView.layer.cornerRadius = 8
      bluePulseView.alpha = 0
      blueScore.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
      blueScoreLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
      
      let orangeTap = UITapGestureRecognizer(target: self, action: #selector(orangeTapped))
      orangeButton.addGestureRecognizer(orangeTap)
      orangeButton.isUserInteractionEnabled = true
      orangeButton.layer.cornerRadius = 8
      orangeButton.layer.masksToBounds = true
      orangePulseView.layer.cornerRadius = 8
      orangePulseView.alpha = 0
      
      restartButtonSmall.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
      restartButtonSmall.layer.cornerRadius = restartButtonSmall.frame.width / 2
   }
   
   private func setupSettingsView() {
      settingsView.isHidden = true
      settingsView.alpha = 0
      let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
      settingsView.addGestureRecognizer(tap)
      settingsView.isUserInteractionEnabled = true
      
      restartButton.isHidden = true
      restartButton.alpha = 0
      restartButton.layer.cornerRadius = 8
      restartButton.layer.borderWidth = 2.5
      restartButton.layer.borderColor = UIColor.white.cgColor
      
      chooseTimeButton.isHidden = true
      chooseTimeButton.alpha = 0
      chooseTimeButton.layer.cornerRadius = 8
      chooseTimeButton.layer.borderWidth = 2.5
      chooseTimeButton.layer.borderColor = UIColor.white.cgColor
      
      timeDropDown.dataSource = Constants.dropDownDataSource
      timeDropDown.anchorView = chooseTimeButton
      timeDropDown.direction = .bottom
      timeDropDown.bottomOffset = CGPoint(x: 0, y: (timeDropDown.anchorView?.plainView.bounds.height)!)
      timeDropDown.cellHeight = chooseTimeButton.frame.height
      timeDropDown.cornerRadius = 8
      timeDropDown.backgroundColor = .systemGreen
      timeDropDown.textColor = .white
      timeDropDown.textFont = UIFont(name: "Chalkboard SE", size: 40) ?? .systemFont(ofSize: 40)
      timeDropDown.selectionBackgroundColor = .systemGreen
      timeDropDown.separatorColor = .white
      timeDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
         cell.optionLabel.textAlignment = .center
      }
   }
   
   private func setupDefaults() {
      Constants.gameTime = Constants.defaults.integer(forKey: Constants.gameTimeKey)
      if Constants.gameTime == 0 {
         Constants.gameTime = 10
      }
   }
   
   private func runTimer() {
      Constants.timer = Timer.scheduledTimer(
         timeInterval: 1,
         target: self, selector: #selector(pulse),
         userInfo: nil,
         repeats: true)
   }
   
   @objc private func pulse() {
      if secondsPassed == gameDuration {
         Constants.timer.invalidate()
         gameStarted.toggle()
         Constants.evaluateScores()
         bluePulseView.backgroundColor = .red
         bluePulseView.alpha = 1
         orangePulseView.backgroundColor = .red
         orangePulseView.alpha = 1
      } else {
         secondsPassed += 1
         UIView.animate(withDuration: 0.5) { [weak self] in
            self?.bluePulseView.alpha = 1
            self?.orangePulseView.alpha = 1
         } completion: { _ in
            UIView.animate(withDuration: 0.5) { [weak self] in
               self?.bluePulseView.alpha = 0
               self?.orangePulseView.alpha = 0
            }
         }
      }
   }
   
   @IBAction func backButtonTapped(_ sender: UIButton) {
      self.navigationController?.popViewController(animated: true)
   }
   
   @IBAction func settingsTapped(_ sender: UIButton) {
      toggleSettingsViews()
      UIView.animate(withDuration: 0.4) { [weak self] in
         self?.settingsView.alpha = 0.5
         self?.restartButton.alpha = 1
         self?.chooseTimeButton.alpha = 1
      }
   }
   
   @objc private func backgroundTapped() {
      UIView.animate(withDuration: 0.4) { [weak self] in
         self?.settingsView.alpha = 0
         self?.restartButton.alpha = 0
         self?.chooseTimeButton.alpha = 0
      } completion: { [weak self] _ in
         self?.toggleSettingsViews()
      }
   }
   
   private func toggleSettingsViews() {
      if showSettings {
         settingsView.isHidden = true
         restartButton.isHidden = true
         chooseTimeButton.isHidden = true
         showSettings.toggle()
      } else {
         settingsView.isHidden = false
         restartButton.isHidden = false
         chooseTimeButton.isHidden = false
         showSettings.toggle()
      }
   }
   
   @objc private func blueTapped() {
      if !gameStarted {
         gameStarted.toggle()
         runTimer()
      }
      blueTeam.score += 1
      blueButton.text = "\(blueTeam.score)"
   }
   
   @objc private func orangeTapped() {
      if !gameStarted {
         gameStarted.toggle()
         runTimer()
      }
      orangeTeam.score += 1
      orangeButton.text = "\(orangeTeam.score)"
   }
   
   @IBAction func restartTapped(_ sender: UIButton) {
      secondsPassed = 0
      blueTeam.score = 0
      orangeTeam.score = 0
      blueButton.text = "Tap!"
      orangeButton.text = "Tap!"
      bluePulseView.alpha = 0
      bluePulseView.backgroundColor = .white
      orangePulseView.alpha = 0
      orangePulseView.backgroundColor = .white
   }
   
   @IBAction func chooseTimeTapped(_ sender: UIButton) {
      timeDropDown.show()
      timeDropDown.selectionAction = { [weak self] (index: Int, item: String) in
         guard let _ = self else { return }
         sender.setTitle(item, for: .normal)
      }
   }
}
