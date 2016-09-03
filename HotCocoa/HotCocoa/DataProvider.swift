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

    class func getPodsBasedOnPodSorting(_podSorting: PodSorting, currentNumberRetrieved: Int?, callback: ([Pod])->()){
        switch _podSorting {
        case .Recent:
            print("trying to make call")
            sharedInstance.makeRequestToServer(.POST, endpoint: "/fetch", currentNumberRetrieved: currentNumberRetrieved, callback: callback)
        case .Rating:
            print("rating")
        case .Swift:
            print("swift")
        case .ObjC:
            print("objc")
        }
    }

    internal func makeRequestToServer(requestType: Alamofire.Method, endpoint: String, currentNumberRetrieved: Int?, callback: ([Pod])->()){

        let currentNumber = (currentNumberRetrieved != nil) ? currentNumberRetrieved : 0

        let parameters = ["currentNumber": String(currentNumber)]

        Alamofire.request(requestType, Network.MAIN_URL + endpoint, parameters: parameters, encoding: .JSON, headers: nil).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    callback(DataHandler.jsonToPods(json))
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
}
