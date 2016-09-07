//
//  DataHandler.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/2/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit
import SwiftyJSON

class DataHandler {

    //Returns CocoaControl Object [cocoacontrols.com]
    class func jsonToPods(json: JSON) -> [Pod]{
        var listOfPods = [Pod]()

        for i in 0...json.count-1{

            let name            = json[i]["name"].stringValue
            let url             = json[i]["url"].stringValue
            let imageUrl        = json[i]["imageUrl"].stringValue
            let dateAddedString = json[i]["dateAdded"].stringValue //Will want to convert to NSDate
            var appetize        = "" //Incase they dont have one
            if let _appetize    = json[i]["details"]["appetize"].string{
                appetize = _appetize
            }
            let dateAddedPretty = json[i]["dateAddedPretty"].stringValue
            let license         = json[i]["license"].stringValue
            let amountOfVotes   = Int(json[i]["details"]["amountOfVotes"].stringValue)
            let language        = json[i]["details"]["language"].stringValue
            let githubLink      = json[i]["details"]["githubLink"].stringValue
            let description     = json[i]["details"]["description"].stringValue
            let authorName      = json[i]["details"]["author"]["name"].stringValue
            let authorUrl       = json[i]["details"]["author"]["url"].stringValue
            let authorAvatar    = json[i]["details"]["author"]["image"].stringValue
            var tags            = [String]()

            for (key,subJson):(String, JSON) in json[i]["details"]["tags"] {
                if let tag = subJson.string{
                    tags.append(tag)
                }
            }

            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

            if let dateAdded = dateFormatter.dateFromString(dateAddedString), amountOfVotes = amountOfVotes{
                listOfPods.append(Pod(name: name, url: url, imageUrl: imageUrl, dateAdded: dateAdded, dateAddedPretty: dateAddedPretty, license: license, amountOfVotes: amountOfVotes, appetize: appetize, language: language, githubLink: githubLink, description: description, author: (authorName, authorUrl, authorAvatar), tags: tags))
            }else{
                listOfPods.append(Pod(name: name, url: url, imageUrl: imageUrl, dateAdded: NSDate(), dateAddedPretty: dateAddedPretty, license: license, amountOfVotes: 0, appetize: appetize, language: language, githubLink: githubLink, description: description, author: (authorName, authorUrl, authorAvatar), tags: tags))
            }

        }

        return listOfPods
    }

    //Returns Actual CocoaPod Object [cocoapod.org]
    class func jsonToCocoaPods(json: JSON) -> [CocoaPod]{
        var listOfPods = [CocoaPod]()

        for i in 0...json.count-1{

            let name            = json[i]["name"].stringValue
            let url             = json[i]["url"].stringValue
            let imageUrl        = json[i]["imageUrl"].stringValue
            let dateAddedString = json[i]["dateAdded"].stringValue //Will want to convert to NSDate
            var appetize        = "" //Incase they dont have one
            if let _appetize    = json[i]["details"]["appetize"].string{
                appetize = _appetize
            }
            let dateAddedPretty = json[i]["dateAddedPretty"].stringValue
            let license         = json[i]["license"].stringValue
            let amountOfVotes   = Int(json[i]["details"]["amountOfVotes"].stringValue)
            let language        = json[i]["details"]["language"].stringValue
            let githubLink      = json[i]["details"]["githubLink"].stringValue
            let description     = json[i]["details"]["description"].stringValue
            let authorName      = json[i]["details"]["author"]["name"].stringValue
            let authorUrl       = json[i]["details"]["author"]["url"].stringValue
            let authorAvatar    = json[i]["details"]["author"]["image"].stringValue
            var tags            = [String]()

        }

        return listOfPods
    }
}
