//
//  ReminderTableViewCell.swift
//  VisitReminder
//
//  Created by Jackie Chan on 8/12/17.
//  Copyright © 2017 Jackie Chan. All rights reserved.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var remainDayLabel: UILabel!
    @IBOutlet weak var lastVisitDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
