//
//  UINavigationBarExtension.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/1/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit

private var flatAssociatedObjectKey: UInt8 = 0

@IBDesignable extension UINavigationBar {

    @IBInspectable var flat: Bool {
        get {
            guard let obj = objc_getAssociatedObject(self, &flatAssociatedObjectKey) as? NSNumber else {
                return false
            }
            return obj.boolValue;
        }

        set {
            if (newValue) {
                let void = UIImage()
                setBackgroundImage(void, forBarPosition: .Any, barMetrics: .Default)
                shadowImage = void
            } else {
                setBackgroundImage(nil, forBarPosition: .Any, barMetrics: .Default)
                shadowImage = nil
            }
            objc_setAssociatedObject(self, &flatAssociatedObjectKey, NSNumber(bool: newValue),
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

}