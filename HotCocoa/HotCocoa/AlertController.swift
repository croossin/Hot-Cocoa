//
//  AlertController.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/24/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit
import FCAlertView

class AlertController {
    class func displayAlert(title: String, subtitle: String){
        let alert = FCAlertView()
        alert.makeAlertTypeSuccess()
        alert.showAlertWithTitle(title, withSubtitle: subtitle, withCustomImage: nil, withDoneButtonTitle: "Got It", andButtons: nil)
    }
}