//
//  ArrayExtension.swift
//  HotCocoa
//
//  Created by Chase Roossin on 10/16/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit

extension Array{
    func chooseRandom() -> String?{
        let randomIndex = Int(arc4random_uniform(UInt32(self.count)))

        if let random = self[randomIndex] as? String{
            return random
        }
        return nil
    }
}
