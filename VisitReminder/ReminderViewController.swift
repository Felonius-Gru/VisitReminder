//
//  ViewController.swift
//  VisitReminder
//
//  Created by Jackie Chan on 8/12/17.
//  Copyright © 2017 Jackie Chan. All rights reserved.
//

import UIKit
import Foundation
import os.log

class ReminderViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var lastvisitdayDatePicker: UIDatePicker!
    @IBOutlet weak var remindafterTextField: UITextField!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    
    var reminder: Reminder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        cityTextField.delegate = self
        stateTextField.delegate = self
        remindafterTextField.delegate = self
        
        if let reminder = reminder {
            navigationItem.title = reminder.city
            cityTextField.text = reminder.city
            stateTextField.text = reminder.state
            remindafterTextField.text = String(reminder.remindafter)
            lastvisitdayDatePicker.date = reminder.lastvisitdate
        }
        
        updateSaveButtonState()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation
    @IBAction func cancel(_ sender: Any) {
        
        let isPresentingInAddReminderMode = presentingViewController is UINavigationController
        
        if isPresentingInAddReminderMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ReminderViewController is not inside a navigation controller.")
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveBarButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let city = cityTextField.text ?? ""
        let state = stateTextField.text ?? ""
        let date = lastvisitdayDatePicker.date
        let remindafter:Int? = Int(remindafterTextField.text!)
        
        // Set the reminder to be passed to ReminderTableViewController after the unwind segue.
        reminder = Reminder(notificationId: reminder?.notificationId ?? "", city: city, state: state, lastvisitdate: date, remindafter: remindafter!)
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable Save button while editing.
        saveBarButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        
        if textField == cityTextField {
            navigationItem.title = textField.text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Private Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let city = cityTextField.text ?? ""
        let state = stateTextField.text ?? ""
        let remindafter = remindafterTextField.text ?? ""
        saveBarButton.isEnabled = !city.isEmpty && !state.isEmpty && !remindafter.isEmpty
    }
}

