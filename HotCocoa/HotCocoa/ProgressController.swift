//
//  ProgressController.swift
//  HotCocoa
//
//  Created by Chase Roossin on 10/9/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import SVProgressHUD

class ProgressController {
    static let sharedInstance = ProgressController()

    func show(status: String){
        SVProgressHUD.showWithStatus(status)
    }

    func dismiss(){
        SVProgressHUD.dismiss()
    }
}
