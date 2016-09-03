//
//  DataProvider.swift
//  HotCocoa
//
//  Created by Chase Roossin on 9/1/16.
//  Copyright © 2016 crmobiledev. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class DataProvider {
    static let sharedInstance = DataProvider()

    class func getImageFromUrl(url: String, callback: ((UIImage)->())){
        Alamofire.request(.GET, url)
                 .responseImage { response in
                    if let image = response.result.value {
                        callback(image)
                    }
                 }
    }

    class func getAllTags(callback:([String])->()){
        Alamofire.request(.GET, Network.MAIN_URL + "/fetch/tags").validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    //fix for type safety
                    callback(value as! [String])
                }
            case .Failure(let error):
                print(error)
            }
        }
    }

    class func getTagsFromFuzzySearch(searchTerm: String, callback: ([String])->()){
        Alamofire.request(.GET, Network.MAIN_URL + "/search/fuzzySearchTags/" + searchTerm).validate().responseJSON { response in
            print(response)
        }
    }

    class func getPodsBasedOnPodSorting(_podSorting: PodSorting, currentNumberRetrieved: Int, callback: ([Pod])->(), errorCallback: (()->())){
        switch _podSorting {
        case .Recent:
            print("Making call for RECENT")
            sharedInstance.makeRequestToServerForHomePage(.POST, endpoint: "/fetch", currentNumberRetrieved: currentNumberRetrieved, callback: callback, errorCallback: errorCallback)
        case .Rating:
            print("Making call for RATING")
            sharedInstance.makeRequestToServerForHomePage(.POST, endpoint: "/fetch/rating", currentNumberRetrieved: currentNumberRetrieved, callback: callback, errorCallback: errorCallback)
        case .Swift:
            print("Making call for SWIFT")
            sharedInstance.makeRequestToServerForHomePage(.POST, endpoint: "/fetch/language/swift", currentNumberRetrieved: currentNumberRetrieved, callback: callback, errorCallback: errorCallback)
        case .ObjC:
            print("Making call for OBJECTIVE")
            sharedInstance.makeRequestToServerForHomePage(.POST, endpoint: "/fetch/language/objc", currentNumberRetrieved: currentNumberRetrieved, callback: callback, errorCallback: errorCallback)
        }
    }

    internal func makeRequestToServerForHomePage(requestType: Alamofire.Method, endpoint: String, currentNumberRetrieved: Int, callback: ([Pod])->(), errorCallback: (()->())){

        let parameters = ["currentNumber": String(currentNumberRetrieved)]

        Alamofire.request(requestType, Network.MAIN_URL + endpoint, parameters: parameters, encoding: .JSON, headers: nil).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    callback(DataHandler.jsonToPods(json))
                }
            case .Failure(let error):
                print(error)
                errorCallback()
            }
        }
    }
}
