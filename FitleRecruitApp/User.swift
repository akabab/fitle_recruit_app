//
//  User.swift
//  FitleRecruitApp
//
//  Created by Yoann Cribier on 25/11/15.
//  Copyright © 2015 Yoann Cribier. All rights reserved.
//

import Foundation

class User {
    
    var email: String?
    var token: String?
    var id: Int?
    
    func login(email: String, password: String, callback: (error: String?) -> Void) {
        
        let request = HTTP.formatPostRequest("http://recruiting.api.fitle.com/user/token", params: ["email": email, "password": password])
        
        HTTP.sendRequest(request) {
            (data, response, error) in
            if error != nil {
                callback(error: error)
                return
            }
            
            let jsonData = JSON.stringToDictionary(data)
            if let errorMessage = jsonData["error"] as? String {
                callback(error: errorMessage)
                return
            }
            
            if let token = jsonData["token"] as? String {
                self.email = email
                self.token = token
                self.id = jsonData["id"] as? Int
                
                callback(error: nil)
            } else {
                callback(error: "No token retrieved")
            }
        }
    }
    
    func register(email: String, password: String, callback: (error: String?) -> Void) {
        
        let request = HTTP.formatPostRequest("http://recruiting.api.fitle.com/user/create", params: ["email": email, "password": password])
        
        HTTP.sendRequest(request) {
            (data, response, error) in
            if error != nil {
                callback(error: error)
                return
            }
            
            let jsonData = JSON.stringToDictionary(data)
            if let errorMessage = jsonData["error"] as? String {
                callback(error: errorMessage)
                return
            }
            
            callback(error: nil)
        }
    }
}