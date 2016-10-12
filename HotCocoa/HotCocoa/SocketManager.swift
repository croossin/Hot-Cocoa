//
//  SocketManager.swift
//  HotCocoa
//
//  Created by Chase Roossin on 10/11/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit
import SocketIO
import JSQMessagesViewController

class SocketManager: NSObject {

    static let sharedInstance = SocketManager()

    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: Network.MAIN_URL_FOR_SOCKETS)!)

    override init() {
        super.init()
    }

    //Initial connection to server
    func establishConnection() {
        socket.connect()
    }

    //Disconnect from server
    func closeConnection() {
        socket.disconnect()
    }

    //Conect to a room
    func connectToRoomWithNickname(room: String, nickname: String, completionHandler: (messages: [JSQMessage]) -> Void){
        //Connect us to the room on the server
        socket.emit(Socket.ConnectUserToRoom, room, nickname)

        //Get existing messages in current room back from server
        socket.on(room + Socket.Endpoints.MainMessage) { ( data, ack) -> Void in
            guard let data = data.first as? [[String: AnyObject]] else { return }
            completionHandler(messages: DataHandler.dataToMessages(data))
        }
    }

    //Disconnect from room
    func disconnectFromRoom(room: String, nickname: String){
        socket.emit(Socket.DisconnectFromRoom, room, nickname)
    }

    //Add yourself as a listener for newMessages
    func becomeListenerForRoom(room: String, completionHandler: (message: JSQMessage?) -> Void){

        socket.on(room + Socket.Endpoints.NewChatMessage) { (data, socketAck) -> Void in
            guard let data = data.first as? [String: AnyObject] else { return }
            completionHandler(message: DataHandler.dataToSingleMessage(data))
        }
    }

    //Add yourself for typing and user changes
    func getNotifiedForTypingAndUserChanges(room: String, completionHandler: (isTypingUpdate: Bool, array: [String: AnyObject]) -> Void){

        //Get updates on users
        socket.on(room + Socket.Endpoints.Users) { (data, socketAck) -> Void in
            guard let data = data.first as? [String: AnyObject] else { return }
            completionHandler(isTypingUpdate: false, array: data)
        }

        //Get updates on users whom are typing
        socket.on(room + Socket.Endpoints.TypingUpdate) { (data, socketAck) -> Void in
            guard let data = data.first as? [String: AnyObject] else { return }
            completionHandler(isTypingUpdate: true, array: data)
        }
    }

    //Send typing status to room
    func emitTypingStatus(isTyping: Bool, room: String, nickname: String){
        socket.emit(room  + (isTyping ? Socket.Endpoints.StartTyping : Socket.Endpoints.EndTyping ), room, nickname)
    }

    func sendMessageToRoom(room: String, message: String, nickname: String){
        socket.emit(Socket.Endpoints.ChatMessage, room, nickname, message)
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
