//
//  Extensions.swift
//  ShobuTenTen
//
//  Created by Ryan Kanno on 8/9/21.
//

import Foundation

extension String {
   func getNumber() -> Int? {
      var num: Int?
      let pattern = #"(\d+)"#
      let regex = try! NSRegularExpression(pattern: pattern, options: [])
      if let match = regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count)) {
         let newString = (self as NSString).substring(with: match.range)
         num = Int(newString)
      }
      return num
   }
}
