//
//  DotsCollectionViewCell.swift
//  ShobuTenTen
//
//  Created by Ryan Kanno on 8/16/21.
//

import UIKit

class DotsCollectionViewCell: UICollectionViewCell {
   
   static let id = "DotsCollectionViewCell"
   static let estimateWidtch: CGFloat = 50
   static let cellMarginSize = 6
   @IBOutlet weak var dotView: UIView!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      dotView.layer.cornerRadius = self.frame.size.width / 2
   }
   
}
