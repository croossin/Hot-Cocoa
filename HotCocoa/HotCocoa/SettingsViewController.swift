//
//  SettingsViewController.swift
//  HotCocoa
//
//  Created by Chase Roossin on 10/9/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit
import Bohr
import CTFeedback

class SettingsViewController: BOTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupTableView()
    }

    func setupUI(){
        self.title = "Settings"

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(SettingsViewController.dismiss))
    }

    func dismiss(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func setupTableView(){

        //Feedback
        self.addSection(BOTableViewSection(headerTitle: "Feedback", handler: { (section) in

            section.addCell(BOChoiceTableViewCell(title: "Give App Feedback", key: "", handler: { (cell) in

                guard let cell = cell as? BOChoiceTableViewCell else { return }

                let vc = CTFeedbackViewController(topics: CTFeedbackViewController.defaultTopics(), localizedTopics: CTFeedbackViewController.defaultLocalizedTopics())
                vc.showsUserEmail = true
                vc.useCustomCallback = true
                vc.delegate = self

                cell.destinationViewController = vc
            }))

            section.footerTitle = "All feedback is greatly appreciated"
        }))

        //Pods
        self.addSection(BOTableViewSection(headerTitle: "CocoaPods", handler: { (section) in

            let sortedPods = Credit.CocoaPods.sort { $0.title.lowercaseString < $1.title.lowercaseString }

            for pod in sortedPods {

                section.addCell(BOButtonTableViewCell(title: pod.title, key: "", handler: { (cell) in

                    guard let cell = cell as? BOButtonTableViewCell else { return }

                    cell.actionBlock = {
                        WebController.displayURLOnGivenView(self, url: pod.url)
                    }
                }))
            }

            section.footerTitle = "The CocoaPods used in this project"
        }))

        //Icons
        self.addSection(BOTableViewSection(headerTitle: "Icons", handler: { (section) in

            let sortedIcons = Credit.Icons.sort { $0.title.lowercaseString < $1.title.lowercaseString }

            for credit in sortedIcons {

                section.addCell(BOButtonTableViewCell(title: credit.title, key: "", handler: { (cell) in

                    guard let cell = cell as? BOButtonTableViewCell else { return }

                    cell.actionBlock = {
                        WebController.displayURLOnGivenView(self, url: credit.url)
                    }
                }))
            }

            section.footerTitle = "App made possible by these great designers!"
        }))
    }
}

extension SettingsViewController : CTFeedbackViewControllerDelegate{
    func feedbackViewController(controller: CTFeedbackViewController?, didFinishWithCustomCallback email: String?, topic: String?, content: String?, attachment: UIImage?) {

        guard let content = content, topic = topic, controller = controller else { AlertController.displayNotCompleteFormBanner(); return }

        let email = email ?? ""

        if let image = attachment {
            DataProvider.uploadImage(image, onCompletion: { (success, url) in

                self.sendFeedback(topic, content: content, email: email, imageUrl: success ? url : nil, controller: controller)
            })
        } else {
            self.sendFeedback(topic, content: content, email: email, imageUrl: nil, controller: controller)
        }

    }

    private func sendFeedback(topic: String, content: String, email: String, imageUrl: String?, controller: CTFeedbackViewController){
        ProgressController.sharedInstance.show("Sending Feedback")

        DataProvider.sendFeedback(topic, content: content, email: email, imageUrl: imageUrl, successCallback: {

            ProgressController.sharedInstance.dismiss()
            controller.dismissViewControllerAnimated(true, completion: {
                AlertController.displayCompleteFeedbackRequest()
            })
        }) {

            ProgressController.sharedInstance.dismiss()
            AlertController.displayErrorFeedbackRequest()
        }
    }
}
