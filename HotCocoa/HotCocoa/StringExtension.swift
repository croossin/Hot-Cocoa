//
//  StringExtension.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/11/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import Foundation

extension String {
    func sliceFrom(start: String, to: String) -> String? {
        return (rangeOfString(start)?.endIndex).flatMap { sInd in
            (rangeOfString(to, range: sInd..<endIndex)?.startIndex).map { eInd in
                substringWithRange(sInd..<eInd)
            }
        }
    }
}