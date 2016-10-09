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