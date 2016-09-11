//
//  WindowHelper.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/11/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit

class WindowHelper{

    class func displayTagVCOnRoot(tagTitle: String){
        guard let tagVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HomeController") as? HomeController else { return }
        tagVC.title = "#\(tagTitle)"
        tagVC.searchTerm = tagTitle
        tagVC.isSearching = true

        if let mainNavController = UIApplication.sharedApplication().keyWindow?.rootViewController{
            mainNavController.childViewControllers.first?.navigationController?.pushViewController(tagVC, animated: true)
        }
    }
}
