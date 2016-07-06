//
//  APIManager.swift
//  MusicVideo
//
//  Created by Björn Fröhling on 03/05/16.
//  Copyright © 2016 Björn Fröhling. All rights reserved.
//

import UIKit
import Contacts

class APIManager: NSObject {

	func loadData(urlString: String, completion: ([Video]) -> Void) {

		requestData(urlString) { (data, response, error) in
			if error != nil {
				print(error!.localizedDescription)
			}
			else {
				// print(data)
				self.parseJsonData(data!, completion: { (videos) in
					completion(videos)
				})
			}
		}
	}

	func requestData(urlString: String, completion: (NSData?, NSURLResponse?, NSError?) -> Void) {
		let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
		let session = NSURLSession(configuration: config)
		let url = NSURL(string: urlString)!
		let task = session.dataTaskWithURL(url) {
			(data, response, error) -> Void in
			completion(data, response, error)
		}
		task.resume()
	}

	func parseJsonData(data: NSData, completion: ([Video]) -> Void) {
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {

			var videos = [Video]()
			do {
				if let jsonDict = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
				as? JSONDictionary,
					feedDict = jsonDict["feed"] as? JSONDictionary,
					entriesArray = feedDict["entry"] as? JSONArray
				{
					for (index, entry) in entriesArray.enumerate() {
						let video = Video(data: entry as! JSONDictionary)
						video.rank = index + 1
						videos.append(video)
					}

					let videoCount = videos.count
					print("total video count \(videoCount)")
				}
			}
			catch {
				print("JSONSerialization error")
			}

			dispatch_async(dispatch_get_main_queue(), {
				completion(videos)
			})
		})
	}
}
