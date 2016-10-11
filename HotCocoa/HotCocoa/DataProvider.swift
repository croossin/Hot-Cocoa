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
import Cloudinary

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

    static func uploadImage(image: UIImage, onCompletion: ((status: Bool, url: String?) -> Void)) {
        let clouder = CLCloudinary(url: Credentials.CloudinaryUrl)
        let imageToUpload = UIImagePNGRepresentation(image)
        let uploader : CLUploader = CLUploader(clouder, delegate: nil)
        uploader.upload(imageToUpload, options: nil, withCompletion: { (dataDictionary, errorResult, code, context) in

            code < 400 ? onCompletion(status: true, url: dataDictionary["url"] as? String ?? "") : onCompletion(status: false, url:"")

        }) { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite, context) in
            ProgressController.sharedInstance.showProgress("Uploading Image", progress: Float(totalBytesWritten * 100/totalBytesExpectedToWrite)/100)
        }
    }

    class func sendFeedback(topic: String, content: String, email: String, imageUrl: String?, successCallback: (()->()), errorCallback: (()->())){

        var parameters: [String: AnyObject] = [:]

        if let imageUrl = imageUrl {
            parameters = ["topic": topic, "content": content, "email": email, "imageUrl": imageUrl]
        }else{
            parameters = ["topic": topic, "content": content, "email": email]
        }


        Alamofire.request(.POST, Network.MAIN_URL + Network.Routes.Feedback, parameters: parameters, encoding: .JSON, headers: nil).validate().responseJSON { response in
            switch response.result {
            case .Success:
                successCallback()
            case .Failure:
                errorCallback()
            }
        }
    }

    class func getAllTags(callback:([String])->()){
        Alamofire.request(.GET, Network.MAIN_URL + Network.Routes.Fetch_Tags).validate().responseJSON { response in
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
            sharedInstance.makeRequestToServerForHomePage(.POST, endpoint: Network.Routes.Fetch, currentNumberRetrieved: currentNumberRetrieved, callback: callback, errorCallback: errorCallback)
        case .Rating:
            print("Making call for RATING")
            sharedInstance.makeRequestToServerForHomePage(.POST, endpoint: Network.Routes.Fetch_Rating, currentNumberRetrieved: currentNumberRetrieved, callback: callback, errorCallback: errorCallback)
        case .Swift:
            print("Making call for SWIFT")
            sharedInstance.makeRequestToServerForHomePage(.POST, endpoint: Network.Routes.Fetch_Swift, currentNumberRetrieved: currentNumberRetrieved, callback: callback, errorCallback: errorCallback)
        case .ObjC:
            print("Making call for OBJECTIVE")
            sharedInstance.makeRequestToServerForHomePage(.POST, endpoint: Network.Routes.Fetch_ObjC, currentNumberRetrieved: currentNumberRetrieved, callback: callback, errorCallback: errorCallback)
        case .Simulator:
            print("Making call for SIMULATOR")
            sharedInstance.makeRequestToServerForHomePage(.POST, endpoint: Network.Routes.Fetch_Simulator, currentNumberRetrieved: currentNumberRetrieved, callback: callback, errorCallback: errorCallback)
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

    class func getPodsBasedOnSearchTag(platform: Platform, searchTerm: String, currentNumberRetrieved: Int, callback: ([CocoaPod])->(), errorCallback: (()->())){

        sharedInstance.makeRequestToServerForSearchTagPage(.POST, endpoint: Network.Routes.Search_Tags, platform: platform, searchTerm: searchTerm, currentNumberRetrieved: currentNumberRetrieved, callback: callback, errorCallback: errorCallback)
    }

    internal func makeRequestToServerForSearchTagPage(requestType: Alamofire.Method, endpoint: String, platform: Platform, searchTerm: String, currentNumberRetrieved: Int, callback: ([CocoaPod])->(), errorCallback: (()->())){

        let parameters = ["currentNumber": String(currentNumberRetrieved), "platform": platform.rawValue, "searchTerm":searchTerm]

        Alamofire.request(requestType, Network.MAIN_URL + endpoint, parameters: parameters, encoding: .JSON, headers: nil).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    json.isEmpty ? callback([CocoaPod]()) : callback(DataHandler.jsonToCocoaPods(json))
                }
            case .Failure(let error):
                print(error)
                errorCallback()
            }
        }
    }
}
