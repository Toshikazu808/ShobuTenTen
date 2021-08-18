//
//  SettingsBackgroundView.swift
//  ShobuTenTen
//
//  Created by Ryan Kanno on 8/13/21.
//

import UIKit

protocol SettingsBackgroundViewDelegate: AnyObject {
   func backgroundTapped()
}

class SettingsBackgroundView: UIView {
   weak var delegate: SettingsBackgroundViewDelegate?
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      self.backgroundColor = .black
      self.alpha = 0
      self.isHidden = true
      self.isUserInteractionEnabled = true
      self.clipsToBounds = true
      self.translatesAutoresizingMaskIntoConstraints = false
      let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
      self.addGestureRecognizer(tap)
   }
   
   required init?(coder: NSCoder) {
      fatalError()
   }
   
   @objc private func backgroundTapped() {
      delegate?.backgroundTapped()
   }
}
