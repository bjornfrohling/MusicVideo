//
//  Video.swift
//  MusicVideo
//
//  Created by Björn Fröhling on 05/05/16.
//  Copyright © 2016 Björn Fröhling. All rights reserved.
//

import Foundation

class Video {

	var rank: Int = 0
	private(set) var name: String
	private(set) var imageUrl: String
	private(set) var videoUrl: String
	private(set) var rights: String
	private(set) var price: String
	private(set) var artist: String
	private(set) var artistId: String
	private(set) var genre: String
	private(set) var iTunesLink: String
	private(set) var releaseDate: String

	var imageData: NSData?

	init(data: JSONDictionary) {

		self.name = ""
		self.imageUrl = ""
		self.videoUrl = ""
		self.rights = ""
		self.price = ""
		self.artist = ""
		self.artistId = ""
		self.genre = ""
		self.iTunesLink = ""
		self.releaseDate = ""

		// Video name
		if let nameDict = data["im:name"] as? JSONDictionary,
			vName = nameDict["label"] as? String {
				self.name = vName
		}

		// Image url
		if let imgArray = data["im:image"] as? JSONArray,
			imgDict = imgArray[2] as? JSONDictionary,
			imgUrl = imgDict["label"] as? String {

				let useHighResolution = NSUserDefaults.standardUserDefaults().boolForKey("qualitySwitch")
				let resolution: String
				if useHighResolution {
					resolution = "600x600"
				}
				else {
					resolution = "300x300"
				}
				self.imageUrl = imgUrl.stringByReplacingOccurrencesOfString("100x100", withString: resolution)
		}

		// Video url
		if let videoArray = data["link"] as? JSONArray,
			videoDict = videoArray[1] as? JSONDictionary,
			urlDict = videoDict["attributes"] as? JSONDictionary,
			url = urlDict["href"] as? String {
				self.videoUrl = url
		}

		// Song price
		if let priceDict = data["im:price"] as? JSONDictionary,
			price = priceDict["label"] as? String {
				self.price = price
		}

		// The Studio Name
		if let rightsDict = data["rights"] as? JSONDictionary,
			rights = rightsDict["label"] as? String {
				self.rights = rights
		}

		// Artist Name
		if let artistDict = data["im:artist"] as? JSONDictionary,
			artist = artistDict["label"] as? String {
				self.artist = artist
		}

		// Artist ID
		if let imidDict = data["id"] as? JSONDictionary,
			vidDict = imidDict["attributes"] as? JSONDictionary,
			vImid = vidDict["im:id"] as? String {
				self.artistId = vImid
		}

		// The Genre
		if let genreDict = data["category"] as? JSONDictionary,
			attriDict = genreDict["attributes"] as? JSONDictionary,
			genre = attriDict["term"] as? String {
				self.genre = genre
		}
		// Video Link to iTunes
		if let releaseDict = data["id"] as? JSONDictionary,
			iTunesLink = releaseDict["label"] as? String {
				self.iTunesLink = iTunesLink
		}

		// Release Date
		if let releaseDict = data["im:releaseDate"] as? JSONDictionary,
			attriDict = releaseDict["attributes"] as? JSONDictionary,
			dateStr = attriDict["label"] as? String {
				self.releaseDate = dateStr
		}
	}
}

