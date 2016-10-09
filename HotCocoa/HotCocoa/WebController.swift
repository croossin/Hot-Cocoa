//
//  WebController.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/5/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import SafariServices

class WebController {

    class func displayURLWithinView(url: String){
        if let topController = UIApplication.sharedApplication().keyWindow?.rootViewController{
            guard let url = NSURL(string: url) else { return }
            let svc = SFSafariViewController(URL: url)
            topController.presentViewController(svc, animated: true, completion: nil)
        }
    }

    class func displayURLOnGivenView(vc: UIViewController, url: String){
        guard let url = NSURL(string: url) else { return }
        let svc = SFSafariViewController(URL: url)

        vc.presentViewController(svc, animated: true, completion: nil)
    }
}
