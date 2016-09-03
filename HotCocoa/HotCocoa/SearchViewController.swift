//
//  SearchViewController.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/3/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit
import RAMReel
import SVProgressHUD

class SearchViewController: UIViewController, UICollectionViewDelegate {

    var dataSource: SimplePrefixQueryDataSource!
    var ramReel: RAMReel<RAMCell, RAMTextField, SimplePrefixQueryDataSource>!

    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        SVProgressHUD.showWithStatus("Gathering All Tags")

        DataProvider.getAllTags {[weak self] (listOfTags) in
            guard let strongSelf = self else { return }

            strongSelf.dataSource = SimplePrefixQueryDataSource(listOfTags)
            strongSelf.ramReel = RAMReel(frame: strongSelf.view.bounds, dataSource: strongSelf.dataSource, placeholder: "Search for tags…") {
                print("Plain:", $0)
            }
            strongSelf.ramReel.hooks.append {
                let r = Array($0.characters.reverse())
                let j = String(r)
                print("Reversed:", j)
            }

            strongSelf.view.addSubview(strongSelf.ramReel.view)
            strongSelf.ramReel.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            SVProgressHUD.dismiss()
        }
    }

}
