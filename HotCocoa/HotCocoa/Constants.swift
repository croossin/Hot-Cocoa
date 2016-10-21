//
//  Constants.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/1/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit

struct Dimensions{
    static let NAVBAR_HEIGHT: CGFloat = 64
}

struct Network{
    static let MAIN_URL: String = "https://shielded-plateau-69173.herokuapp.com/api/v1"
//    static let MAIN_URL: String = "http://localhost:8081/api/v1"

    static let MAIN_URL_FOR_SOCKETS: String = "https://shielded-plateau-69173.herokuapp.com"
//    static let MAIN_URL_FOR_SOCKETS: String = "http://localhost:8081"


    struct Routes {
        static let Feedback: String = "/feedback"

        static let Fetch: String = "/fetch"
        static let Fetch_Tags: String = "/fetch/tags"
        static let Fetch_Rating: String = "/fetch/rating"
        static let Fetch_Swift: String = "/fetch/language/swift"
        static let Fetch_ObjC: String = "/fetch/language/objc"
        static let Fetch_Simulator: String = "/fetch/simulator"

        static let Search_Tags: String = "/search/tags/"
    }
}

struct GitHubLinks{
    static let MAIN_URL: String = "https://github.com/"
    static let IMAGE_SUFFIX: String = ".png?size=49"
}

struct DetailedScroll{
    static let DETAILED_ARRAY: NSMutableArray = [
        DetailedInfo.GitHub.rawValue,
        DetailedInfo.CodeBase.rawValue,
        DetailedInfo.Downloads.rawValue,
        DetailedInfo.Installs.rawValue,
        ]
}

struct MessageTitles{
    static let Error = ["Whoops", "Uh-Oh", "Shoot", "Darn"]
    static let Success = ["Sweet", "Awesome", "Excellent", "You Did It", "Great Job"]
    static func RandomUsernameTitle(nickname: String) -> String {return "Random Username - \(nickname)"}
    static let Connected = "Connected"
    static let UsersConnectedPopUp = "You're Not Alone"
    static let UsersConnectedAlone = "Well..."
    static let NoDataFound = ["It's Dark in Here...", "Where is everyone?", "I'm lost"]
    static let SearchingForData = ["Searching", "Squint a little harder", "We're looking for you"]
}

struct MessageBody{
    static let RandomUsernameBody = "All users are assigned a random name. Your name is: "
    static let ConnectedToChatOneOther = "There is one other person connected to this chat right now! Say hello!"
    static func ConnectedToMulptiple(count: Int) -> String {return "There are currently \(count) others connected to this chat!" }
    static func ConnectedUsersMessage(count: Int) -> String {return "You are currently in the chat with \(count) other active user!"}
    static let ConnectUserAloneMessage = "It seems that no one else is in here with you"
    static let NoDataFound = "We were unable to find any Cocoa Pods for your given search."
    static let SearchingForData = "We are currently gathering Cocoa Pods from the deep interwebs. Please be patient."
    static let NoCameraAccess = "We need access to your camera to upload images!"
}
struct Socket {
    static let ConnectUserToRoom = "connectUserToRoom"
    static let DisconnectFromRoom = "disconnectUserFromRoom"
    static let RemoveSelfFromDB = "removeFromEntireDB"

    struct Endpoints{
        static let MainMessage = "/messages"
        static let ChatMessage = "/chatMessage"
        static let ImageMessage = "/imageMessage"
        static let NewChatMessage = "/newChatMessage"
        static let Users = "/users"
        static let TypingUpdate = "/typingUpdate"
        static let StartTyping = "/startType"
        static let EndTyping = "/endType"
    }
}

struct Errors{
    struct Messages{
        static let CantJoinRoom = "We are unable to join this chat room. Try again later."
        static let CantSendMessage = "We can't send your message right now. Try again later."
        static let CantUploadImage = "Unable to Upload Image"
    }
}

struct UserDefaults {
    static let UserKey = "kUserKey"
    static let RandomUsernameWarningKey = "kRandomUsernameWarningKey"
}

struct Settings {
    static func ProfileName(nickname: String) -> String { return "Your app-wide nickname is: \(nickname)"}
    static let ProfileSubtitle = "This is your randomly assigned nickname"
    static let ProfileNameTitle = "Randomly Assigned Nicknames"
    static let ProfileNameSubtitle = "We randomly assign all users nicknames in order to keep chat conversation annonymous"
    
    struct Footers {
        static let Feedback = "All feedback is greatly appreciated"
        static let CocoaPods = "The CocoaPods used in this project"
        static let Icons = "App made possible by these great designers!"
    }
}

