//
//  UILabelExtension.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/3/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit

extension UILabel{
    dynamic var defaultFont: UIFont? {
        get { return self.font }
        set { self.font = newValue }
    }
}