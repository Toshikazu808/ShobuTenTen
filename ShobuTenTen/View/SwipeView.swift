//
//  OrangeSwipeView.swift
//  ShobuTenTen
//
//  Created by Ryan Kanno on 8/10/21.
//

import UIKit

class SwipeView: UIView {
   var lines = [[CGPoint]]()
   
   override func draw(_ rect: CGRect) {
      super.draw(rect)
      guard let context = UIGraphicsGetCurrentContext() else { return }
      context.setStrokeColor(UIColor.blue.cgColor)
      context.setLineWidth(7)
      context.setLineCap(.butt)
      lines.forEach { line in
         for (index, point) in line.enumerated() {
            if index == 0 {
               context.move(to: point)
            } else {
               context.addLine(to: point)
            }
         }
      }
      context.strokePath()
   }
   
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      lines.append([CGPoint]())
   }
   
   override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
      guard let point = touches.first?.location(in: nil) else { return }
      guard var lastLine = lines.popLast() else { return }
      lastLine.append(point)
      lines.append(lastLine)
      setNeedsDisplay()
   }
}
