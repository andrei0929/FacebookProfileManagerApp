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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func didZoom(pinchGR: UIPinchGestureRecognizer) {
        let scale = pinchGR.scale
        
        self.photoImageView.transform = CGAffineTransformScale(self.photoImageView.transform, scale, scale)
        
        pinchGR.scale = 1.0
    }
}
