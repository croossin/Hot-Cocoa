//
//  AlertController.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/24/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit
import FCAlertView
import ISMessages

class AlertController {
    class func displayAlert(title: String, subtitle: String){
        let alert = FCAlertView()
        alert.makeAlertTypeSuccess()
        alert.showAlertWithTitle(title, withSubtitle: subtitle, withCustomImage: nil, withDoneButtonTitle: "Got It", andButtons: nil)
    }

    class func displayInfoAlert(title: String, subtitle: String){
        let alert = FCAlertView()
        alert.makeAlertTypeCaution()
        alert.showAlertWithTitle(title, withSubtitle: subtitle, withCustomImage: nil, withDoneButtonTitle: "Got It", andButtons: nil)
    }

    class func displayCompleteFeedbackRequest(){
        let randomTitleIndex = Int(arc4random_uniform(UInt32(MessageTitles.Success.count)))

        ISMessages.showCardAlertWithTitle(MessageTitles.Success[randomTitleIndex], message: "We really appreciate your feedback!", iconImage: nil, duration: 3.0, hideOnSwipe: true, hideOnTap: true, alertType: .Success, alertPosition: .Top)
    }

    class func displayErrorFeedbackRequest(){
        let randomTitleIndex = Int(arc4random_uniform(UInt32(MessageTitles.Error.count)))

       ISMessages.showCardAlertWithTitle(MessageTitles.Error[randomTitleIndex], message: "We had an issue on our side. Please try again later.", iconImage: nil, duration: 3.0, hideOnSwipe: true, hideOnTap: true, alertType: .Error, alertPosition: .Top)
    }

    class func displayNotCompleteFormBanner(){

        let randomTitleIndex = Int(arc4random_uniform(UInt32(MessageTitles.Error.count)))

        ISMessages.showCardAlertWithTitle(MessageTitles.Error[randomTitleIndex], message: "You must fill out feedback form", iconImage: nil, duration: 3.0, hideOnSwipe: true, hideOnTap: true, alertType: .Info, alertPosition: .Top)
    }

    class func displayBanner(alertType: ISAlertType, title: String, message: String){
        ISMessages.showCardAlertWithTitle(title, message: message, iconImage: nil, duration: 3.0, hideOnSwipe: true, hideOnTap: true, alertType: alertType, alertPosition: .Top)
    }
}