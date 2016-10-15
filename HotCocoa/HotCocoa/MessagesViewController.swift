//
//  MessagesViewController.swift
//  HotCocoa
//
//  Created by Chase Roossin on 10/11/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import BBBadgeBarButtonItem
import Fusuma

class MessagesViewController: JSQMessagesViewController {
    var messages = [JSQMessage]()

    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var outgoingAvatar: JSQMessagesAvatarImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!

    var nickname: String = UserService.sharedInstance.getUserID()
    var roomname: String?
    var hasSeenNotification: Bool = false

    var userBadgeButton: BBBadgeBarButtonItem?

    var isTyping: Bool = false {
        willSet(newValue){
            if isTyping != newValue {
                if let roomname = roomname {
                    SocketManager.sharedInstance.emitTypingStatus(newValue, room: roomname, nickname: nickname)
                }
            }
        }
    }

    var othersTyping: Bool = false{
        didSet{
            self.showTypingIndicator = othersTyping
            self.scrollToBottomAnimated(true)
        }
    }

    var activeUsers = []

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

        outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(self.nickname.getInitials(), backgroundColor: UIColor.lightGrayColor(), textColor: UIColor.darkGrayColor(), font: UIFont(name: "Avenir-Book", size: 14), diameter: 34)

        //Navigationbar
        let userButton = UIButton()
        userButton.setImage(UIImage(named: "user"), forState: .Normal)
        userButton.frame = CGRectMake(0, 0, 25, 25)
        userButton.addTarget(self, action: #selector(MessagesViewController.displayUsers), forControlEvents: .TouchUpInside)

        userBadgeButton = BBBadgeBarButtonItem(customUIButton: userButton)
        navigationItem.rightBarButtonItem = userBadgeButton
    }

    private func joinRoom(){

        guard let roomname = roomname else {
            let randomTitleIndex = Int(arc4random_uniform(UInt32(MessageTitles.Error.count)))
            AlertController.displayBanner(.Error, title: MessageTitles.Error[randomTitleIndex], message: Errors.Messages.CantJoinRoom)
            return
        }

        //Warn the users about random username
        if !UserService.sharedInstance.hasSeenRandomUsernameWarning() {
            AlertController.displayBanner(.Info, title: MessageTitles.RandomUsernameTitle(self.nickname), message: MessageBody.RandomUsernameBody + self.nickname)

            UserService.sharedInstance.setHasSeenRandomUsernameWarning()
        }

        //Connect to Room and get all messages
        SocketManager.sharedInstance.connectToRoomWithNickname(roomname, nickname: self.nickname) {[weak self] (messages) in

            if messages.count == 0{
                self?.showNoMessageAnimationText()
            }else{
                self?.messages = messages
                self?.collectionView.reloadData()
                self?.scrollToBottomAnimated(false)
            }
        }

        //Add yourself as a listener for new messages
        SocketManager.sharedInstance.becomeListenerForRoom(roomname) {[weak self] (message) in

            if let message = message {
                self?.displayMsg(message)
                self?.finishReceivingMessageAnimated(true)
            }
        }

        //Add yourself as a listener for active user and typing list changes
        SocketManager.sharedInstance.getNotifiedForTypingAndUserChanges(roomname) {[weak self] (isTyping, array) in

            //Call back was for typing update
            if isTyping {
                guard let _isTyping = self?.isTyping else { return }
                self?.othersTyping = array.count == 0 ? false : ((array.count == 1) && !(_isTyping)) || array.count > 1
            }

            //Callback was for user update
            else {
                self?.activeUsers = array
                self?.userBadgeButton?.badgeValue = "\(array.count - 1)"
                guard let _hasSeenNotification = self?.hasSeenNotification else { return }
                if array.count == 2 && !_hasSeenNotification{
                    AlertController.displayBanner(.Success, title: MessageTitles.Connected, message: MessageBody.ConnectedToChatOneOther)
                    self?.hasSeenNotification = true
                }else if array.count > 2 && !_hasSeenNotification{
                    AlertController.displayBanner(.Success, title: MessageTitles.Connected, message: MessageBody.ConnectedToMulptiple(array.count))
                    self?.hasSeenNotification = true
                }
            }
        }
    }

