//
//  ReminderTableViewController.swift
//  VisitReminder
//
//  Created by Jackie Chan on 8/14/17.
//  Copyright © 2017 Jackie Chan. All rights reserved.
//

import UIKit
import os.log
import DLLocalNotifications

class ReminderTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var reminders = [Reminder]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if let savedReminders = loadReminders() {
            reminders += savedReminders
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(ReminderTableViewController.refresh), name: NSNotification.Name(rawValue: "ListShouldRefresh") , object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return reminders.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderTableViewCell", for: indexPath) as? ReminderTableViewCell else {
            fatalError("The dequeued cell is not an instance of ReminderTableViewCell")
        }

        // Configure the cell...
        let reminder = reminders[indexPath.row]
        
        cell.cityLabel.text = reminder.city
        cell.stateLabel.text = reminder.state
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let date = formatter.string(from: reminder.lastvisitdate)
        cell.lastVisitDate.text = date

        if reminder.isOverdue {
            cell.remainDayLabel.text = "Overdue"
            cell.remainDayLabel.textColor = UIColor.red
        } else {
            cell.remainDayLabel.text = "\(reminder.todeadline) min remain"
            cell.remainDayLabel.textColor = UIColor.black
        }

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let reminder = reminders[indexPath.row]

            scheduleNotification(identifier: reminder.notificationId, title: "", body: "", lastvisitdate: Date(), remindafter: -1)
            reminders.remove(at: indexPath.row)
            saveReminders()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier ?? "" {
        case "addReminderSegue":
            os_log("Adding a new reminder.", log: OSLog.default, type: .debug)
        case "editReminderSegue":
            guard let reminderDetailViewController = segue.destination as? ReminderViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedReminderCell = sender as? ReminderTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedReminderCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedReminder = reminders[indexPath.row]
            reminderDetailViewController.reminder = selectedReminder
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    // MARK: Methods
    
    func refresh() {
        tableView.reloadData()
    }

    // MARK: Private Methods
    
    private func saveReminders() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(reminders, toFile: Reminder.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Reminders successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save reminders", log: OSLog.default, type: .error)
        }
    }
    
    private func loadReminders() -> [Reminder]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Reminder.ArchiveURL.path) as? [Reminder]
    }
    
    private func scheduleNotification (identifier: String, title: String, body: String, lastvisitdate: Date, remindafter: Int) {
        // The date you would like the notification to fire at
        let triggerDate = lastvisitdate.addingTimeInterval(TimeInterval(remindafter * 60))

        let notification = DLNotification(identifier: identifier, alertTitle: title, alertBody: body, date: triggerDate, repeats: .None)
        
        let scheduler = DLNotificationScheduler()
        print(scheduler.scheduleNotification(notification: notification) ?? "")
        
//        let scheduledNotifications: [UILocalNotification]? = UIApplication.shared.scheduledLocalNotifications
//        guard scheduledNotifications != nil else {return}
    }
    
    private func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    // MARK: Actions
    
    @IBAction func unwindToReminderList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ReminderViewController, let reminder = sourceViewController.reminder {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                //Update an existing reminder
                reminders[selectedIndexPath.row] = reminder
                reminders = reminders.sorted{$0.todeadline < $1.todeadline}
                scheduleNotification(identifier: reminder.notificationId, title: "Visit \(reminder.city) in \(reminder.state)", body: "You should visit \(reminder.city) in \(reminder.state)", lastvisitdate: reminder.lastvisitdate, remindafter: reminder.remindafter)

//                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                self.refresh()
            } else {
                // Add a new reminder
                reminder.notificationId = self.randomString(length: 10)
                reminders.append(reminder)
                reminders = reminders.sorted{$0.todeadline < $1.todeadline}

                scheduleNotification(identifier: reminder.notificationId, title: "Visit \(reminder.city) in \(reminder.state)", body: "You should visit \(reminder.city) in \(reminder.state)", lastvisitdate: reminder.lastvisitdate, remindafter: reminder.remindafter)
//                tableView.insertRows(at: [newIndexPath], with: .automatic)
                self.refresh()
            }
            
            saveReminders()
        }
    }
}
