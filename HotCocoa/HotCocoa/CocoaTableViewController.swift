//
//  CocoaTableViewController.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/1/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit
import UIScrollView_InfiniteScroll
import SVProgressHUD
import FoldingCell

protocol CocoaTableViewControllerDelegate: class {
    func loadingStarted(currentPodPage: PodSorting)
    func loadingEnded(currentPodPage: PodSorting)
}

class CocoaTableViewController: UITableViewController {

    let kCloseCellHeight: CGFloat = 179
    let kOpenCellHeight: CGFloat = 488

    let kRowsCount = 10

    var cellHeights = [CGFloat]()

    private var pods = [Pod]()

    var podSorting: PodSorting = .Recent

    weak var delegate: CocoaTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)

        _loadPods()

        _setupInfiniteScroll()
    }

    // MARK: configure
    func createCellHeightsArray() {
        for _ in 0...pods.count {
            cellHeights.append(kCloseCellHeight)
        }
    }

    private func _loadPods(){
        delegate?.loadingStarted(self.podSorting)

        DataProvider.getPodsBasedOnPodSorting(podSorting, currentNumberRetrieved: pods.count, callback: { listOfPods in
            self.pods = listOfPods

            self.createCellHeightsArray()

            self.tableView.reloadData()

            self.delegate?.loadingEnded(self.podSorting)
            }, errorCallback: {
                SVProgressHUD.showErrorWithStatus("Unable to connect to server")
        })
    }

    private func _setupInfiniteScroll(){
        // change indicator view style to white
        tableView.infiniteScrollIndicatorStyle = .White

        // Add infinite scroll handler
        tableView.addInfiniteScrollWithHandler { (tableView) -> Void in

            DataProvider.getPodsBasedOnPodSorting(self.podSorting, currentNumberRetrieved: self.pods.count, callback: {[weak self](listOfPods) in

                guard let strongSelf = self else { return }

                    var indexPaths = [NSIndexPath]() // index paths of updated rows
                    var indexPathRow = strongSelf.pods.count

                    for pod in listOfPods{
                        strongSelf.pods.append(pod)
                        indexPaths.append(NSIndexPath(forRow: indexPathRow, inSection: 0))
                        indexPathRow += 1
                    }

                    strongSelf.createCellHeightsArray()

                    // make sure you update tableView before calling -finishInfiniteScroll
                    tableView.beginUpdates()
                    tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
                    tableView.endUpdates()

                    // finish infinite scroll animation
                    tableView.finishInfiniteScroll()
                }, errorCallback: { 
                    SVProgressHUD.showErrorWithStatus("Unable to connect to server")
            })
        }
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pods.count
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {

        guard case let cell as PodCell = cell else {
            return
        }

        cell.backgroundColor = UIColor.clearColor()

        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.selectedAnimation(false, animated: false, completion:nil)
        } else {
            cell.selectedAnimation(true, animated: false, completion: nil)
        }

        cell.loadCell(pods[indexPath.row])

        cell.number = indexPath.row
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FoldingCell", forIndexPath: indexPath)

        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }

    // MARK: Table vie delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let cell = tableView.cellForRowAtIndexPath(indexPath) as! FoldingCell

        if cell.isAnimating() {
            return
        }

        var duration = 0.0
        if cellHeights[indexPath.row] == kCloseCellHeight { // open cell
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {// close cell
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 0.8
        }

        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
            }, completion: nil)   
    }
}