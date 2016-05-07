//
//  ViewController.swift
//  MusicVideo
//
//  Created by Björn Fröhling on 03/05/16.
//  Copyright © 2016 Björn Fröhling. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    var url:String = "https://itunes.apple.com/us/rss/topmusicvideos/limit=10/json"
    var videos = [Video]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add listener for connectivity
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityStatusChanged", name: "ReachStatusChanged", object: nil)
        reachabilityStatusChanged()

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
    
    func reachabilityStatusChanged() -> Void {
        switch reachabilityStatus {
        case NOACCESS:
            view.backgroundColor = UIColor.redColor()
        case WIFI:
            view.backgroundColor = UIColor.greenColor()
        case WWAN:
            view.backgroundColor = UIColor.yellowColor()
        default:
            return
        }
        
        label.text = reachabilityStatus
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
} // end class

