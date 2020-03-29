//
//  BasicBarEntry.swift
//  BarChart
//
//  Created by sunan xiang on 2020/3/15.
//  Copyright © 2020 sunan xiang. All rights reserved.
//

import Foundation
import CoreGraphics.CGGeometry

//
// MARK: - Frame of data entry
// Resource: https://github.com/nhatminh12369/BarChart/tree/master/BarChart
//

struct BasicBarEntry {
    let origin: CGPoint
    let barWidth: CGFloat
    let barHeight: CGFloat
    let space: CGFloat
    let data: DataEntry
    
    var bottomTitleFrame: CGRect {
        return CGRect(x: origin.x - space/2, y: origin.y + 10 + barHeight, width: barWidth + space, height: 22)
    }
    
    var textValueFrame: CGRect {
        return CGRect(x: origin.x - space/2, y: origin.y - 30, width: barWidth + space, height: 22)
    }
    
    var barFrame: CGRect {
        return CGRect(x: origin.x, y: origin.y, width: barWidth, height: barHeight)
    }
}

struct HorizontalLine {
    let segment: LineSegment
    let isDashed: Bool
    let width: CGFloat
}
