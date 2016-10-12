//
//  Message.swift
//  HotCocoa
//
//  Created by Chase Roossin on 10/11/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit

class Message{
    var room: String
    var senderName: String
    var message: String
    var timeStamp: NSDate


    init(room: String, senderName: String, message: String, timeStamp: NSDate){
        self.room = room
        self.senderName = senderName
        self.message = message
        self.timeStamp = timeStamp
    }
}