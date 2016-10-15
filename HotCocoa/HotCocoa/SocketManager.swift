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

    var reconnected: Bool = false

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

    func reconnect(){
        socket.reconnect()
        reconnected = true
    }

    //Remove yourself from entire DB
    func removeSelfFromEntireDBAndCloseConnection(){
        socket.emit(Socket.RemoveSelfFromDB, UserService.sharedInstance.getUserID())
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
    func getNotifiedForTypingAndUserChanges(room: String, completionHandler: (isTypingUpdate: Bool, array: [AnyObject]) -> Void){

        //Get updates on users
        socket.on(room + Socket.Endpoints.Users) { (data, socketAck) -> Void in
            guard let data = data.first as? [AnyObject] else { return }
            completionHandler(isTypingUpdate: false, array: data)
        }

        //Get updates on users whom are typing
        socket.on(room + Socket.Endpoints.TypingUpdate) { (data, socketAck) -> Void in
            guard let data = data.first as? [AnyObject] else { return }
            completionHandler(isTypingUpdate: true, array: data)
        }
    }

    //Send typing status to room
    func emitTypingStatus(isTyping: Bool, room: String, nickname: String){
        socket.emit(room  + (isTyping ? Socket.Endpoints.StartTyping : Socket.Endpoints.EndTyping ), room, nickname)
    }

    //Send single message to room
    func sendMessageToRoom(room: String, message: String, nickname: String, imageUrl: String? = nil, width: CGFloat? = nil, height: CGFloat? = nil){
        if let imageUrl = imageUrl, width = width, height = height {
            socket.emit(room + Socket.Endpoints.ImageMessage, room, nickname, imageUrl, width, height)
        }else{
            socket.emit(room + Socket.Endpoints.ChatMessage, room, nickname, message)
        }
    }
}
