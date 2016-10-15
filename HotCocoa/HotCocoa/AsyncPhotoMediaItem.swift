//
//  AsyncPhotoMediaItem.swift
//  HotCocoa
//
//  Created by Chase Roossin on 10/15/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import Foundation
import JSQMessagesViewController

class AsyncPhotoMediaItem : JSQPhotoMediaItem {
    var asyncImageView: UIImageView!

    override init!(maskAsOutgoing: Bool) {
        super.init(maskAsOutgoing: maskAsOutgoing)
    }

    init(withURL url: String, imageSize: CGSize, isOperator: Bool) {
        super.init()
        appliesMediaViewMaskAsOutgoing = isOperator
 
        asyncImageView = UIImageView()
        asyncImageView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height)
        asyncImageView.contentMode = .ScaleAspectFit
        asyncImageView.clipsToBounds = true
        asyncImageView.layer.cornerRadius = 20
        asyncImageView.backgroundColor = UIColor.jsq_messageBubbleLightGrayColor()

        let activityIndicator = JSQMessagesMediaPlaceholderView.viewWithActivityIndicator()
        activityIndicator.frame = asyncImageView.frame
        asyncImageView.addSubview(activityIndicator)

        DataProvider.getImageFromUrl(url) { (image) in
            self.asyncImageView.image = image
            activityIndicator.removeFromSuperview()
        }
    }

    override func mediaView() -> UIView! {
        return asyncImageView
    }

    override func mediaViewDisplaySize() -> CGSize {
        return asyncImageView.frame.size
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}