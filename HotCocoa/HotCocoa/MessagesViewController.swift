//
//  MessagesViewController.swift
//  HotCocoa
//
//  Created by Chase Roossin on 10/11/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class MessagesViewController: JSQMessagesViewController {
    var messages = [JSQMessage]()

    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var outgoingAvatar: JSQMessagesAvatarImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    var incomingAvatar: JSQMessagesAvatarImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {

        self.title = "\(self.senderId)'s Chat"

        //For Chat UI
        self.senderDisplayName = "Sender"

        let bubbleImageFactory = JSQMessagesBubbleImageFactory()

        outgoingBubbleImageView = bubbleImageFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImageView = bubbleImageFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())

        outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "user") ?? UIImage(), diameter: UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width))
        incomingAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "exis-logo")  ?? UIImage(), diameter: UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width))
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
//        app.publish("chat", text) //User sent - publish to Exis
        displayMsg(senderId, displayName: "Me", text: text)
        finishSendingMessage()
    }

    override func didPressAccessoryButton(sender: UIButton!) {
        print("Camera pressed!")
    }

}
