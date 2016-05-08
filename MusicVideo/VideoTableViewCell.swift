//
//  VideoTableViewCell.swift
//  MusicVideo
//
//  Created by Björn Fröhling on 07/05/16.
//  Copyright © 2016 Björn Fröhling. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    var video: Video? { didSet {
        updateCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell()  {
        topLabel.text = ("\(video!.rank)")
        bottomLabel.text = video?.name
        if video!.imageData != nil {
            videoImage.image = UIImage(data: video!.imageData!)
        }
        else {
            videoImage.image = UIImage(named: "default-placeholder")
           getVideoImage(video!, imageView: videoImage)
        }
        
    }
    
    func getVideoImage(video:Video, imageView:UIImageView)  {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { 
            let imgData = NSData(contentsOfURL: NSURL(string: video.imageUrl)!)
            var image: UIImage?
            if imgData != nil {
                video.imageData = imgData
                image = UIImage(data: imgData!)
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                imageView.image = image
            }
        }
    }
}
