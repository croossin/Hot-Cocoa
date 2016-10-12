//
//  SocketManager.swift
//  HotCocoa
//
//  Created by Chase Roossin on 10/11/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit
import SocketIO

class SocketManager: NSObject {

    static let sharedInstance = SocketManager()

    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: Network.MAIN_URL_FOR_SOCKETS)!)

    override init() {
        super.init()
    }

    func establishConnection() {
        socket.connect()
    }


    func closeConnection() {
        socket.disconnect()
    }

    func connectToRoomWithNickname(room: String, nickname: String, completionHandler: (messages: [Message]) -> Void){
        socket.emit("connectUser", room, nickname)
        completionHandler(messages: [])
    }


    ///////////

    func connectToServerWithNickname(nickname: String, completionHandler: (userList: [[String: AnyObject]]!) -> Void) {
        socket.emit("connectUser", nickname)

        socket.on("userList") { ( dataArray, ack) -> Void in
            completionHandler(userList: dataArray[0] as! [[String: AnyObject]])
        }

        listenForOtherMessages()
    }

    func exitChatWithNickname(nickname: String, completionHandler: () -> Void) {
        socket.emit("exitUser", nickname)
        completionHandler()
    }


    func sendMessage(message: String, withNickname nickname: String) {
        socket.emit("chatMessage", nickname, message)
    }


    func getChatMessage(completionHandler: (messageInfo: [String: AnyObject]) -> Void) {
        socket.on("newChatMessage") { (dataArray, socketAck) -> Void in
            var messageDictionary = [String: AnyObject]()
            messageDictionary["nickname"] = dataArray[0] as! String
            messageDictionary["message"] = dataArray[1] as! String
            messageDictionary["date"] = dataArray[2] as! String

            completionHandler(messageInfo: messageDictionary)
        }
    }


    private func listenForOtherMessages() {
        socket.on("userConnectUpdate") { (dataArray, socketAck) -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName("userWasConnectedNotification", object: dataArray[0] as! [String: AnyObject])
        }

        socket.on("userExitUpdate") { (dataArray, socketAck) -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName("userWasDisconnectedNotification", object: dataArray[0] as! String)
        }

        socket.on("userTypingUpdate") { (dataArray, socketAck) -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName("userTypingNotification", object: dataArray[0] as? [String: AnyObject])
        }
    }


    func sendStartTypingMessage(nickname: String) {
        socket.emit("startType", nickname)
    }


    func sendStopTypingMessage(nickname: String) {
        socket.emit("stopType", nickname)
    }
}
