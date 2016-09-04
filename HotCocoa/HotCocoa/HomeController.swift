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

    var segmentView: Segmentio = Segmentio()

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

        let barAttributes = UINavigationItem(title: "Hot Cocoa")
        barAttributes.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search"), style: .Plain, target: nil, action: #selector(instantiateSearchController(_:)))
        navbar.setItems([barAttributes], animated: false)

        //Segmentio
        guard let sv = HCSegmentio().segView else { return }
        self.segmentView = sv
        segmentView.selectedSegmentioIndex = 0
        segmentView.valueDidChange = { [weak self] _, segmentIndex in
            guard let strongself = self else { return }
            strongself.segViewValueDidChange(segmentIndex)
        }

        self.view.addSubview(segmentView)
    }

    func segViewValueDidChange(selectedIndex: Int){
        let contentOffsetX = scrollView.frame.width * CGFloat(selectedIndex)
        scrollView.setContentOffset(CGPoint(x: contentOffsetX, y: 0), animated: true)
    }

    private func gatherViewControllers() -> [CocoaTableViewController] {

//        let a = CocoaTableViewController.generateSelf()
//        a.podSorting = .Recent
//
//        let b = CocoaTableViewController.generateSelf()
//        b.podSorting = .Rating
//
//        let c = CocoaTableViewController.generateSelf()
//        c.podSorting = .Swift
//
//        let d = CocoaTableViewController.generateSelf()
//        d.podSorting = .ObjC
//        let a = CocoaTableViewController()

        guard let a = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CocoaTableViewController") as? CocoaTableViewController else { return [] }
        guard let b = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CocoaTableViewController") as? CocoaTableViewController else { return [] }
        guard let c = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CocoaTableViewController") as? CocoaTableViewController else { return [] }
        guard let d = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CocoaTableViewController") as? CocoaTableViewController else { return [] }

        return [a,b,c,d]
    }

    @objc private func instantiateSearchController(sender: UIBarButtonItem){
        let vc = SearchViewController()
        self.presentViewController(vc, animated: true, completion: nil)
    }
}

extension HomeController: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let currentPage = floor(scrollView.contentOffset.x / scrollView.frame.width)
        self.segmentView.selectedSegmentioIndex = Int(currentPage)
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: 0)
    }
}