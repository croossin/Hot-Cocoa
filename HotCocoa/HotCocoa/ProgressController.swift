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

    func showError(status: String){
        SVProgressHUD.showErrorWithStatus(status)
    }

    func dismiss(){
        SVProgressHUD.dismiss()
    }

    func showProgress(status: String, progress: Float){
        SVProgressHUD.showProgress(progress, status: status)
    }
}
