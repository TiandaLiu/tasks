//
//  BarEntry.swift
//  BarChart
//
//  Created by sunan xiang on 2020/3/15.
//  Copyright © 2020 sunan xiang. All rights reserved.
//

import Foundation
import UIKit

//
// MARK: - Structure of data entry
// Resource: https://github.com/nhatminh12369/BarChart/tree/master/BarChart
//

struct DataEntry {
    let color: UIColor
    
    /// Ranged from 0.0 to 1.0
    let height: Double
    
    /// To be shown on top of the bar
    let textValue: String
    
    /// To be shown at the bottom of the bar
    let title: String
}
