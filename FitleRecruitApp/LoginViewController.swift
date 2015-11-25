//
//  LoginViewController.swift
//  FitleRecruitApp
//
//  Created by Yoann Cribier on 18/11/15.
//  Copyright © 2015 Yoann Cribier. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController {
    
    var user = User()
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!

    @IBAction func login() {
        enter()
        
        if !validate() { return }
        
        user.login(emailField.text!, password: passwordField.text!) {
            (error) in
            if error != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    self.messageLabel.text = error!
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.messageLabel.text = "Successfully logged"
                    
                    if let token = self.user.token {
                        let secretView = self.storyboard!.instantiateViewControllerWithIdentifier("SecretView") as! SecretViewController
                        secretView.userToken = token
                        // wait 1 sec before displaying secret view
                        let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
                        dispatch_after(delay, dispatch_get_main_queue()) {
                            self.presentViewController(secretView, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func register() {
        enter()
        
        if !validate() { return }

        user.register(emailField.text!, password: passwordField.text!) {
            (error) in
            if error != nil {
                dispatch_async(dispatch_get_main_queue()) {
                    self.messageLabel.text = error!
                }
            } else {
                dispatch_async(dispatch_get_main_queue()) {
                    self.messageLabel.text = "Account created successfully"
                }
            }
        }
    }
    
    func enter() {
        // clear message label
        messageLabel.text = ""
        
        // dismiss keyboard
        self.view.endEditing(true)
    }
    
    func validate() -> Bool {
        func isValidEmail(str: String) -> Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
            
            return emailTest.evaluateWithObject(str)
        }
        
        if (emailField.text ?? "").isEmpty  {
            messageLabel.text = "Missing email"
            return false
        }
        
        //        if !isValidEmail(emailField.text!) {
        //            messageLabel.text = "Invalid email"
        //            return false
        //        }
        
        
        if (passwordField.text ?? "").isEmpty {
            messageLabel.text = "Missing password"
            return false
        }
        
        return true
    }
    
}
