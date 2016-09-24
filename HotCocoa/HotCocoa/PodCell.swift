//
//  PodCell.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/4/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit
import FoldingCell
import TLTagsControl

class PodCell: FoldingCell {

    @IBOutlet weak var closeAvatar: UIImageView!

    @IBOutlet weak var closeProjectName: UILabel!
    @IBOutlet weak var openProjectName: UILabel!

    @IBOutlet weak var closeProjectDescription: UILabel!
    @IBOutlet weak var openProjectDescription: UILabel!

    @IBOutlet weak var closeProjectDate: UILabel!

    @IBOutlet weak var closeLanguage: UILabel!
    @IBOutlet weak var openLanguage: UILabel!

    @IBOutlet weak var closeLicense: UILabel!
    @IBOutlet weak var openLicense: UILabel!

    @IBOutlet weak var closeVotes: UILabel!
    @IBOutlet weak var openVotes: UILabel!

    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var authorAvatar: UIImageView!

    @IBOutlet weak var projectImage: UIImageView!

    @IBOutlet weak var tagsView: TLTagsControl!

    @IBOutlet weak var openDateAdded: UILabel!

    @IBAction func launchGitHub(sender: AnyObject) {
        WebController.displayURLWithinView(githubLink)
    }

    var githubLink: String = ""
    var internalpod: Pod?

    override func awakeFromNib() {

        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true

        closeAvatar.layer.cornerRadius = closeAvatar.frame.size.width / 2
        closeAvatar.layer.masksToBounds = true

        authorAvatar.layer.cornerRadius = authorAvatar.frame.size.width / 2
        authorAvatar.layer.masksToBounds = true

        tagsView.mode = .List
        tagsView.tagsBackgroundColor = UIColor.flatLightBlueColor
        tagsView.tagsTextColor = UIColor.whiteColor()
        tagsView.tapDelegate = self

        super.awakeFromNib()
    }

    override func animationDuration(itemIndex:NSInteger, type:AnimationType)-> NSTimeInterval {

        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }

    func loadCell(pod: Pod){

        internalpod = pod

        openProjectName.text = pod.name
        closeProjectName.text = pod.name

        closeProjectDescription.text = pod.description
        openProjectDescription.text = pod.description

        closeProjectDate.text = pod.minifyPrettyDate()

        closeLanguage.text = pod.language
        openLanguage.text = pod.language

        closeLicense.text = pod.license
        openLicense.text = pod.license

        closeVotes.text = String(pod.amountOfVotes)
        openVotes.text = String(pod.amountOfVotes)

        githubLink = pod.githubLink

        openDateAdded.text = pod.name + " was added to GitHub on " + pod.dateAddedPretty

        authorName.text = pod.author.name
        DataProvider.getImageFromUrl(pod.author.avatar){[weak self] image in
            self?.authorAvatar.image = image
            self?.closeAvatar.image = image

            //Add tap gesture to their profile image to take directly to personal GH Link
            let tapGesture = UITapGestureRecognizer(target: self, action: Selector("profileImageTapped:"))
            self?.authorAvatar.userInteractionEnabled = true
            self?.authorAvatar.addGestureRecognizer(tapGesture)
        }

        tagsView.tags = NSMutableArray(array: pod.tags)
        tagsView.reloadTagSubviews()
    }

    func profileImageTapped(img: AnyObject){
        guard let pod = internalpod else { return }
        if let username = pod.githubUsername() {
            WebController.displayURLWithinView(GitHubLinks.MAIN_URL + username)
        }
    }
}

extension PodCell: TLTagsControlDelegate{
    func tagsControl(tagsControl: TLTagsControl!, tappedAtIndex index: Int) {
        if let tagName = tagsControl.tags[index] as? String{
            WindowHelper.displayTagVCOnRoot(tagName)
        }
    }
}

