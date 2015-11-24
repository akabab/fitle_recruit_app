//
//  JSONController.swift
//  FitleRecruitApp
//
//  Created by Yoann Cribier on 18/11/15.
//  Copyright © 2015 Yoann Cribier. All rights reserved.
//

import Foundation

class JSON {
    
    class func stringToDictionary(jsonString: String) -> [String:AnyObject] {
        
        if let data: NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                if let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(
                    data,
                    options: NSJSONReadingOptions(rawValue: 0)) as? [String:AnyObject] {
                        return jsonDictionary
                }
            } catch {
                print("Error parsing JSON string: \(jsonString)")
            }
        }
        return [String:AnyObject]()
    }
    
}