//
//  ArrayExtension.swift
//  BarChart
//
//  Created by sunan xiang on 2020/3/15.
//  Copyright © 2020 sunan xiang. All rights reserved.
//

import Foundation

//
// Resource: https://github.com/nhatminh12369/BarChart/tree/master/BarChart
//

extension Array {
    func safeValue(at index: Int) -> Element? {
        if index < self.count {
            return self[index]
        } else {
            return nil
        }
    }
}
