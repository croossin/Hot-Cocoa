//
//  DataHandler.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/2/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit
import SwiftyJSON
import JSQMessagesViewController

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

        var author: Author = Author(name: "", email: "")
        var gh: GitHub = GitHub(issues: "", stars: "", contributors: "", pullRequests: "", watchers: "", forks: "")
        var codebase: Codebase = Codebase(files: "", size: "", linesOfCode: "")
        var downloads: Downloads = Downloads(total: "", week: "", month: "")
        var installs: Installs = Installs(apps: "", appsThisWeek: "", podTries: "")

        for i in 0...json.count-1{

            let name            = json[i]["name"].stringValue
            let url             = json[i]["url"].stringValue
            let description     = json[i]["description"].stringValue
            let version         = json[i]["version"].stringValue
            let lastRelease     = json[i]["details"]["lastRelease"].stringValue
            let language        = json[i]["details"]["language"].stringValue
            let license         = json[i]["details"]["license"].stringValue
            let documentation   = json[i]["documentation"].boolValue

            author.name        = json[i]["author"]["name"].stringValue
            author.email       = json[i]["author"]["email"].stringValue

            gh.issues          = json[i]["details"]["github"]["issues"].stringValue
            gh.stars           = json[i]["details"]["github"]["stars"].stringValue
            gh.contributors    = json[i]["details"]["github"]["contributors"].stringValue
            gh.pullRequests    = json[i]["details"]["github"]["pullRequests"].stringValue
            gh.watchers        = json[i]["details"]["github"]["watchers"].stringValue
            gh.forks           = json[i]["details"]["github"]["forks"].stringValue

            codebase.files     = json[i]["details"]["codebase"]["files"].stringValue
            codebase.size      = json[i]["details"]["codebase"]["size"].stringValue
            codebase.linesOfCode = json[i]["details"]["codebase"]["linesOfCode"].stringValue

            downloads.total    = json[i]["details"]["downloads"]["total"].stringValue
            downloads.week     = json[i]["details"]["downloads"]["week"].stringValue
            downloads.month    = json[i]["details"]["downloads"]["month"].stringValue

            installs.apps      = json[i]["details"]["installs"]["apps"].stringValue
            installs.appsThisWeek = json[i]["details"]["installs"]["appsThisWeek"].stringValue
            installs.podTries  = json[i]["details"]["installs"]["podTries"].stringValue

            var tags            = [String]()

            for (key,subJson):(String, JSON) in json[i]["details"]["tags"] {
                if let tag = subJson.string{
                    tags.append(tag)
                }
            }

            listOfPods.append(CocoaPod(name: name, url: url, description: description, version: version, lastRelease: lastRelease, language: language, license: license, documentation: documentation, tags: tags, author: author, github: gh, codebase: codebase, downloads: downloads, installs: installs))
        }

        return listOfPods
    }

    class func dataToMessages(data: [[String: AnyObject]]) -> [JSQMessage]{
        var messages = [JSQMessage]()

        if data.count <= 0 { return [] }

        for i in 0...data.count-1{

            guard let senderID = data[i]["senderID"] as? String,
                senderDisplayName = data[i]["senderDisplayName"] as? String,
                stringDate = data[i]["composedDate"] as? String,
                date = stringDate.toNSDate(),
                message = data[i]["message"] as? String
                else { return []}

            //It was an image message
            if let imageUrl = data[i]["imageUrl"] as? String, width = data[i]["width"] as? CGFloat, height = data[i]["height"] as? CGFloat{
                let mediaItem = AsyncPhotoMediaItem(withURL: imageUrl, imageSize: CGSizeMake(width, height), isOperator: senderID == UserService.sharedInstance.getUserID())
                messages.append(JSQMessage(senderId: imageUrl, senderDisplayName: senderDisplayName, date: date, media: mediaItem))
            }else{
                messages.append(JSQMessage(senderId: senderID, senderDisplayName: senderDisplayName, date: date, text: message))
            }
        }

        return messages
    }

    class func dataToSingleMessage(data: [String: AnyObject]) -> JSQMessage? {

        //New message is ours - dont show
        if let userID = data["senderID"] where userID as? String == UserService.sharedInstance.getUserID() {
            return nil
        } else {
            //it isnt return it

            guard let senderID = data["senderID"] as? String,
                      senderDisplayName = data["senderDisplayName"] as? String,
                      stringDate = data["composedDate"] as? String,
                      date = stringDate.toNSDate(),
                      message = data["message"] as? String
                      else { return nil}


            return JSQMessage(senderId: senderID, senderDisplayName: senderDisplayName, date: date, text: message)
        }
    }
}
