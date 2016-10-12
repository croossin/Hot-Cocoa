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

    func toNSDate() -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        return dateFormatter.dateFromString(self)
    }
}