//
//  HCSegmentio.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/1/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit
import Segmentio

class HCSegmentio {

    var segView: Segmentio?

    init(){
        //UI Setup
        let segmentioViewRect = CGRect(x: 0, y: Dimensions.NAVBAR_HEIGHT, width: UIScreen.mainScreen().bounds.width, height: 125)

        let segmentioView = Segmentio(frame: segmentioViewRect)

        //Initialize Options (will use once seg view works)
        let options = SegmentioOptions(
            backgroundColor: UIColor.WhiteColor,
            maxVisibleItems: 3,
            scrollEnabled: true,
            indicatorOptions: indicatorOptions(),
            horizontalSeparatorOptions: segmentioHorizontalSeparatorOptions(),
            verticalSeparatorOptions: segmentioVerticalSeparatorOptions(),
            imageContentMode: UIViewContentMode.Center,
            labelTextAlignment: .Center,
            segmentStates: segmentioStates()
        )

        //Setup
        segmentioView.setup(content: content(), style: SegmentioStyle.ImageOverLabel, options: options)

        segView = segmentioView
    }

    private func content() -> [SegmentioItem] {
        return [
            SegmentioItem(title: "Recent", image: UIImage(named: "recent") ?? UIImage()),
            SegmentioItem(title: "Rating", image: UIImage(named: "rating") ?? UIImage()),
            SegmentioItem(title: "Swift", image: UIImage(named: "swift") ?? UIImage()),
            SegmentioItem(title: "Objective-C", image: UIImage(named: "objc") ?? UIImage()),
        ]
    }

    private func indicatorOptions() -> SegmentioIndicatorOptions {
        return SegmentioIndicatorOptions(
            type: .Bottom,
            ratio: 1,
            height: 5,
            color: UIColor.CoralColor
        )
    }

    private func segmentioHorizontalSeparatorOptions() -> SegmentioHorizontalSeparatorOptions {
        return SegmentioHorizontalSeparatorOptions(
            type: .TopAndBottom,
            height: 1,
            color: UIColor.WhiteSmokeColor
        )
    }

    private func segmentioVerticalSeparatorOptions() -> SegmentioVerticalSeparatorOptions {
        return SegmentioVerticalSeparatorOptions(
            ratio: 1,
            color: UIColor.WhiteSmokeColor
        )
    }

    private func segmentioStates() -> SegmentioStates {
        let font = UIFont.avenirMediumWithSize(13)

        return SegmentioStates(
            defaultState: segmentioState(
                backgroundColor: UIColor.clearColor(),
                titleFont: font,
                titleTextColor: UIColor.GrayChateauColor
            ),
            selectedState: segmentioState(
                backgroundColor: UIColor.clearColor(),
                titleFont: font,
                titleTextColor: UIColor.BlackColor
            ),
            highlightedState: segmentioState(
                backgroundColor: UIColor.WhiteSmokeColor,
                titleFont: font,
                titleTextColor: UIColor.GrayChateauColor
            )
        )
    }

    private func segmentioState(backgroundColor backgroundColor: UIColor, titleFont: UIFont, titleTextColor: UIColor) -> SegmentioState {
        return SegmentioState(backgroundColor: backgroundColor, titleFont: titleFont, titleTextColor: titleTextColor)
    }
}
