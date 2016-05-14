//
//  DetailsViewController.swift
//  MusicVideo
//
//  Created by Björn Fröhling on 10/05/16.
//  Copyright © 2016 Björn Fröhling. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import LocalAuthentication

class DetailsViewController: UIViewController {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var rightsLabel: UILabel!
    var securitySwitchValue: Bool = false
    
    var video:Video!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = video.artist
        topLabel.text = video.name
        genreLabel.text = video.genre
        rightsLabel.text = video.right
        priceLabel.text = video.price
        
        if video.imageData != nil {
            imageView.image = UIImage(data: video.imageData!)
        }
        else {
            imageView.image = UIImage(named: "default-placeholder")
        }
    }

    @IBAction func didSelectPlayButton(sender: AnyObject) {
        print(didSelectPlayButton)
        let url = NSURL(string: video.videoUrl)!
        let player = AVPlayer(URL:url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        self.presentViewController(playerViewController, animated: true, completion: { playerViewController.player?.play()})
    }

    @IBAction func didSelectMoreActionsButton(sender: AnyObject) {
        print(didSelectMoreActionsButton)
        
        // Check if security is required
        securitySwitchValue = NSUserDefaults.standardUserDefaults().boolForKey("securitySwitch")
        switch securitySwitchValue {
        case true:
            touchIdCheck()
        default:
            shareMedia()
        }
    }
    
    func shareMedia()  {
        print("share Media")
        let string1 = "Look at this video!"
        let string2 = "\(video.name) by \(video.artist)"
        let string3 = video.iTunesLink
        
        let activityController : UIActivityViewController = UIActivityViewController(activityItems: [string1, string2, string3], applicationActivities: nil)
        activityController.completionWithItemsHandler = {
        (activity, success, items, error) in
            if activity == UIActivityTypeMail {
                print("mail selected")
            }
        }
        
        self.presentViewController(activityController, animated: true, completion: nil)
    }
    
    func touchIdCheck() {
        print("touchIdCheck")
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Cancel, handler: nil))
        
        // Create authentication context
        let context = LAContext()
        var touchIdError : NSError?
        let reasonString = "Touch-Id authentication is required to perfrom sharing"
        
        // Check if touchId is set up
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &touchIdError) {
            
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success, error) in
                if success {
                    self.shareMedia()
                }
                else {
                    // Authentication failed
                    alert.title = "Unsuccessful!"
                    
                    switch LAError(rawValue: error!.code)! {
                        
                    case .AppCancel:
                        alert.message = "Authentication was cancelled by application"
                        
                    case .AuthenticationFailed:
                        alert.message = "The user failed to provide valid credentials"
                        
                    case .PasscodeNotSet:
                        alert.message = "Passcode is not set on the device"
                        
                    case .SystemCancel:
                        alert.message = "Authentication was cancelled by the system"
                        
                    case .TouchIDLockout:
                        alert.message = "Too many failed attempts."
                        
                    case .UserCancel:
                        alert.message = "You cancelled the request"
                        
                    case .UserFallback:
                        alert.message = "Password not accepted, must use Touch-ID"
                        
                    default:
                        alert.message = "Unable to Authenticate!"
                        
                    }
                    
                    // Show the alert
                    dispatch_async(dispatch_get_main_queue()) { [unowned self] in
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                }
            })
        }
        else {
            // No touch-id authentication support
            alert.title = "TouchID error"
            
            switch LAError(rawValue: touchIdError!.code)! {
                
                case .TouchIDNotEnrolled:
                alert.message = "Touch ID is not enrolled"
                
                case .TouchIDNotAvailable:
                alert.message = "TouchID is not available on the device"
                
                case .PasscodeNotSet:
                alert.message = "Passcode has not been set"
                
                case .InvalidContext:
                alert.message = "The context is invalid"
                
                default:
                alert.message = "Local Authentication not available"
            
            }
            
            dispatch_async(dispatch_get_main_queue(), { [unowned self] in
                self.presentViewController(alert, animated: true, completion: nil)
            })
        }
        
    }

} // end class














