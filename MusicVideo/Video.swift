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
    private var _rights:String
    private var _price:String
    private var _artist:String
    private var _artistId:String
    private var _genre:String
    private var _iTunesLink:String
    private var _releaseDate:String
    

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
        
        // Song price
        if let priceDict = data["im:price"] as? JSONDictionary,
            price = priceDict["label"] as? String {
            self._price = price
        }
        else {
            self._price = "-"
        }
        
        // The Studio Name
        if let rightsDict = data["rights"] as? JSONDictionary,
            rights = rightsDict["label"] as? String {
            self._rights = rights
        }
        else
        {
            self._rights = "-"
        }
        
        
        // Artist Name
        if let artistDict = data["im:artist"] as? JSONDictionary,
            artist = artistDict["label"] as? String {
            self._artist = artist
        }
        else
        {
            self._artist = "-"
        }
        
        // Artist ID
        if let imidDict = data["id"] as? JSONDictionary,
            vidDict = imidDict["attributes"] as? JSONDictionary,
            vImid = vidDict["im:id"] as? String {
            self._artistId = vImid
        }
        else
        {
            self._artistId = ""
        }
        
        // The Genre
        if let genreDict = data["category"] as? JSONDictionary,
            attriDict = genreDict["attributes"] as? JSONDictionary,
            genre = attriDict["term"] as? String {
            self._genre = genre
        }
        else
        {
            self._genre = ""
        }
        
        // Video Link to iTunes
        if let releaseDict = data["id"] as? JSONDictionary,
            iTunesLink = releaseDict["label"] as? String {
            self._iTunesLink = iTunesLink
        }
        else
        {
            self._iTunesLink = ""
        }
        
        
        // Release Date
        if let releaseDict = data["im:releaseDate"] as? JSONDictionary,
            attriDict = releaseDict["attributes"] as? JSONDictionary,
            dateStr = attriDict["label"] as? String {
            self._releaseDate = dateStr
        }
        else
        {
            self._releaseDate = ""
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
    
    var price: String {
        return _price
    }
    
    var right: String {
        return _rights
    }
    
    var artist: String {
        return _artist
    }
    
    var artistId: String {
        return _artistId
    }
    
    var genre: String {
        return _genre
    }
    
    var iTunesLink: String {
        return _iTunesLink
    }

    var releaseDate: String {
        return _releaseDate
    }

}