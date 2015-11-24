//
//  SecretViewController.swift
//  FitleRecruitApp
//
//  Created by Yoann Cribier on 18/11/15.
//  Copyright © 2015 Yoann Cribier. All rights reserved.
//

import UIKit
import Foundation

class SecretViewController: UIViewController {
    
    var userToken: String?
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let token = userToken {
            recoverSecretMessage(token) {
                (message, error) in
                if error != nil {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.messageLabel.text = error!
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.messageLabel.text = message!
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func recoverSecretMessage (token: String, callback: (message: String?, error: String?) -> Void) {
        let request = HTTP.formatGetRequest("http://recruiting.api.fitle.com/secret")
        
        let tokenString = NSString(format: "%@:", token)
        let tokenData: NSData = tokenString.dataUsingEncoding(NSUTF8StringEncoding)!
        let base64TokenString = tokenData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        
        request.setValue("Basic \(base64TokenString)", forHTTPHeaderField: "Authorization")
        print("** request: \(request)")
        
        HTTP.sendRequest(request) {
            (data, response, error) in
            if error != nil {
                callback(message: nil, error: error)
            } else {
                if let xhr = response as? NSHTTPURLResponse {
                    if xhr.statusCode >= 400 {
                        callback(message: nil, error: data)
                        return
                    }
                }
                
                let jsonData = JSON.stringToDictionary(data)
                
                if let errorMessage = jsonData["error"] as? String {
                    callback(message: nil, error: errorMessage)
                } else {
                    if let message = jsonData["message"] as? String {
                        callback(message: message, error: nil)
                    }
                }

            }
        }
        
    }
}