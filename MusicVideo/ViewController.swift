//
//  ViewController.swift
//  MusicVideo
//
//  Created by Björn Fröhling on 03/05/16.
//  Copyright © 2016 Björn Fröhling. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label: UILabel!
    
    var url:String = "https://itunes.apple.com/us/rss/topmusicvideos/limit=50/json"
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
        self.tableView.reloadData()
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
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let video = self.videos[indexPath.row]
        cell.textLabel!.text = ("\(indexPath.row + 1)")
        cell.detailTextLabel?.text = video.name
        return cell
    }

} // end class

