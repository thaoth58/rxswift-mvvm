//
//  Video.swift
//  MyYoutube
//
//  Created by Thao Truong on 4/21/18.
//  Copyright © 2018 GEM. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Video {
    let id: String!
    let url: String?
    let title: String?
    let desc: String?
    let thumbnailUrl: String?
    
    init(json: JSON) {
        id = json["id"]["videoId"].stringValue
        url = "https://www.youtube.com/watch?v=" + id
        let snippet = json["snippet"]
        title = snippet["title"].string
        desc = snippet["description"].string
        thumbnailUrl = snippet["thumbnails"]["high"]["url"].string
    }
}
