//
//  ViewController.swift
//  ShobuTenTen
//
//  Created by Ryan Kanno on 8/8/21.
//

import UIKit

class HomeVC: UIViewController {
   
   @IBOutlet weak var tapBattleButton: UIButton!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupButtons()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.navigationController?.isNavigationBarHidden = true
   }
   
   private func setupButtons() {
      tapBattleButton.layer.cornerRadius = 14
      tapBattleButton.layer.masksToBounds = true
      tapBattleButton.layer.cornerRadius = tapBattleButton.frame.width / 2
   }
   
}

