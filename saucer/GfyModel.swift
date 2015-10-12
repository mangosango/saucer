//
//  GfyModel.swift
//  saucer
//
//  Created by Sang Lee on 10/10/15.
//  Copyright © 2015 Sang Lee. All rights reserved.
//

import Foundation

class GfyModel: NSObject {
    var title: String = ""
    var g_id: String = ""
    var g_name: String = ""
    
    var thumbUrl: String = ""
    
    var mp4Url: String = ""
    var gifUrl: String = ""
    
    var views: Int = 0
    var nsfw: String = ""
    
    var width: Int = 0
    var height: Int = 0
    
    init(title: String, name: String, g_id: String, mp4: String, gif: String, thumbUrl: String, views: Int, nsfw: String, width: Int, height: Int) {
        super.init()
        
        self.title = title
        self.g_id = g_id
        self.g_name = name
        
        self.mp4Url = mp4
        self.gifUrl = gif
        self.thumbUrl = thumbUrl
        
        self.views = views
        self.nsfw = nsfw
        
        self.width = width
        self.height = height
    }
}