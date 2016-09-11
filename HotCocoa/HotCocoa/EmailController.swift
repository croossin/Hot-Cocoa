//
//  EmailController.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/10/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit
import MessageUI

class EmailController: UIViewController, MFMailComposeViewControllerDelegate{

    static let sharedInstance = EmailController()

    class func createEmail(to: String, podname: String){
        let mailComposeViewController = sharedInstance.configuredMailComposeViewController(to, subject: "[HotCocoa] A message about \(podname)")

        if MFMailComposeViewController.canSendMail() {
            sharedInstance.presentMailOntoRootController(mailComposeViewController)
        } else {
            sharedInstance.showSendMailErrorAlert()
        }
    }

    internal func configuredMailComposeViewController(toRecipient: String, subject: String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property

        mailComposerVC.setToRecipients([toRecipient])
        mailComposerVC.setSubject(subject)

        return mailComposerVC
    }

    internal func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }

    // MARK: MFMailComposeViewControllerDelegate Method
    internal func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}
