//
//  PodCollectionViewCell.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/1/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit
import DisplaySwitcher

private let avatarListLayoutSize: CGFloat = 80.0

class PodCollectionViewCell: UICollectionViewCell, CellInterface {

    @IBOutlet weak var podImageView: UIImageView!
    @IBOutlet weak var backgroundGradientView: UIView!
    @IBOutlet weak var nameListLabel: UILabel!
    @IBOutlet weak var nameGridLabel: UILabel!
    @IBOutlet weak var statisticLabel: UILabel!

    //Constraints
    @IBOutlet weak var podImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var podImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameListLabelLeadingConstraint: NSLayoutConstraint! {
        didSet{
            initialLabelsLeadingConstraintValue = nameListLabelLeadingConstraint.constant
        }
    }
    @IBOutlet weak var statisticLabelLeadingConstraint: NSLayoutConstraint!


    private var avatarGridLayoutSize: CGFloat = 0.0
    private var initialLabelsLeadingConstraintValue: CGFloat = 0.0

    func inject(pod: Pod){
        podImageView.image = UIImage(named: "framework")

        //Begin the download process of their logo then set
        DataProvider.getImageFromUrl(pod.author.avatar){[weak self] image in
            guard let strongSelf = self else { return }
            strongSelf.podImageView.image = image
        }

        nameListLabel.text = pod.name
        nameGridLabel.text = pod.name

        let dateAdded = pod.dateAddedPretty
        let numOfVotes = String(pod.amountOfVotes)
        let license = pod.license

        statisticLabel.text = dateAdded + " | " + numOfVotes + " votes | " + license
    }

    func setupGridLayoutConstraints(transitionProgress: CGFloat, cellWidth: CGFloat) {
        podImageViewHeightConstraint.constant = ceil((cellWidth - avatarListLayoutSize) * transitionProgress + avatarListLayoutSize)
        podImageViewWidthConstraint.constant = ceil(podImageViewHeightConstraint.constant)
        nameListLabelLeadingConstraint.constant = -podImageViewWidthConstraint.constant * transitionProgress + initialLabelsLeadingConstraintValue
        statisticLabelLeadingConstraint.constant = nameListLabelLeadingConstraint.constant
        backgroundGradientView.alpha = transitionProgress <= 0.5 ? 1 - transitionProgress : transitionProgress
        nameListLabel.alpha = 1 - transitionProgress
        statisticLabel.alpha = 1 - transitionProgress
    }

    func setupListLayoutConstraints(transitionProgress: CGFloat, cellWidth: CGFloat) {
        podImageViewHeightConstraint.constant = ceil(avatarGridLayoutSize - (avatarGridLayoutSize - avatarListLayoutSize) * transitionProgress)
        podImageViewWidthConstraint.constant = podImageViewHeightConstraint.constant
        nameListLabelLeadingConstraint.constant = podImageViewWidthConstraint.constant * transitionProgress + (initialLabelsLeadingConstraintValue - podImageViewHeightConstraint.constant)
        statisticLabelLeadingConstraint.constant = nameListLabelLeadingConstraint.constant
        backgroundGradientView.alpha = transitionProgress <= 0.5 ? 1 - transitionProgress : transitionProgress
        nameListLabel.alpha = transitionProgress
        statisticLabel.alpha = transitionProgress
    }


    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        if let attributes = layoutAttributes as? BaseLayoutAttributes {
            if attributes.transitionProgress > 0 {
                if attributes.layoutState == .GridLayoutState {
                    setupGridLayoutConstraints(attributes.transitionProgress, cellWidth: CGRectGetWidth(attributes.nextLayoutCellFrame))
                    avatarGridLayoutSize = CGRectGetWidth(attributes.nextLayoutCellFrame)
                } else {
                    setupListLayoutConstraints(attributes.transitionProgress, cellWidth: CGRectGetWidth(attributes.nextLayoutCellFrame))
                }
            }
        }
    }
}
