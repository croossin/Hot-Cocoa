//
//  HomeController.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/1/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit
import Segmentio
import TCTitleLoading

class HomeController: UIViewController {

    var segmentView: Segmentio = Segmentio()

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    private lazy var viewControllers: [UIViewController] = {
        return self.gatherViewControllers()
    }()

    var isSearching: Bool = false
    var searchTerm: String = ""

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
        let searchButton = UIButton()
        searchButton.setImage(UIImage(named: "search"), forState: .Normal)
        searchButton.frame = CGRectMake(0, 0, 30, 30)
        searchButton.addTarget(self, action: #selector(HomeController.presentSearchVC), forControlEvents: .TouchUpInside)

        let rightBarButton = UIBarButtonItem(customView: searchButton)
        self.navigationItem.rightBarButtonItem = rightBarButton

        //Segmentio
        guard let sv = HCSegmentio(isSearching: isSearching).segView else { return }
        self.segmentView = sv
        segmentView.selectedSegmentioIndex = 0
        segmentView.valueDidChange = { [weak self] _, segmentIndex in
            guard let strongself = self else { return }
            strongself.segViewValueDidChange(segmentIndex)
        }

        self.view.addSubview(segmentView)
    }

    func presentSearchVC(){
        let vc = SearchViewController()
        self.presentViewController(vc, animated: true, completion: nil)
    }

    func segViewValueDidChange(selectedIndex: Int){
        let contentOffsetX = scrollView.frame.width * CGFloat(selectedIndex)
        scrollView.setContentOffset(CGPoint(x: contentOffsetX, y: 0), animated: true)
    }

    private func gatherViewControllers() -> [UIViewController] {
        return isSearching ? returnSearchTableViewControllers() : returnMainTablViewControllers()
    }

    private func returnMainTablViewControllers() -> [CocoaTableViewController] {
        guard let a = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CocoaTableViewController") as? CocoaTableViewController else { return [] }
        a.podSorting = .Recent
        a.delegate = self

        guard let b = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CocoaTableViewController") as? CocoaTableViewController else { return [] }
        b.podSorting = .Rating
        b.delegate = self

        guard let c = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CocoaTableViewController") as? CocoaTableViewController else { return [] }
        c.podSorting = .Swift
        c.delegate = self

        guard let d = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CocoaTableViewController") as? CocoaTableViewController else { return [] }
        d.podSorting = .ObjC
        d.delegate = self

        return [a,b,c,d]
    }

    private func returnSearchTableViewControllers() -> [CocoaSearchTableViewController]{
        guard let a = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CocoaSearchTableViewController") as? CocoaSearchTableViewController else { return [] }
        a.platform = .IOS
        a.searchTerm = searchTerm
        a.delegate = self

        guard let b = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CocoaSearchTableViewController") as? CocoaSearchTableViewController else { return [] }
        b.platform = .OSX
        b.searchTerm = searchTerm
        b.delegate = self

        guard let c = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CocoaSearchTableViewController") as? CocoaSearchTableViewController else { return [] }
        c.platform = .WATCHOS
        c.searchTerm = searchTerm
        c.delegate = self

        guard let d = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CocoaSearchTableViewController") as? CocoaSearchTableViewController else { return [] }
        d.platform = .TVOS
        d.searchTerm = searchTerm
        d.delegate = self

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

extension HomeController: CocoaTableViewControllerDelegate{
    func loadingStarted() {
        self.startAnimationTitle()
    }

    func loadingEnded() {
        self.stopAnimationTitle()
    }
}