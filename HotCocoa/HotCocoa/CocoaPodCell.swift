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

    var githubLink: String = ""

    var number: Int = 0 {
        didSet {
//            closeNumberLabel.text = String(number)
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

    func loadCell(pod: CocoaPod){

    }
}
