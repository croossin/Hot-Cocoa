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

    func hasValidEmail() -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self.author.email)
    }

    func getGitHubProjectName() -> String?{
        if let projectName = self.url.componentsSeparatedByString("/").last {
            return projectName
        }

        return nil
    }

    func githubUsername() -> String?{
        return self.url.sliceFrom(".com/", to: "/")
    }

    func detailedGitHubInfo() -> String{
        return "Stars: \(self.github.stars) | Contributors: \(self.github.contributors)\nPull Requests: \(self.github.pullRequests) | Issues: \(self.github.issues)\nForks: \(self.github.forks) | Watchers: \(self.github.watchers)\n"
    }

    func detailedDownloadInfo() -> String{
        return "Total: \(self.downloads.total)\nWeek: \(self.downloads.week)\nMonth: \(self.downloads.month)"
    }

    func detailedInstallInfo() -> String{
        return "Apps: \(self.installs.apps)\nApp This Week: \(self.installs.appsThisWeek)\nPod Tries: \(self.installs.podTries)"
    }

    func detailedCodebaseInfo() -> String{
        return "Files: \(self.codebase.files)\nSize: \(self.codebase.size)\n Lines of Code: \(self.codebase.linesOfCode)"
    }
}

