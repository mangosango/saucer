//
//  GfyNetwork.swift
//  saucer
//
//  Created by Sang Lee on 10/10/15.
//  Copyright © 2015 Sang Lee. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

var GFY_CURSOR: String = ""

class GfyNetwork {
    
//    Get trending Gfys given a cursor
    func getTrendingGfys(cursor: String, completionHandler: (Array<GfyModel>) -> (Array<GfyModel>)) -> Array<GfyModel> {
        var gfys = [GfyModel]()
        if (cursor == "") { // If we're getting top
            Alamofire.request(.GET, "https://gfycat.com/cajax/getTrendingGfycats").responseJSON { response in
                let json = JSON(response.result.value!)
                // print("JSON: \(JSON)")
                GFY_CURSOR = json["cursor"].stringValue
                if let responseArray = json["gfyList"].array {
                    for gfy in responseArray {
                        let title: String = gfy["title"].stringValue
                        let id: String = gfy["gfyId"].stringValue
                        let name: String = gfy["gfyName"].stringValue
                        
                        let mp4Url: String = gfy["mp4Url"].stringValue
                        let gifUrl: String = gfy["gifUrl"].stringValue
                        let thumbUrl: String = "https://thumbs.gfycat.com/\(name)-thumb360.jpg"
                        
                        let views: Int = gfy["views"].intValue
                        let nsfw: String = gfy["nsfw"].stringValue
                        
                        let width: Int = gfy["width"].intValue
                        let height: Int = gfy["height"].intValue
                        
                        let gfyToAdd = GfyModel(title: title, name: name, g_id: id, mp4: mp4Url, gif: gifUrl, thumbUrl: thumbUrl, views: views, nsfw: nsfw, width: width, height: height)
                        gfys.append(gfyToAdd)
                    }
                    completionHandler(gfys)
                }
            }
        } else { // we're already browsing
            Alamofire.request(.GET, "https://gfycat.com/cajax/getTrendingGfycatsForCursor", parameters: ["cursor": cursor]).responseJSON { response in
                let json = JSON(response.result.value!)
                GFY_CURSOR = json["cursor"].stringValue
                if let responseArray = json["gfyList"].array {
                    for gfy in responseArray {
                        let title: String = gfy["title"].stringValue
                        let id: String = gfy["gfyId"].stringValue
                        let name: String = gfy["gfyName"].stringValue
                        
                        let mp4Url: String = gfy["mp4Url"].stringValue
                        let gifUrl: String = gfy["gifUrl"].stringValue
                        let thumbUrl: String = "https://thumbs.gfycat.com/\(name)-thumb360.jpg"
                        
                        let views: Int = gfy["views"].intValue
                        let nsfw: String = gfy["nsfw"].stringValue
                        
                        let width: Int = gfy["width"].intValue
                        let height: Int = gfy["height"].intValue
                        
                        let gfyToAdd = GfyModel(title: title, name: name, g_id: id, mp4: mp4Url, gif: gifUrl, thumbUrl: thumbUrl, views: views, nsfw: nsfw, width: width, height: height)
                        gfys.append(gfyToAdd)
                    }
                    completionHandler(gfys)
                }
            }
        }
        return gfys
    }
}
