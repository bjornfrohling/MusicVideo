//
//  MusicVideoTableViewController.swift
//  MusicVideo
//
//  Created by Björn Fröhling on 07/05/16.
//  Copyright © 2016 Björn Fröhling. All rights reserved.
//

import UIKit

class MusicVideoTableViewController: UITableViewController, UISearchResultsUpdating {

	var videos = [Video]()
	var filterSearch = [Video]()
	var queryLimit = 10
	let resultSearchCtrl = UISearchController(searchResultsController: nil)

	override func viewDidLoad() {
		super.viewDidLoad()

		// Add listener for connectivity
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MusicVideoTableViewController.reachabilityStatusChanged), name: "ReachStatusChanged", object: nil)

		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MusicVideoTableViewController.fontHasChanged), name: UIContentSizeCategoryDidChangeNotification, object: nil)

		tableView.estimatedRowHeight = 44.0
		tableView.rowHeight = UITableViewAutomaticDimension

	}

	func fontHasChanged() -> Void {
		print("font has changed")
		tableView.reloadData()
	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)

		reachabilityStatusChanged()
	}

	func didLoadData(videos: [Video]) {

		self.videos = videos
		self.filterSearch = videos
		// Setup Search
		resultSearchCtrl.searchResultsUpdater = self
		definesPresentationContext = true
		resultSearchCtrl.dimsBackgroundDuringPresentation = false
		resultSearchCtrl.searchBar.placeholder = "Search"
		resultSearchCtrl.searchBar.searchBarStyle = UISearchBarStyle.Prominent
		tableView.tableHeaderView = resultSearchCtrl.searchBar

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
			self.presentViewController(alert, animated: true, completion: { })
			break
		case WIFI:
			break
		case WWAN:
			break
		default: break
		}

		runApi()
	}

	func runApi() {
		let formatter = NSDateFormatter()
		formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss"
		let refreshDate = formatter.stringFromDate(NSDate())
		refreshControl?.attributedTitle = NSAttributedString(string: "\(refreshDate)")

		// Get API query limit
		apiQueryCount()

		// Set nav bar title
		navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.darkGrayColor()]
		title = "iTunes Top \(queryLimit)"

		// Call API
		let api = APIManager()
		api.loadData("https://itunes.apple.com/us/rss/topmusicvideos/limit=\(queryLimit)/json", completion: didLoadData)
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
		if resultSearchCtrl.active {
			return self.filterSearch.count
		}
		else {
			return self.videos.count
		}
	}

	private struct storyboardId {
		static let cellId = "cell"
		static let detailsSegue = "DetailsViewController"
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(storyboardId.cellId, forIndexPath: indexPath) as? VideoTableViewCell

		if resultSearchCtrl.active {
			cell?.video = self.filterSearch[indexPath.row]
		}
		else {
			cell?.video = self.videos[indexPath.row]
		}

		return cell!
	}

	// MARK: - Navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

		if segue.identifier == storyboardId.detailsSegue {

			if let indexPath = tableView.indexPathForSelectedRow {
				let video: Video
				if resultSearchCtrl.active {
					video = filterSearch[indexPath.row]
				}
				else {
					video = videos[indexPath.row]
				}
				let dvc = segue.destinationViewController as! DetailsViewController
				dvc.video = video
			}
		}
	}

	@IBAction func refresh(sender: UIRefreshControl) {
		refreshControl?.endRefreshing()
		if resultSearchCtrl.active {
			refreshControl?.attributedTitle = NSAttributedString(string: "No refresh while search")
		}
		else {
			runApi()
			sender.endRefreshing()
		}
	}

	func apiQueryCount () {
		let defaults = NSUserDefaults.standardUserDefaults()
		if defaults.objectForKey("apiSlider") != nil {
			queryLimit = defaults.objectForKey("apiSlider") as! Int
		}
		else {
			queryLimit = 10
		}
	}

	// MARK: - Search
	func updateSearchResultsForSearchController(searchController: UISearchController) {
		searchController.searchBar.text!.lowercaseString
		filteredSearch(searchController.searchBar.text!)
	}

	func filteredSearch(searchText: String) {
		filterSearch = videos.filter { videos in
			return videos.artist.lowercaseString.containsString(searchText.lowercaseString)
		}
		tableView.reloadData()
	}
}

