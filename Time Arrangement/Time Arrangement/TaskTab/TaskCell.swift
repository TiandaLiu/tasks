//
//  TaskCell.swift
//  Time Arrangement
//
//  Created by sunan xiang on 2020/3/5.
//  Copyright © 2020 sunan xiang. All rights reserved.
//

import Foundation
import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet var taskTitle: UILabel!
    @IBOutlet var cellRootView: UIView!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet weak var progressText: UILabel!
    
}
