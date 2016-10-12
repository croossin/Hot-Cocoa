//
//  MessagesViewController.swift
//  HotCocoa
//
//  Created by Chase Roossin on 10/11/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import SwiftRandom

class MessagesViewController: JSQMessagesViewController {
    var messages = [JSQMessage]()

    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var outgoingAvatar: JSQMessagesAvatarImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    var incomingAvatar: JSQMessagesAvatarImage!

    var nickname: String = UserService.sharedInstance.getUserID()
    var roomname: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        joinRoom()
    }

    override func viewWillDisappear(animated: Bool) {

        //Back button pressed - leave room
        if self.navigationController?.viewControllers.indexOf(self) == nil {
            guard let roomname = roomname else { return }
            SocketManager.sharedInstance.disconnectFromRoom(roomname, nickname: self.nickname)
        }
        super.viewWillDisappear(animated)
    }

    private func setup() {
        if let roomname = roomname {
            self.title = "\(roomname)'s Chat"
        }

        //For Chat UI
        self.senderDisplayName = self.nickname

        let bubbleImageFactory = JSQMessagesBubbleImageFactory()

        outgoingBubbleImageView = bubbleImageFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImageView = bubbleImageFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())

        outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "user") ?? UIImage(), diameter: UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width))
        incomingAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "exis-logo")  ?? UIImage(), diameter: UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width))
    }

    private func joinRoom(){

        guard let roomname = roomname else {
            let randomTitleIndex = Int(arc4random_uniform(UInt32(MessageTitles.Error.count)))
            AlertController.displayBanner(.Error, title: MessageTitles.Error[randomTitleIndex], message: Errors.Messages.CantJoinRoom)
            return
        }

        //Warn the users about random username
        if !UserService.sharedInstance.hasSeenRandomUsernameWarning() {
            AlertController.displayBanner(.Info, title: MessageTitles.RandomUsernameTitle + self.nickname, message: MessageBody.RandomUsernameBody + self.nickname)

            UserService.sharedInstance.setHasSeenRandomUsernameWarning()
        }

        //Connect to Room and get all messages
        SocketManager.sharedInstance.connectToRoomWithNickname(roomname, nickname: self.nickname) {[weak self] (messages) in
            self?.messages = messages
            self?.collectionView.reloadData()
        }

        //Add yourself as a listener for new messages
        SocketManager.sharedInstance.becomeListenerForRoom(roomname) {[weak self] (message) in

            if let message = message { self?.displayMsg(message) }
        }
    }

    func displayMsg(message: JSQMessage){
        messages.append(message)
    }

    func displayMsg(id: String, displayName: String, text: String) {
        messages.append(JSQMessage(senderId: id, displayName: displayName, text: text))
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]

        return message.senderId == self.nickname ? outgoingBubbleImageView : incomingBubbleImageView
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell

        let message = messages[indexPath.item]

        cell.textView!.textColor = message.senderId == self.nickname ? UIColor.whiteColor() : UIColor.blackColor()
        cell.cellTopLabel!.text = message.senderId
        
        return cell
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item]

        return message.senderId == self.nickname ? outgoingAvatar : incomingAvatar
    }

    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {

        guard let roomname = roomname else {
            let randomTitleIndex = Int(arc4random_uniform(UInt32(MessageTitles.Error.count)))
            AlertController.displayBanner(.Error, title: MessageTitles.Error[randomTitleIndex], message: Errors.Messages.CantSendMessage)
            return
        }

        SocketManager.sharedInstance.sendMessageToRoom(roomname, message: text, nickname: senderDisplayName)

        displayMsg(self.nickname, displayName: senderDisplayName, text: text)
        finishSendingMessage()
    }

    override func didPressAccessoryButton(sender: UIButton!) {
        print("Camera pressed!")
    }
}
