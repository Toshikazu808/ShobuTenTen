//
//  SoundButton.swift
//  ShobuTenTen
//
//  Created by Ryan Kanno on 8/15/21.
//

import UIKit

protocol SoundButtonDelegate: AnyObject {
   func soundButtonTapped()
}

final class SoundButton: UIButton {
   weak var delegate: SoundButtonDelegate?
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      self.setTitle("Sound", for: .normal)
      self.configureSettingsButton()
      let tap = UITapGestureRecognizer(target: self, action: #selector(soundTapped))
      self.addGestureRecognizer(tap)
   }
   
   required init?(coder: NSCoder) {
      fatalError()
   }
   
   @objc private func soundTapped() {
      delegate?.soundButtonTapped()
   }

}
