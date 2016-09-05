//
//  PodCell.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/4/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit
import FoldingCell

class PodCell: FoldingCell {

    @IBOutlet weak var closeNumberLabel: UILabel!

    @IBOutlet weak var closeProjectName: UILabel!
    @IBOutlet weak var openProjectName: UILabel!

    @IBOutlet weak var closeProjectDescription: UILabel!
    @IBOutlet weak var openProjectDescription: UILabel!

    @IBOutlet weak var closeProjectDate: UILabel!
    @IBOutlet weak var openProjectDate: UILabel!

    @IBOutlet weak var closeLanguage: UILabel!
    @IBOutlet weak var openLanguage: UILabel!

    @IBOutlet weak var closeLicense: UILabel!
    @IBOutlet weak var openLicense: UILabel!

    @IBOutlet weak var closeVotes: UILabel!
    @IBOutlet weak var openVotes: UILabel!

    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var authorAvatar: UIImageView!

    @IBOutlet weak var projectImage: UIImageView!

    @IBAction func launchGitHub(sender: AnyObject) {
        WebController.displayURLWithinView(githubLink)
    }

    var githubLink: String = ""
    
    var number: Int = 0 {
        didSet {
            closeNumberLabel.text = String(number)
        }
    }

    override func awakeFromNib() {

        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true

        super.awakeFromNib()
    }

    override func animationDuration(itemIndex:NSInteger, type:AnimationType)-> NSTimeInterval {

        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }

    func loadCell(pod: Pod){
        openProjectName.text = pod.name
        closeProjectName.text = pod.name

        closeProjectDescription.text = pod.description
        openProjectDescription.text = pod.description

        closeProjectDate.text = pod.minifyPrettyDate()
        openProjectDate.text = pod.dateAddedPretty

        closeLanguage.text = pod.language
        openLanguage.text = pod.language

        closeLicense.text = pod.license
        openLicense.text = pod.license

        closeVotes.text = String(pod.amountOfVotes)
        openVotes.text = String(pod.amountOfVotes)

        githubLink = pod.githubLink

        authorName.text = pod.author.name
        DataProvider.getImageFromUrl(pod.author.avatar){[weak self] image in
            guard let strongSelf = self else { return }
            strongSelf.authorAvatar.image = image
        }
    }
}

