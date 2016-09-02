//
//  HomeController.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/1/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit

class HomeController: UIViewController {

    let HCSeg: HCSegmentio = HCSegmentio()

    override func viewDidLoad() {
        super.viewDidLoad()

        _setupUI()
    }

    func _setupUI(){
        //NavBar
        let navbar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: Dimensions.NAVBAR_HEIGHT))
        navbar.backgroundColor = UIColor.WhiteSmokeColor
        self.view.addSubview(navbar)

        let title = UINavigationItem(title: "Hot Cocoa")
        navbar.setItems([title], animated: false)

        //Segmentio
        guard let segView = HCSeg.segView else { return }
        segView.selectedSegmentioIndex = 0
        segView.valueDidChange = { [weak self] _, segmentIndex in
            guard let strongself = self else { return }
            strongself.segViewValueDidChange(segmentIndex)
        }

        self.view.addSubview(segView)
    }

    func segViewValueDidChange(selectedIndex: Int){
        print(selectedIndex)
    }
}
