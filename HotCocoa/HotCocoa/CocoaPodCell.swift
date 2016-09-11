//
//  CocoaPodCell.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/9/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit
import FoldingCell

class CocoaPodCell: FoldingCell {

    @IBOutlet weak var closeProjectName: UILabel!
    @IBOutlet weak var openProjectName: UILabel!

    @IBOutlet weak var closeDescription: UILabel!
    @IBOutlet weak var openDescription: UILabel!

    @IBOutlet weak var closeRatings: UILabel!

    @IBOutlet weak var authorName: UILabel!

    @IBOutlet weak var lastRelease: UILabel!

    @IBOutlet weak var closeLanguage: UILabel!
    @IBOutlet weak var closeLicense: UILabel!
    @IBOutlet weak var closeDownloads: UILabel!

    var githubLink: String = ""

    @IBOutlet weak var emailAuthorButton: UIButton!
    @IBAction func emailAuthor(sender: AnyObject) {
        if let pod = pod{
            EmailController.createEmail(pod.author.email, podname: pod.name)
        }
    }

    var pod: CocoaPod?

    override func awakeFromNib() {

        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true

        super.awakeFromNib()
    }

    override func animationDuration(itemIndex:NSInteger, type:AnimationType)-> NSTimeInterval {

        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }

    func loadCell(pod: CocoaPod){
        self.pod = pod //Save for future reference

        emailAuthorButton.hidden = !pod.hasValidEmail()

        closeProjectName.text = pod.name
        openProjectName.text = pod.name

        closeDescription.text = pod.description
        openDescription.text = pod.description

        closeRatings.text = pod.github.stars

        authorName.text = pod.author.name

        lastRelease.text = pod.lastRelease

        closeLanguage.text = pod.language
        closeLicense.text = pod.license
        closeDownloads.text = pod.downloads.total
    }
}
