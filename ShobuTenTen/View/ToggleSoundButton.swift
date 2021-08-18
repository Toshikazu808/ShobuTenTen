//
//  ToggleSoundButton.swift
//  ShobuTenTen
//
//  Created by Ryan Kanno on 8/15/21.
//

import UIKit

protocol ToggleSoundButtonDelegate: AnyObject {
   func toggleSoundButtonTapped()
}

final class ToggleSoundButton: UIButton {
   weak var delegate: ToggleSoundButtonDelegate?
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      self.setTitle(Global.shared.toggleSoundButtonTitle, for: .normal)
      self.configureSettingsButton()
      let tap = UITapGestureRecognizer(target: self, action: #selector(toggleSoundTapped))
      self.addGestureRecognizer(tap)
   }
   
   required init?(coder: NSCoder) {
      fatalError()
   }
   
   @objc private func toggleSoundTapped() {
      delegate?.toggleSoundButtonTapped()
   }

}
