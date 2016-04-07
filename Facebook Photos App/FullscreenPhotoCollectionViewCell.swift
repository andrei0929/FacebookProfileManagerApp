//
//  FullscreenPhotoCollectionViewCell.swift
//  Facebook Photos App
//
//  Created by Andrei Oltean on 4/4/16.
//  Copyright © 2016 Andrei Oltean. All rights reserved.
//

import UIKit

class FullscreenPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoDateLabel: UILabel!
    @IBOutlet weak var dateIcon: UIImageView!
    @IBOutlet weak var descriptionIcon: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        dateIcon.image = dateIcon.image?.imageWithRenderingMode(.AlwaysTemplate)
        dateIcon.tintColor = UIColor.whiteColor()
        descriptionIcon.image = descriptionIcon.image?.imageWithRenderingMode(.AlwaysTemplate)
        descriptionIcon.tintColor = UIColor.whiteColor()
    }
    
    func didZoom(pinchGR: UIPinchGestureRecognizer) {
        let scale = pinchGR.scale
        
        self.photoImageView.transform = CGAffineTransformScale(self.photoImageView.transform, scale, scale)
        
        pinchGR.scale = 1.0
    }
}
