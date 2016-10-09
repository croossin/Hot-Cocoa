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
    }

    func setupTableView(){
        self.addSection(BOTableViewSection(headerTitle: "Feedback", handler: { (section) in

            section.addCell(BOChoiceTableViewCell(title: "Give App Feedback", key: "", handler: { (cell) in

                guard let cell = cell as? BOChoiceTableViewCell else { return }

                let vc = CTFeedbackViewController(topics: CTFeedbackViewController.defaultTopics(), localizedTopics: CTFeedbackViewController.defaultLocalizedTopics())
                vc.showsUserEmail = true
                vc.useCustomCallback = true
                vc.delegate = self

                cell.destinationViewController = vc
            }))
        }))

        self.addSection(BOTableViewSection(headerTitle: "Credits", handler: { (section) in

        }))
    }
}

extension SettingsViewController : CTFeedbackViewControllerDelegate{
    func feedbackViewController(controller: CTFeedbackViewController!, didFinishWithCustomCallback email: String!, topic: String!, content: String!, attachment: UIImage!) {
        print(email)
        print(topic)
        print(content)

        if content.isEmpty {

            return
        }
//        print(attachment)
    }
}
