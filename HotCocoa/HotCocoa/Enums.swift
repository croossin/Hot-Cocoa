//
//  Enums.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/2/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import Foundation

enum PodSorting: String{
    case Recent = "Recent"
    case Rating = "Rating"
    case Swift  = "Swift"
    case ObjC   = "ObjC"

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
        default:
            return nil
        }
    }
}