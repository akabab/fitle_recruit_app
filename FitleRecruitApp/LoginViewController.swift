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
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    func isValidEmail(str: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)

        return emailTest.evaluateWithObject(str)
    }
    
    @IBAction func login() {
        messageLabel.text = ""
        
        if (emailField.text ?? "").isEmpty  {
            messageLabel.text = "Missing email"
            return
        }
//        else if !isValidEmail(emailField.text!) {
//            messageLabel.text = "Invalid email"
//            return
//        }
        
        
        if (passwordField.text ?? "").isEmpty {
            messageLabel.text = "Missing password"
            return
        }
        
        let params = [
            "email": emailField.text!,
            "password": passwordField.text!
        ]
        
        let request = HTTP.formatPostRequest("http://recruiting.api.fitle.com/user/token", params: params)
        
        HTTP.sendRequest(request) {
            (data, response, error) in
            if error != nil {
                print(error!)
                dispatch_async(dispatch_get_main_queue()) {
                    self.messageLabel.text = error!
                }
            } else {
                let jsonData = JSON.stringToDictionary(data)
                print(jsonData)
                
                if let errorMessage = jsonData["error"] {
                    print(errorMessage)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.messageLabel.text = errorMessage as? String
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.messageLabel.text = "Successfully logged"
                        if let token = jsonData["token"] {
                            let secretView = self.storyboard!.instantiateViewControllerWithIdentifier("SecretView") as! SecretViewController
                            secretView.userToken = token as? String
                            self.presentViewController(secretView, animated: true, completion: nil)
                        } else {
                            print("Error: no token retrieved!")
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func register() {
        messageLabel.text = ""
        
        if (emailField.text ?? "").isEmpty  {
            print("Missing email")
            messageLabel.text = "Missing email"
            return
        }
        
        if (passwordField.text ?? "").isEmpty {
            print("Missing password")
            messageLabel.text = "Missing password"
            return
        }
        
        let params = [
            "email": emailField.text!,
            "password": passwordField.text!
        ]
            
        let request = HTTP.formatPostRequest("http://recruiting.api.fitle.com/user/create", params: params)
        
        HTTP.sendRequest(request) {
            (data, response, error) in
            if error != nil {
                print(error!)
                dispatch_async(dispatch_get_main_queue()) {
                    self.messageLabel.text = error!
                }
            } else {
                let jsonData = JSON.stringToDictionary(data)
                print(jsonData)
                
                if let errorMessage = jsonData["error"] {
                    print(errorMessage)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.messageLabel.text = errorMessage as? String
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.messageLabel.text = "Account created succesfully"
                    }
                }
            }
        }
    }
    
}
