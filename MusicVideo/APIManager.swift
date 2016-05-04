//
//  APIManager.swift
//  MusicVideo
//
//  Created by Björn Fröhling on 03/05/16.
//  Copyright © 2016 Björn Fröhling. All rights reserved.
//

import UIKit

class APIManager: NSObject {

    func loadData(urlString:String, completion:(result:String)-> Void)  {
        
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: config)

        let url = NSURL(string:urlString)!
        
        //     public func dataTaskWithURL(url: NSURL, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) -> NSURLSessionDataTask
        let task = session.dataTaskWithURL(url) {
            (data, response, error)->Void in
            
            dispatch_async(dispatch_get_main_queue()) {
                if error != nil {
                    completion(result: (error!.localizedDescription))
                }
                else {
                    completion(result: "NSURLSession successful")
                    print(data)
                }
            }
        }
        task.resume()
    }
}
