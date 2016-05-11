//
//  DetailsViewController.swift
//  MusicVideo
//
//  Created by Björn Fröhling on 10/05/16.
//  Copyright © 2016 Björn Fröhling. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var rightsLabel: UILabel!
    
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

} // end class
