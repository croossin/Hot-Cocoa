//
//  CocoaPod.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/7/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit

//Creates Actual CocoaPod Object [cocoapods.org]
class CocoaPod {

    var name: String
    var url: String //GitHub Link
    var description: String
    var version: String
    var lastRelease: String
    var language: String
    var license: String
    var documentation: Bool
    var tags: [String]

    var author: Author
    var github: GitHub
    var codebase: Codebase
    var downloads: Downloads
    var installs: Installs

    init(name: String, url: String, description: String, version: String, lastRelease: String, language: String, license: String, documentation: Bool, tags: [String], author: Author, github: GitHub, codebase: Codebase, downloads: Downloads, installs: Installs){

        self.name = name
        self.url = url
        self.description = description
        self.version = version
        self.lastRelease = lastRelease
        self.language = language
        self.license = license
        self.documentation = documentation
        self.tags = tags

        self.author = author
        self.github = github
        self.codebase = codebase
        self.downloads = downloads
        self.installs = installs
    }
}

