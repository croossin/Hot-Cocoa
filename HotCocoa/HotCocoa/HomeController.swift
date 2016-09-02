//
//  HomeController.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/1/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit
import Segmentio

class HomeController: UIViewController {

    let HCSeg: HCSegmentio = HCSegmentio()


    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!


    private lazy var viewControllers: [UIViewController] = {
        return self.gatherViewControllers()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        _setupScrollView()
        _setupUI()
    }

    func _setupScrollView(){

        scrollView.contentSize = CGSize(
            width: UIScreen.mainScreen().bounds.width * CGFloat(viewControllers.count),
            height: containerView.frame.height
        )

        for (index, viewController) in viewControllers.enumerate() {
            viewController.view.frame = CGRect(
                x: UIScreen.mainScreen().bounds.width * CGFloat(index),
                y: 0,
                width: scrollView.frame.width,
                height: scrollView.frame.height
            )
            addChildViewController(viewController)
            scrollView.addSubview(viewController.view, options: .UseAutoresize) // module's extension
            viewController.didMoveToParentViewController(self)
        }
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

    private func gatherViewControllers() -> [CocoaTableViewController] {

        let a = CocoaTableViewController.generateSelf()
//        a.setupConfig = (recent: true, rating: false, swift: false, objc: false)

        let b = CocoaTableViewController.generateSelf()
//        b.setupConfig = (recent: false, rating: true, swift: false, objc: false)

        let c = CocoaTableViewController.generateSelf()
//        a.setupConfig = (recent: true, rating: false, swift: false, objc: false)

        let d = CocoaTableViewController.generateSelf()
//        a.setupConfig = (recent: true, rating: false, swift: false, objc: false)

        return [a,b,c,d]
    }
}

extension HomeController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let currentPage = floor(scrollView.contentOffset.x / scrollView.frame.width)
        HCSeg.segView?.selectedSegmentioIndex = Int(currentPage)
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 0)
    }

}