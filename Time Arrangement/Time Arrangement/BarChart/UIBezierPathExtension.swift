//
//  UIBezierPathExtension.swift
//  BarChart
//
//  Created by sunan xiang on 2020/3/15.
//  Copyright © 2020 sunan xiang. All rights reserved.
//

import UIKit


//
// MARK:
// Resource: https://github.com/nhatminh12369/BarChart/tree/master/BarChart
//

extension UIBezierPath {

    convenience init(lineSegment: LineSegment) {
        self.init()
        self.move(to: lineSegment.startPoint)
        self.addLine(to: lineSegment.endPoint)
    }
}
