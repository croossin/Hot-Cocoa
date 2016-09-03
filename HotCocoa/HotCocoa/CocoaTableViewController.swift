//
//  CocoaTableViewController.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/1/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit
import DisplaySwitcher
import UIScrollView_InfiniteScroll

private let animationDuration: NSTimeInterval = 0.3
private let listLayoutStaticCellHeight: CGFloat = 80
private let gridLayoutStaticCellHeight: CGFloat = 165

class CocoaTableViewController: UIViewController, UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var collectionView: UICollectionView!

    var podSorting: PodSorting = .Recent

    private var pods = [Pod]()

    private var isTransitionAvailable = true
    private lazy var listLayout = BaseLayout(staticCellHeight: listLayoutStaticCellHeight, nextLayoutStaticCellHeight: gridLayoutStaticCellHeight, layoutState: .ListLayoutState)
    private lazy var gridLayout = BaseLayout(staticCellHeight: gridLayoutStaticCellHeight, nextLayoutStaticCellHeight: listLayoutStaticCellHeight, layoutState: .GridLayoutState)
    private var layoutState: CollectionViewLayoutState = .ListLayoutState

    override func viewDidLoad() {
        super.viewDidLoad()

        _setupCollectionView()
        _loadPods()
        _setupInfiniteScroll()
    }

    private func _setupCollectionView() {
        collectionView.collectionViewLayout = listLayout
        collectionView.registerNib(PodCollectionViewCell.cellNib, forCellWithReuseIdentifier:PodCollectionViewCell.id)
    }

    private func _loadPods(){
        DataProvider.getPodsBasedOnPodSorting(podSorting, currentNumberRetrieved: pods.count) { listOfPods in
            print(listOfPods.count)
            self.pods = listOfPods
            self.collectionView.reloadData()
        }
    }

    private func _setupInfiniteScroll(){

        collectionView.addInfiniteScrollWithHandler { [weak self] (scrollView) -> Void in

            guard let strongSelf = self else { return }

            let collectionView = scrollView 

            DataProvider.getPodsBasedOnPodSorting(strongSelf.podSorting, currentNumberRetrieved: strongSelf.pods.count) {[weak self] listOfPods in
                guard let strongSelf = self else { return }

                var indexPaths = [NSIndexPath]()
                var index = strongSelf.pods.count

                // create index paths for affected items
                for story in listOfPods {
                    let indexPath = NSIndexPath(forItem: index++, inSection: 0)

                    indexPaths.append(indexPath)
                    strongSelf.pods.append(story)
                }

                // Update collection view
                collectionView.performBatchUpdates({ () -> Void in
                    // add new items into collection
                    collectionView.insertItemsAtIndexPaths(indexPaths)
                    }, completion: { (finished) -> Void in
                        // finish infinite scroll animations
                        collectionView.finishInfiniteScroll()
                });
            }
        }
    }

    class func generateSelf() -> CocoaTableViewController{
        let board = UIStoryboard(name: "Main", bundle: nil)

        //FIX FOR TYPE SAFETY
        return board.instantiateViewControllerWithIdentifier(String(self)) as! CocoaTableViewController
    }
}

extension CocoaTableViewController {


    // MARK: - UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pods.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PodCollectionViewCell.id, forIndexPath: indexPath) as! PodCollectionViewCell

        if layoutState == .GridLayoutState {
            cell.setupGridLayoutConstraints(1, cellWidth: cell.frame.width)
        } else {
            cell.setupListLayoutConstraints(1, cellWidth: cell.frame.width)
        }

        cell.inject(pods[indexPath.row])

        return cell
    }

    // MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        let customTransitionLayout = TransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
        return customTransitionLayout
    }

    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        isTransitionAvailable = false
    }

    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isTransitionAvailable = true
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        view.endEditing(true)
    }

    func collectionView(collectionView: UICollectionView,didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Selected: \(indexPath.row)")
    }
}