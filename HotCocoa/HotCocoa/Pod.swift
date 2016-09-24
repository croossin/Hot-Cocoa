//
//  Pod.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/1/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit

//Creates CocoaControl Object [cocoacontrols.com]
class Pod {

    var name: String
    var url: String
    var imageUrl: String
    var dateAdded: NSDate
    var dateAddedPretty: String
    var license: String
    var amountOfVotes: Int
    var appetize: String
    var language: String
    var githubLink: String
    var description: String
    var author: CocoaControlAuthor
    var tags: [String]

    init(name: String, url: String, imageUrl: String, dateAdded: NSDate, dateAddedPretty: String, license: String, amountOfVotes: Int, appetize: String, language: String, githubLink: String, description: String, author: CocoaControlAuthor, tags: [String]) {
        self.name = name
        self.url = url
        self.imageUrl = imageUrl
        self.dateAdded = dateAdded
        self.dateAddedPretty = dateAddedPretty
        self.license = license
        self.amountOfVotes = amountOfVotes
        self.appetize = appetize
        self.language = language
        self.githubLink = githubLink
        self.description = description
        self.author = author
        self.tags = tags
    }

    func minifyPrettyDate() -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"

        return dateFormatter.stringFromDate(self.dateAdded)
    }

    func githubUsername() -> String?{
        return self.githubLink.sliceFrom(".com/", to: "/")
    }
}