struct Credit{
    static let CocoaPods = [
        (title: "Alamofire", author: "Alamofire", url: "https://github.com/Alamofire/Alamofire"),
        (title: "Alamofire Image", author: "Alamofire", url: "https://github.com/Alamofire/AlamofireImage"),
        (title: "SwiftyJSON", author: "SwiftyJSON", url: "https://github.com/SwiftyJSON/SwiftyJSON"),
        (title: "SVProgressHUD", author: "SVProgressHUD", url: "https://github.com/SVProgressHUD/SVProgressHUD"),
        (title: "Segmentio", author: "Yalantis", url: "https://github.com/Yalantis/Segmentio"),
        (title: "UIScrollView-InfiniteScroll", author: "pronebird", url: "https://github.com/pronebird/UIScrollView-InfiniteScroll"),
        (title: "RAMReel", author: "Ramotion", url: "https://github.com/Ramotion/reel-search"),
        (title: "Folding Cell", author: "Ramotion", url: "https://github.com/Ramotion/folding-cell"),
        (title: "TCTitleLoading", author: "TravelC", url: "https://github.com/TravelC/TCTitleLoading"),
        (title: "TLTagsControl", author: "ali312", url: "https://github.com/ali312/TLTagsControl"),
        (title: "FCAlertView", author: "nimati", url: "https://github.com/nimati/FCAlertView"),
        (title: "CTFeedback", author: "rizumita", url: "https://github.com/rizumita/CTFeedback"),
        (title: "Bohr", author: "DavdRoman", url: "https://github.com/DavdRoman/Bohr"),
        (title: "ISMessages", author: "ilyainyushin", url: "https://github.com/ilyainyushin/ISMessages"),
        (title: "Cloudinary", author: "cloudinary", url: "https://github.com/cloudinary/cloudinary_ios"),
        (title: "Socket.IO-Client-Swift", author: "SocketIO", url: "https://github.com/socketio/socket.io-client-swift"),
        (title: "JSQMessagesViewController", author: "jessesquires", url: "https://github.com/jessesquires/JSQMessagesViewController"),
        (title: "SwiftRandom", author: "thellimist", url: "https://github.com/thellimist/SwiftRandom"),
        (title: "BBBadgeBarButtonItem", author: "TanguyAladenise", url: "https://github.com/TanguyAladenise/BBBadgeBarButtonItem"),
        (title: "Fabric", author: "Twitter", url: "https://get.fabric.io/"),
        (title: "Crashlytics", author: "Twitter", url: "https://get.fabric.io/"),
        (title: "Fusuma", author: "ytakzk", url: "https://github.com/ytakzk/Fusuma"),
        (title: "DZNEmptyDataSet", author: "dzenbot", url: "https://github.com/dzenbot/DZNEmptyDataSet")
    ]

    static let Icons = [
        (title: "Time Return", author: "Hans Draiman", website: "Noun Project", url: "https://thenounproject.com/term/time-return/592187"),
        (title: "H File", author: "Arthur Shlain", website: "Noun Project", url: "https://thenounproject.com/term/h-file/272711"),
        (title: "Swift File", author: "Viktor Vorobyev", website: "Noun Project", url: "https://thenounproject.com/term/swift-file/342075"),
        (title: "Search", author: "Creative Outlet", website: "Noun Project", url: "https://thenounproject.com/term/search/581925"),
        (title: "Smart Watch", author: "M", website: "Noun Project", url: "https://thenounproject.com/search/?q=apple+watch&i=76125"),
        (title: "Command", author: "Johan Cato", website: "Noun Project", url: "https://thenounproject.com/term/command/432301"),
        (title: "iPhone", author: "Edward Boatman", website: "Noun Project", url: "https://thenounproject.com/term/iphone/414"),
        (title: "Menu", author: "Milky - Digital Innovation", website: "Noun Project", url: "https://thenounproject.com/search/?q=menu&creator=246241&i=105216"),
        (title: "Mug", author: "Fuat şanlı", website: "Noun Project", url: "https://thenounproject.com/search/?q=hot%20cocoa&i=657447"),
        (title: "Message", author: "Dmitrij", website: "Noun Project", url: "https://thenounproject.com/search/?q=message&i=662995"),
        (title: "User", author: "Bryn Taylor", website: "Noun Project", url: "https://thenounproject.com/search/?q=user&i=101409"),
        (title: "User Placeholder", author: "Kevin White", website: "Noun Project", url: "https://thenounproject.com/search/?q=user+placeholder&i=538846"),
        (title: "Cancel", author: "Hector", website: "Noun Project", url: "https://thenounproject.com/search/?q=cnacel&i=657311")
    ]
}

struct Credentials {
    static let CloudinaryUrl = "cloudinary://638749293868572:Udn9I2nizX5TJR61hBE3c6gt3AY@dhlu6rpmd"
}