//
//  ViewController.swift
//  MusicVideo
//
//  Created by Björn Fröhling on 03/05/16.
//  Copyright © 2016 Björn Fröhling. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var url:String = "https://itunes.apple.com/us/rss/topmusicvideos/limit=10/json"
    var videos = [Video]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Call API
        let api = APIManager()
        api.loadData(url, completion: didLoadData)
    }

    func didLoadData(videos:[Video]) {

        self.videos = videos
  
        for (index, item) in videos.enumerate() {
            print("name = \(item.name) index = \(index)")

        }
    }
}

