//
//  Enums.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/2/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import Foundation

enum PodSorting: String{
    case Recent    = "Recent"
    case Rating    = "Rating"
    case Swift     = "Swift"
    case ObjC      = "ObjC"
    case Simulator = "Simulator"

    init?(id : Int) {
        switch id {
        case 0:
            self = .Recent
        case 1:
            self = .Rating
        case 2:
            self = .Swift
        case 3:
            self = .ObjC
        case 4:
            self = .Simulator
        default:
            return nil
        }
    }
}

enum Platform: String{
    case IOS      = "ios"
    case OSX      = "osx"
    case WATCHOS  = "watchos"
    case TVOS     = "tvos"

    init?(id : Int) {
        switch id {
        case 0:
            self = .IOS
        case 1:
            self = .OSX
        case 2:
            self = .WATCHOS
        case 3:
            self = .TVOS
        default:
            return nil
        }
    }
}

enum DetailedInfo: String{
    case GitHub    = "GitHub"
    case CodeBase  = "Codebase"
    case Downloads = "Downloads"
    case Installs  = "Installs"

    init?(id : Int) {
        switch id {
        case 0:
            self = .GitHub
        case 1:
            self = .CodeBase
        case 2:
            self = .Downloads
        case 3:
            self = .Installs
        default:
            return nil
        }
    }
}