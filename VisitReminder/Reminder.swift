//
//  Reminder.swift
//  VisitReminder
//
//  Created by Jackie Chan on 8/14/17.
//  Copyright © 2017 Jackie Chan. All rights reserved.
//

import UIKit
import os.log

class Reminder: NSObject, NSCoding {
    
    // MARK: Properties
    
    var city: String
    var state: String
    var lastvisitdate: Date
    var remindafter: Int
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("reminders")
    
    // MARK: Types
    
    struct PropertyKey {
        static let city = "city"
        static let state = "state"
        static let lastvisitdate = "lastvisitdate"
        static let remindafter = "remindafter"
        
    }
    
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
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(city, forKey: PropertyKey.city)
        aCoder.encode(state, forKey: PropertyKey.state)
        aCoder.encode(lastvisitdate, forKey: PropertyKey.lastvisitdate)
        aCoder.encode(remindafter, forKey: PropertyKey.remindafter)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let city = aDecoder.decodeObject(forKey: PropertyKey.city) as? String else {
            os_log("Unable to decode the city for a Reminder object.", log: OSLog.default, type: .debug)
            return nil
        }
        let state = aDecoder.decodeObject(forKey: PropertyKey.state) as? String
        let lastvisitdate = aDecoder.decodeObject(forKey: PropertyKey.lastvisitdate) as? Date
        let remindafter = aDecoder.decodeInteger(forKey: PropertyKey.remindafter)
        
        self.init(city: city, state: state!, lastvisitdate: lastvisitdate!, remindafter: remindafter)
    }
}
