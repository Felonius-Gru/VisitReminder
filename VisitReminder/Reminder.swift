//
//  Reminder.swift
//  VisitReminder
//
//  Created by Jackie Chan on 8/14/17.
//  Copyright © 2017 Jackie Chan. All rights reserved.
//

import UIKit

class Reminder {
    
    // MARK: Properties
    
    var city: String
    var state: String
    var lastvisitdate: Date
    var remindafter: Int
    
    // MARK: Initialization
    
    init?(city: String, state: String, lastvisitdate: Date, remindafter: Int) {
        
        guard !city.isEmpty else {
            return nil
        }
        
        guard !state.isEmpty else {
            return nil
        }
        
        guard remindafter >= 0 else {
            return nil
        }
        
        self.city = city
        self.state = state
        self.lastvisitdate = lastvisitdate
        self.remindafter = remindafter
    }
}
