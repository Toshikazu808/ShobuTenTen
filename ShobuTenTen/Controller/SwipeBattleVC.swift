//
//  SwipeBattleVC.swift
//  ShobuTenTen
//
//  Created by Ryan Kanno on 8/10/21.
//

import UIKit
import DropDown

class SwipeBattleVC: UIViewController {
   
   // MARK: - Properties
   @IBOutlet weak var blueScore: UILabel!
   @IBOutlet weak var orangeScore: UILabel!
   @IBOutlet weak var orangeScoreLabel: UILabel!
   @IBOutlet weak var restartButton: UIButton!
   
   @IBOutlet weak var orangePulseView: UIView!
   private let orangeSwipeView = SwipeView()
//   private let orangeSwipeView: SwipeView = {
//      let view = SwipeView()
////      view.translatesAutoresizingMaskIntoConstraints = false
//      view.layer.cornerRadius = 8
////      view.layer.masksToBounds = true
//      view.backgroundColor = UIColor(named: "OrangeTeam")
//      view.alpha = 1
//      return view
//   }()
   private var orangeSwipeLabel: UILabel = {
      let label = UILabel()
      label.text = "Swipe!"
      label.textColor = .white
      label.alpha = 1
      label.isHidden = false
      label.translatesAutoresizingMaskIntoConstraints = false
      label.isUserInteractionEnabled = false
      label.font = UIFont(name: "Chalkboard SE", size: 40) ?? .systemFont(ofSize: 40)
      label.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
      return label
   }()
   @IBOutlet weak var bluePulseView: UIView!
   private let blueSwipeView: SwipeView = {
      let view = SwipeView()
      view.translatesAutoresizingMaskIntoConstraints = false
      view.layer.cornerRadius = 8
      view.layer.masksToBounds = true
      view.backgroundColor = UIColor(named: "BlueTeam")
      view.alpha = 1
      return view
   }()
   private var blueSwipeLabel: UILabel = {
      let label = UILabel()
      label.text = "Swipe!"
      label.textColor = .white
      label.alpha = 1
      label.isHidden = false
      label.translatesAutoresizingMaskIntoConstraints = false
      label.isUserInteractionEnabled = false
      label.font = UIFont(name: "Chalkboard SE", size: 40) ?? .systemFont(ofSize: 40)
      return label
   }()
   
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
   
   
   // MARK: - Lifecycle
   override func viewDidLoad() {
      super.viewDidLoad()
      setupOrangeTeam()
      setupBlueTeam()
      setupScoreView()
      setupSettingsView()
   }
   
   private func setupOrangeTeam() {
      orangePulseView.translatesAutoresizingMaskIntoConstraints = false
      orangePulseView.layer.masksToBounds = true
      
      orangeSwipeView.translatesAutoresizingMaskIntoConstraints = false
      orangeSwipeView.layer.masksToBounds = true
      orangeSwipeView.layer.cornerRadius = 8
      orangeSwipeView.backgroundColor = UIColor(named: "OrangeTeam")
      orangeSwipeView.alpha = 1
//      orangeSwipeView.frame = orangePulseView.frame
//      orangeSwipeView.frame = view.frame
      print(view.frame)
      print(orangePulseView.frame)
      view.addSubview(orangeSwipeView)
//      orangeSwipeView.backgroundColor = .white
      
      // WHY DOES THE FINGER TRACKING GO OFF WHEN I DON'T USE self.view ?????
      
      print(orangeSwipeView.frame)
      NSLayoutConstraint.activate([
         orangeSwipeView.leadingAnchor.constraint(equalTo: orangePulseView.leadingAnchor, constant: 5),
         orangeSwipeView.trailingAnchor.constraint(equalTo: orangePulseView.trailingAnchor, constant: -5),
         orangeSwipeView.topAnchor.constraint(equalTo: orangePulseView.topAnchor, constant: 5),
         orangeSwipeView.bottomAnchor.constraint(equalTo: orangePulseView.bottomAnchor, constant: -5),
      ])
      print(orangeSwipeView.frame)
      
//      orangeSwipeView.addSubview(orangeSwipeLabel)
//      NSLayoutConstraint.activate([
//         orangeSwipeLabel.centerXAnchor.constraint(equalTo: orangeSwipeView.centerXAnchor),
//         orangeSwipeLabel.centerYAnchor.constraint(equalTo: orangeSwipeView.centerYAnchor)
//      ])
      orangePulseView.layer.cornerRadius = 8
//      orangePulseView.alpha = 0
   }
   
   private func setupBlueTeam() {
//      view.addSubview(blueSwipeView)
//      blueSwipeView.frame = bluePulseView.frame
//      NSLayoutConstraint.activate([
//         blueSwipeView.leadingAnchor.constraint(equalTo: bluePulseView.leadingAnchor, constant: 5),
//         blueSwipeView.trailingAnchor.constraint(equalTo: bluePulseView.trailingAnchor, constant: -5),
//         blueSwipeView.topAnchor.constraint(equalTo: bluePulseView.topAnchor, constant: 5),
//         blueSwipeView.bottomAnchor.constraint(equalTo: bluePulseView.bottomAnchor, constant: -5),
//      ])
////      blueSwipeView.addSubview(blueSwipeLabel)
////      NSLayoutConstraint.activate([
////         blueSwipeLabel.centerXAnchor.constraint(equalTo: blueSwipeView.centerXAnchor),
////         blueSwipeLabel.centerYAnchor.constraint(equalTo: blueSwipeView.centerYAnchor)
////      ])
//      bluePulseView.layer.cornerRadius = 8
//      bluePulseView.alpha = 0
   }
   
   private func setupScoreView() {
      orangeScore.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
      orangeScoreLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
      restartButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
      restartButton.layer.cornerRadius = restartButton.frame.width / 2
   }
   
   private func setupSettingsView() {
//      settingsView.isHidden = true
//      settingsView.alpha = 0
//      let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
//      settingsView.addGestureRecognizer(tap)
//      settingsView.isUserInteractionEnabled = true
//      settingsStackView.isHidden = true
//      settingsStackView.alpha = 0
//
//      settingsButtons.forEach { button in
//         button.isHidden = true
//         button.alpha = 0
//         button.layer.cornerRadius = 8
//         button.layer.borderWidth = 2.5
//         button.layer.borderColor = UIColor.white.cgColor
//      }
//      if Global.shared.soundIsOn {
//         settingsButtons[toggleSoundIndex].backgroundColor = .systemGreen
//         settingsButtons[toggleSoundIndex].setTitle("Sound on", for: .normal)
//      } else {
//         settingsButtons[toggleSoundIndex].backgroundColor = .systemRed
//         settingsButtons[toggleSoundIndex].setTitle("Sound off", for: .normal)
//      }
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
         showSettings.toggle()
      } else {
         settingsView.isHidden = false
         settingsStackView.isHidden = false
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
         Constants.defaults.setValue(item, forKey: Constants.savedSong)
         SoundManager.shared.changeAudio()
      }
   }
   
   @IBAction func chooseSoundTapped(_ sender: UIButton) {
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
}
