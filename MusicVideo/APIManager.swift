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

    func loadData(urlString:String, completion:([Video])-> Void)  {
        
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: config)

        let url = NSURL(string:urlString)!
        
        let task = session.dataTaskWithURL(url) {
            (data, response, error)->Void in
            
            if error != nil {
                    print(error!.localizedDescription)
            }
            else {

                print(data)
                
                do {
                
                    if let jsonDict = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments)
                        as? JSONDictionary,
                    feedDict = jsonDict["feed"] as? JSONDictionary,
                    entriesArray = feedDict["entry"] as? JSONArray
                    {
                    
                        var videos = [Video]()
                        for (index, entry) in entriesArray.enumerate() {
                            let video = Video(data: entry as! JSONDictionary)
                            video.rank = index
                            videos.append(video)
                        }
                        
                        let videoCount = videos.count
                        print("total video count \(videoCount)")
                        
                        let priority = DISPATCH_QUEUE_PRIORITY_HIGH
                        dispatch_async(dispatch_get_global_queue(priority, 0), {
                            
                            
                            dispatch_async(dispatch_get_main_queue(), {
                                completion(videos)
                            })
                        })

                    }
                }
                catch {
                        print("JSONSerialization error")
                }
                
            }

        }
        task.resume()
    }
}
