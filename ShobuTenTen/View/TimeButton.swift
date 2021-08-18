//
//  TimeButton.swift
//  ShobuTenTen
//
//  Created by Ryan Kanno on 8/15/21.
//

import UIKit

protocol TimeButtonDelegate: AnyObject {
   func timeButtonTapped()
}

final class TimeButton: UIButton {
   weak var delegate: TimeButtonDelegate?
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      self.setTitle("Time", for: .normal)
      self.configureSettingsButton()
      let tap = UITapGestureRecognizer(target: self, action: #selector(timeTapped))
      self.addGestureRecognizer(tap)
   }
   
   required init?(coder: NSCoder) {
      fatalError()
   }
   
   @objc private func timeTapped() {
      delegate?.timeButtonTapped()
   }

}
