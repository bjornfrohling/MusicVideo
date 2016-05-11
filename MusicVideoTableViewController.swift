//
//  MusicVideoTableViewController.swift
//  MusicVideo
//
//  Created by Björn Fröhling on 07/05/16.
//  Copyright © 2016 Björn Fröhling. All rights reserved.
//

import UIKit

class MusicVideoTableViewController: UITableViewController {

    var url:String = "https://itunes.apple.com/us/rss/topmusicvideos/limit=200/json"
    var videos = [Video]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add listener for connectivity
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MusicVideoTableViewController.reachabilityStatusChanged), name: "ReachStatusChanged", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(MusicVideoTableViewController.fontHasChanged) , name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    func fontHasChanged() -> Void  {
        print("font has changed")
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        reachabilityStatusChanged()
    }
    
    func didLoadData(videos:[Video]) {
        
        self.videos = videos
        self.tableView.reloadData()
    }
    
    func reachabilityStatusChanged() -> Void {
        switch reachabilityStatus {
        case NOACCESS:
            // Create User Alert
            let alert = UIAlertController(title: "No Internet Access", message: "Check your internet connectivity", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { (UIAlertAction) in
                print("Ok action")
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: { (UIAlertAction) in
                print("cancel action")
            })
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { (UIAlertAction) in
                print("delete action")
            })
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            self.presentViewController(alert, animated: true, completion: {})
            break
        case WIFI:
            break
        case WWAN:
            break
        default: break
        }
        
        runApi()
    }
    
    func runApi()  {
        // Call API
        let api = APIManager()
        api.loadData(url, completion: didLoadData)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.videos.count
    }

    private struct storyboardId {
        static let cellId = "cell"
        static let detailsSegue = "DetailViewController"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(storyboardId.cellId, forIndexPath: indexPath) as? VideoTableViewCell
        cell?.video = self.videos[indexPath.row]

        return cell!
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == storyboardId.detailsSegue {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                let video = videos[indexPath.row]
                let dvc = segue.destinationViewController as! DetailsViewController
                dvc.video = video
            }
        }
    }
}
