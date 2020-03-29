//
//  DateFormatter.swift
//  Time Arrangement
//
//  Created by sunan xiang on 2020/3/6.
//  Copyright © 2020 sunan xiang. All rights reserved.
//

import Foundation
import UIKit

/// Date Format type
enum DateFormatType: String {
    /// Time
    case time = "HH:mm:ss"
    
    /// Date with hours
    case dateWithTime = "dd-MMM-yyyy  H:mm"
    
    /// Date
    case date = "dd-MMM-yyyy"
}


extension Date {
    
    func convertToString(dateformat formatType: DateFormatType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatType.rawValue
        let newDate: String = dateFormatter.string(from: self)
        return newDate
    }
    
    func dateOnly() -> Date {
        let date: Date! = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: self))
        return date
    }
}
