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
                guard let tagVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HomeController") as? HomeController else { return }
                tagVC.title = "#\($0)"
                tagVC.isSearching = true
                strongSelf.dismissAndPresentOntoRoot(tagVC)
            }

            strongSelf.view.addSubview(strongSelf.ramReel.view)
            strongSelf.ramReel.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            strongSelf._setupDismissButton()
            SVProgressHUD.dismiss()
        }
    }

    func _setupDismissButton(){
        let dismissButton = UIButton(frame: CGRect(x: 5, y: 10, width: 20, height: 20))
        dismissButton.backgroundColor = UIColor.BlackColor
        dismissButton.setTitle("X", forState: .Normal)
        dismissButton.addTarget(self, action: #selector(SearchViewController.dismiss(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(dismissButton)
    }

    func dismiss(sender: UIButton!){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
