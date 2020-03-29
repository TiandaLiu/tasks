//
//  TimeLineView.swift
//  Time Arrangement
//
//  Created by TIANDA LIU on 3/18/20.
//  Copyright © 2020 sunan xiang. All rights reserved.
//

import Foundation
import UIKit

class TimeLineView: UIView {
    
    //
    // MARK: Animation of ProgressView
    //
    
    override func draw(_ rect: CGRect) {
        let width = rect.width
        let height = rect.height
        
        let circle = UIBezierPath(arcCenter: CGPoint(x: width/2, y: height/2), radius: 5, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        circle.stroke()
            
        
        let lines = UIBezierPath()
        lines.move(to: CGPoint(x: width/2, y: 0))
        lines.addLine(to: CGPoint(x: width/2, y: height/2 - 5))
        lines.move(to: CGPoint(x: width/2, y: height/2 + 5))
        lines.addLine(to: CGPoint(x: width/2, y: height))
        lines.lineWidth = 1
        lines.setLineDash([10, 5], count: 2, phase: 0)
        UIColor(red: 146/255, green: 207/255, blue: 158/255, alpha: 1).setStroke()
        lines.stroke()
            
    }
}
