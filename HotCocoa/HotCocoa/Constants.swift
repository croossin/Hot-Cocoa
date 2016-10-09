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
//    static let MAIN_URL: String = "https://shielded-plateau-69173.herokuapp.com/api/v1"
    static let MAIN_URL: String = "http://localhost:8081/api/v1"
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
}

struct Credit{
    static let Icons = [
        (title: "Time Return", author: "Hans Draiman", website: "Noun Project", url: "https://thenounproject.com/term/time-return/592187"),
        (title: "H File", author: "Arthur Shlain", website: "Noun Project", url: "https://thenounproject.com/term/h-file/272711"),
        (title: "Swift File", author: "Viktor Vorobyev", website: "Noun Project", url: "https://thenounproject.com/term/swift-file/342075"),
        (title: "Search", author: "Creative Outlet", website: "Noun Project", url: "https://thenounproject.com/term/search/581925"),
        (title: "Smart Watch", author: "M", website: "Noun Project", url: "https://thenounproject.com/search/?q=apple+watch&i=76125"),
        (title: "Command", author: "Johan Cato", website: "Noun Project", url: "https://thenounproject.com/term/command/432301"),
        (title: "iPhone", author: "Edward Boatman", website: "Noun Project", url: "https://thenounproject.com/term/iphone/414"),
        (title: "Menu", author: "Milky - Digital Innovation", website: "Noun Project", url: "https://thenounproject.com/search/?q=menu&creator=246241&i=105216")
    ]
}