//
//  AddPhotoCollectionViewCell.swift
//  Facebook Photos App
//
//  Created by Andrei Oltean on 4/8/16.
//  Copyright © 2016 Andrei Oltean. All rights reserved.
//

import UIKit

class AddPhotoCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.borderColor = UIColor(red: 232.0 / 255.0, green: 232.0 / 255.0, blue: 232.0 / 255.0, alpha: 1.0).CGColor
    }

}
