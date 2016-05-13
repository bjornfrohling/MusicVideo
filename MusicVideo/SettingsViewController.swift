//
//  SettingsViewController.swift
//  MusicVideo
//
//  Created by Björn Fröhling on 13/05/16.
//  Copyright © 2016 Björn Fröhling. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var securityLabel: UILabel!
    @IBOutlet weak var securitySwitch: UISwitch!
    @IBOutlet weak var imageQualityLabel: UILabel!
    @IBOutlet weak var imageQualitySwitch: UISwitch!
    @IBOutlet weak var apiCountLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(SettingsViewController.fontHasChanged) , name: UIContentSizeCategoryDidChangeNotification, object: nil)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        self.securitySwitch.on = defaults.boolForKey("securitySwitch")
        self.imageQualitySwitch.on = defaults.boolForKey("qualitySwitch")
        
        if defaults.objectForKey("apiSlider") != nil {
            let value = defaults.objectForKey("apiSlider") as! Int
            self.apiCountLabel.text = "\(value)"
            self.slider.value = Float(value)
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func fontHasChanged()  {
        self.aboutLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        self.feedbackLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        self.securityLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        self.imageQualityLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
        self.apiCountLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
    }

    @IBAction func securitySwitchDidChange(sender: AnyObject) {
        print("securitySwitchDidChange")
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(securitySwitch.on, forKey: "securitySwitch")
    }

    @IBAction func imageQualitySwitchDidChange(sender: AnyObject) {
        print("imageQualitySwitchDidChange")
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(imageQualitySwitch.on, forKey: "qualitySwitch")
    }
    
    @IBAction func apiSliderChanged(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        print("slider \(slider.value)")
        let value = Int(slider.value)
        defaults.setObject(value, forKey: "apiSlider")
        apiCountLabel.text = "\(value)"
    }
 
} // end class
