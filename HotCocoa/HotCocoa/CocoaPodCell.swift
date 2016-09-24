//
//  CocoaPodCell.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/9/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit
import FoldingCell
import TLTagsControl

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

    @IBOutlet weak var openLanguage: UILabel!
    @IBOutlet weak var openLicense: UILabel!
    @IBOutlet weak var openDownloads: UILabel!

    @IBOutlet weak var openDisclaimerText: UILabel!

    @IBOutlet weak var authorGHAvatarImage: UIImageView!
    
    @IBOutlet weak var detailedScrollView: TLTagsControl!
    
    var githubLink: String = ""

    @IBOutlet weak var emailAuthorButton: UIButton!
    @IBAction func emailAuthor(sender: AnyObject) {
        if let pod = pod{
            EmailController.createEmail(pod.author.email, podname: pod.name)
        }
    }

    @IBAction func openGitHubLink(sender: AnyObject) {
        if let pod = pod{
            WebController.displayURLWithinView(pod.url)
        }
    }

    var pod: CocoaPod?
    var ghUsername: String?

    override func awakeFromNib() {

        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true

        authorGHAvatarImage.layer.cornerRadius = authorGHAvatarImage.frame.size.width / 2
        authorGHAvatarImage.layer.masksToBounds = true

        detailedScrollView.mode = .List
        detailedScrollView.tagsBackgroundColor = UIColor.flatLightBlueColor
        detailedScrollView.tagsTextColor = UIColor.whiteColor()
        detailedScrollView.tapDelegate = self
        detailedScrollView.userInteractionEnabled = true
        
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

        //See if we can get gh username from gh link
        if let _ghUsername = pod.githubUsername(){

            ghUsername = _ghUsername

            DataProvider.getImageFromUrl(GitHubLinks.MAIN_URL + _ghUsername + GitHubLinks.IMAGE_SUFFIX, callback: {[weak self] image in
                self?.authorGHAvatarImage.image = image

                //Add tap gesture to their profile image to take directly to personal GH Link
                let tapGesture = UITapGestureRecognizer(target: self, action: Selector("profileImageTapped:"))
                self?.authorGHAvatarImage.userInteractionEnabled = true
                self?.authorGHAvatarImage.addGestureRecognizer(tapGesture)
            })
        }

        lastRelease.text = pod.lastRelease

        closeLanguage.text = pod.language
        closeLicense.text = pod.license
        closeDownloads.text = pod.downloads.total

        openLanguage.text = pod.language
        openLicense.text = pod.license
        openDownloads.text = pod.downloads.total

        openDisclaimerText.text = "\(pod.name) has \(pod.github.stars) stars on GitHub"

        detailedScrollView.tags = DetailedScroll.DETAILED_ARRAY
        detailedScrollView.reloadTagSubviews()
    }

    func profileImageTapped(img: AnyObject){
        guard let username = ghUsername else { return }
        WebController.displayURLWithinView(GitHubLinks.MAIN_URL + username)
    }
}

extension CocoaPodCell: TLTagsControlDelegate{
    func tagsControl(tagsControl: TLTagsControl!, tappedAtIndex index: Int) {
        if let selectedDetail = DetailedInfo(id: index){

            guard let selectedPod = pod else { return }

            switch selectedDetail {
            case .GitHub:
                AlertController.displayAlert("GitHub", subtitle: selectedPod.detailedGitHubInfo())
            case .Downloads:
                AlertController.displayAlert("Downloads", subtitle: selectedPod.detailedDownloadInfo())
            case .Installs:
                AlertController.displayAlert("Installs", subtitle: selectedPod.detailedInstallInfo())
            case .CodeBase:
                AlertController.displayAlert("Code Base", subtitle: selectedPod.detailedCodebaseInfo())
            }
        }
    }
}
