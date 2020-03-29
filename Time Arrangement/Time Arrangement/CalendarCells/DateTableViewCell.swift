//
//  DateTableViewCell.swift
//  InlineDatePicker
//
//  Created by sunan xiang on 2020/3/10.
//  Copyright © 2020 sunan xiang. All rights reserved.
//

import UIKit

//
// MARK: - Table Cell for the whole table
// Resource: https://github.com/rajtharan-g/InlineDatePicker
//

class DateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // Reuser identifier
    class func reuseIdentifier() -> String {
        return "DateTableViewCellIdentifier"
    }
    
    // Nib name
    class func nibName() -> String {
        return "DateTableViewCell"
    }
    
    // Cell height
    class func cellHeight() -> CGFloat {
        return 44.0
    }

    // Awake from nib method
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Update text
    func updateText(text: String, date: Date) {
        label.text = text
        dateLabel.text = date.convertToString(dateformat: .date)
    }

}
