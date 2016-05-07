//
//  MusicVideoTableViewController.swift
//  MusicVideo
//
//  Created by Björn Fröhling on 07/05/16.
//  Copyright © 2016 Björn Fröhling. All rights reserved.
//

import UIKit

class MusicVideoTableViewController: UITableViewController {

    var url:String = "https://itunes.apple.com/us/rss/topmusicvideos/limit=50/json"
    var videos = [Video]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add listener for connectivity
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MusicVideoTableViewController.reachabilityStatusChanged), name: "ReachStatusChanged", object: nil)
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

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let video = self.videos[indexPath.row]
        cell.textLabel!.text = ("\(indexPath.row + 1)")
        cell.detailTextLabel?.text = video.name
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
