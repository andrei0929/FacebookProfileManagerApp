//
//  FullscreenPhotoController.swift
//  Facebook Photos App
//
//  Created by Andrei Oltean on 4/4/16.
//  Copyright © 2016 Andrei Oltean. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import ObjectMapper
import Kingfisher

class FullscreenPhotoController: UIViewController {
    
    var photoUrl: String? = nil
    
    @IBOutlet weak var photoView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        photoView.kf_setImageWithURL(NSURL(string: photoUrl!)!, placeholderImage: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
}
