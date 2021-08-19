//
//  ChooseGameCell.swift
//  ShobuTenTen
//
//  Created by Ryan Kanno on 8/10/21.
//

import UIKit

final class ChooseGameCell: UITableViewCell {
   static let id = "ChooseGameCell"
   static let preferredHeight: CGFloat = 80
   @IBOutlet weak var gameLabel: UILabel!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      gameLabel.textColor = .white
      gameLabel.backgroundColor = .black
      gameLabel.layer.cornerRadius = 8
      gameLabel.layer.borderWidth = 2.5
      gameLabel.layer.borderColor = UIColor.white.cgColor
      isUserInteractionEnabled = true
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
   }
   
   func configure(_ game: String) {
      gameLabel.text = game
   }
   
}
