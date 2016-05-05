//
//  Video.swift
//  MusicVideo
//
//  Created by Björn Fröhling on 05/05/16.
//  Copyright © 2016 Björn Fröhling. All rights reserved.
//

import Foundation

class Video {
private var _name:String
private var _imageUrl:String
private var _videoUrl:String

    init(data:JSONDictionary) {
    
        // Video name
        if let nameDict = data["im:name"] as? JSONDictionary,
            vName = nameDict["label"] as? String {
            self._name = vName
        }
        else {
            self._name = "-"
        }
        
        // Image url
        if let imgArray = data["im:image"] as? JSONArray,
            imgDict = imgArray[2] as? JSONDictionary,
            imgUrl = imgDict["label"] as? String {
            self._imageUrl = imgUrl.stringByReplacingOccurrencesOfString("100x100", withString: "600x600")
        }
        else {
            self._imageUrl = ""
        }
        
        // Video url 
        if let videoArray = data["link"] as? JSONArray,
        videoDict = videoArray[1] as? JSONDictionary,
        urlDict = videoDict["attributes"] as? JSONDictionary,
            url = urlDict["href"] as? String {
            self._videoUrl = url
        }
        else {
            self._videoUrl = ""
        }
    }
    
    var name: String {
        return _name
    }
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var videoUrl: String {
        return _videoUrl
    }
    
}