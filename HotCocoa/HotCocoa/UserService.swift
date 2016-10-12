//
//  UserService.swift
//  HotCocoa
//
//  Created by Chase Roossin on 10/12/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import Foundation
import SwiftRandom

class UserService {

    static let sharedInstance = UserService()

    func getUserID() -> String{
        if let user = NSUserDefaults.standardUserDefaults().dictionaryForKey(UserDefaults.UserKey){
            if let userID = user["userID"] as? String{
                return userID
            }
        } else {
            //Didnt find - now to create, save, and return
            let fakeName = Randoms.randomFakeName()

            let user: [String: AnyObject] = [
                "userID": fakeName,
                "userName": fakeName
            ]

            NSUserDefaults.standardUserDefaults().setObject(user, forKey: UserDefaults.UserKey)

            return fakeName
        }

        return ""
    }
}