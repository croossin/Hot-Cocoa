//
//  UIColorExtension.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/1/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }

    static var WhiteColor: UIColor{return UIColor(red: 255, green: 255, blue: 255)}
    static var BlackColor: UIColor{return UIColor(red: 3, green: 3, blue: 3)}
    static var CoralColor: UIColor{return UIColor(red: 244, green: 111, blue: 96)}
    static var WhiteSmokeColor: UIColor{return UIColor(red: 245, green: 245, blue: 245)}
    static var GrayChateauColor: UIColor{return UIColor(red: 163, green: 164, blue: 168)}
}
