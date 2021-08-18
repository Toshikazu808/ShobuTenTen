//
//  SongButton.swift
//  ShobuTenTen
//
//  Created by Ryan Kanno on 8/15/21.
//

import UIKit

protocol SongButtonDelegate: AnyObject {
   func songButtonTapped()
}

final class SongButton: UIButton {
   weak var delegate: SongButtonDelegate?
    
   override init(frame: CGRect) {
      super.init(frame: frame)
      self.setTitle("Song", for: .normal)
      self.configureSettingsButton()
      let tap = UITapGestureRecognizer(target: self, action: #selector(songTapped))
      self.addGestureRecognizer(tap)
   }
   
   required init?(coder: NSCoder) {
      fatalError()
   }
   
   @objc private func songTapped() {
      delegate?.songButtonTapped()
   }

}
