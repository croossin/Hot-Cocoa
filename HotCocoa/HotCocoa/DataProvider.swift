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

class DataProvider {
    
    class func getImageFromUrl(url: String, callback: ((UIImage)->())){
        Alamofire.request(.GET, url)
                 .responseImage { response in
                    if let image = response.result.value {
                        callback(image)
                    }
                 }
    }

    class func getPodsBasedOnPodSorting(_podSorting: PodSorting, callback: ([Pod])->()){
        switch _podSorting {
        case .Recent:
            print("recent")
        case .Rating:
            print("rating")
        case .Swift:
            print("swift")
        case .ObjC:
            print("objc")
        }
    }
}
