//
//  ApiProvider.swift
//  MyYoutube
//
//  Created by Thao Truong on 4/21/18.
//  Copyright © 2018 GEM. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

private let baseUrl = "https://www.googleapis.com/youtube/v3/"
private let key = "AIzaSyBcpkMOduqF0gD3g45Vg2Iwe6LQ7-6aDMo"

class ApiProvider: NSObject {
    static func getListVideo(keySearch: String?, completition: @escaping (_ videos: [Video]) -> ()) {
        print("Calling API")
        let url = baseUrl + "search"
        var params: Parameters = ["key": key]
        params["part"] = "snippet"
        params["maxResults"] = 15
        
        if keySearch != nil && keySearch!.count > 0 {
            params["q"] = keySearch
        }
        
        Alamofire.request(url, parameters: params).responseJSON { (response) in
            var videos = [Video]()
            if response.result.isSuccess {
                guard let value = response.value else {
                    completition(videos)
                    return
                }
                let json = JSON(value)
                for item in json["items"].arrayValue {
                    let video = Video.init(json: item)
                    videos.append(video)
                }
            }
            completition(videos)
        }
    }
}

