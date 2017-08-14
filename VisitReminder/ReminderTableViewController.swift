//
//  ReminderTableViewController.swift
//  VisitReminder
//
//  Created by Jackie Chan on 8/14/17.
//  Copyright © 2017 Jackie Chan. All rights reserved.
//

import UIKit

class ReminderTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var reminders = [Reminder]()
    
    // MARK: Private Methods
    
    private func loadSampleReminders() {
        
        let now = Date()
        
        guard let reminder1 = Reminder(city: "New York", state: "New York", lastvisitdate: now, remindafter: 1) else {
            fatalError("Unable to instantiate reminder1")
        }
        
        guard let reminder2 = Reminder(city: "Washington", state: "Washington", lastvisitdate: now, remindafter: 2) else {
            fatalError("Unable to instantiate reminder1")
        }
        
        guard let reminder3 = Reminder(city: "Boston", state: "Massachusetts", lastvisitdate: now, remindafter: 3) else {
            fatalError("Unable to instantiate reminder1")
        }
        
        reminders += [reminder1, reminder2, reminder3]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Load the sample data
        loadSampleReminders()
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
        cell.remainDayLabel.text = String(describing: reminder.remindafter)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
