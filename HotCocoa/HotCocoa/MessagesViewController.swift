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

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        joinRoom()
    }

    override func viewWillDisappear(animated: Bool) {

        //Back button pressed - leave room
        if self.navigationController?.viewControllers.indexOf(self) == nil {
            SocketManager.sharedInstance.disconnectFromRoom(self.senderId, nickname: UserService.sharedInstance.getUserID())
        }
        super.viewWillDisappear(animated)
    }

    private func setup() {

        self.title = "\(self.senderId)'s Chat"

        //For Chat UI
        self.senderDisplayName = UserService.sharedInstance.getUserID()

        let bubbleImageFactory = JSQMessagesBubbleImageFactory()

        outgoingBubbleImageView = bubbleImageFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImageView = bubbleImageFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())

        outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "user") ?? UIImage(), diameter: UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width))
        incomingAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "exis-logo")  ?? UIImage(), diameter: UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width))
    }

    private func joinRoom(){
        //Connect to Room and get all messages
        SocketManager.sharedInstance.connectToRoomWithNickname(self.senderId, nickname: UserService.sharedInstance.getUserID()) {[weak self] (messages) in
            self?.messages = messages
            self?.finishReceivingMessage()
        }

        //Add yourself as a listener for new messages
        SocketManager.sharedInstance.becomeListenerForRoom(self.senderId) {[weak self] (message) in

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

        return message.senderId == self.senderId ? outgoingBubbleImageView : incomingBubbleImageView
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell

        let message = messages[indexPath.item]

        cell.textView!.textColor = message.senderId == senderId ? UIColor.whiteColor() : UIColor.blackColor()

        return cell
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item]

        return message.senderId == self.senderId ? outgoingAvatar : incomingAvatar
    }

    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {

        SocketManager.sharedInstance.sendMessageToRoom(self.senderId, message: text, nickname: senderDisplayName)

        displayMsg(self.senderId, displayName: senderDisplayName, text: text)
        finishSendingMessage()
    }

    override func didPressAccessoryButton(sender: UIButton!) {
        print("Camera pressed!")
    }
}
