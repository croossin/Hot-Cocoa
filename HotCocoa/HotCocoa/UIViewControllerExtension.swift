//
//  UIViewControllerExtension.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/8/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit
import MessageUI

extension UIViewController{
    func dismissAndPresentOntoRoot(vc: UIViewController){
        self.dismissViewControllerAnimated(true) {
            if let mainNavController = UIApplication.sharedApplication().keyWindow?.rootViewController{
                mainNavController.childViewControllers.first?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    func presentMailOntoRootController(vc: MFMailComposeViewController){
        if let topController = UIApplication.topViewController(){
            topController.presentViewController(vc, animated: true, completion: nil)
        }
    }
}