    func displayUsers(){
        if activeUsers.count > 1 {
            AlertController.displayBanner(.Success, title: MessageTitles.UsersConnectedPopUp, message: MessageBody.ConnectedUsersMessage(activeUsers.count-1))
        }else{
            AlertController.displayBanner(.Warning, title: MessageTitles.UsersConnectedAlone, message: MessageBody.ConnectUserAloneMessage)
        }
    }

    private func showNoMessageAnimationText(){
        showTypingIndicator = true

        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.messages.append(JSQMessage(senderId: "Robot", displayName: "Hot Cocoa", text: "Welcome!"))
            self.finishReceivingMessageAnimated(true)
            self.showTypingIndicator = true

            dispatch_after(delayTime, dispatch_get_main_queue()) {
                guard let roomname = self.roomname else { return }
                self.messages.append(JSQMessage(senderId: "Robot", displayName: "Hot Cocoa", text: "You are the first one here.  Feel free to start a conversation about \(roomname)."))
                self.finishReceivingMessageAnimated(true)
            }
        }

    }

    func displayMsg(message: JSQMessage){
        messages.append(message)
        self.finishReceivingMessage()
    }

    func displayMsg(id: String, displayName: String, text: String, image: UIImage? = nil) {
        if let mediaImage = image {
            messages.append(JSQMessage(senderId: id, senderDisplayName: displayName, date: NSDate(), media: JSQPhotoMediaItem(image: mediaImage)))
        }else{
            messages.append(JSQMessage(senderId: id, senderDisplayName: displayName, date: NSDate(), text: text))
        }
        self.finishSendingMessage()
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

        return cell
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item]

        let attributes: [String : AnyObject] = [
            NSForegroundColorAttributeName: UIColor.lightGrayColor(),
            NSFontAttributeName: UIFont(name: "Avenir-Book", size: 10)!
        ]

        return NSAttributedString(string: message.senderDisplayName, attributes: attributes)
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = messages[indexPath.item]

        //Don't display header if it is your message
        if message.senderId == self.nickname { return 0 }

        if indexPath.item - 1 >= 0 {
            let previousMessage = messages[indexPath.item - 1]

            //If the same user send multiple messages in a row
            if message.senderId == previousMessage.senderId {
                return 0
            }
        }

        return 15
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item]

        return message.senderId == self.nickname ? outgoingAvatar : JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(message.senderDisplayName.getInitials(), backgroundColor: UIColor.lightGrayColor(), textColor: UIColor.darkGrayColor(), font: UIFont(name: "Avenir-Book", size: 14), diameter: 34)
    }

    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {

        self.isTyping = false

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
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.hasVideo = false
        self.presentViewController(fusuma, animated: true, completion: nil)
    }


    //Text input view override
    override func textViewDidChange(textView: UITextView) {

        self.isTyping = textView.text.characters.count > 0

        super.textViewDidChange(textView)
    }
}

extension MessagesViewController : FusumaDelegate {

    func fusumaImageSelected(image: UIImage) {

        self.view.userInteractionEnabled = false

        DataProvider.uploadImage(image) {[weak self] (success, url) in

            self?.view.userInteractionEnabled = true

            if success {
                guard let nickname = self?.nickname, roomname = self?.roomname else { return }
                print(image.size.width)
                print(image.size.height)
                SocketManager.sharedInstance.sendMessageToRoom(roomname, message: "", nickname: nickname, imageUrl: url, width: image.size.width, height: image.size.height)
                self?.displayMsg(nickname, displayName: nickname, text: "", image: image)
            }
        }
    }

    func fusumaCameraRollUnauthorized() {
        
    }

    func fusumaVideoCompleted(withFileURL fileURL: NSURL) {

    }
}
