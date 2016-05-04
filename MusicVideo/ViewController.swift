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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Call API
        let api = APIManager()
        api.loadData(url, completion: didLoadData)
        
    }

    func didLoadData(result:String) {

        let alert = UIAlertController(title: (result), message: nil, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
            // no action required
        }
        
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

}

