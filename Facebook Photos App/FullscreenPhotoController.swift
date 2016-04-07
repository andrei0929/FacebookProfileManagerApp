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

class FullscreenPhotoController: UICollectionViewController {
    
    var startIndex: NSIndexPath!
    var photosUrl: [String]? = []
    var photosDescription: [String]? = []
    var photosDate: [NSDate]? = []
    
    @IBOutlet var fullscreenGalleryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fullscreenGalleryCollectionView.selectItemAtIndexPath(startIndex, animated: animated, scrollPosition: .CenteredHorizontally)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (photosUrl?.count)!
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = fullscreenGalleryCollectionView.dequeueReusableCellWithReuseIdentifier("FullscreenPhotoCollectionViewCell", forIndexPath: indexPath) as! FullscreenPhotoCollectionViewCell
        //cell.addGestureRecognizer(UIPinchGestureRecognizer(target: cell, action: #selector(cell.didZoom)))
        cell.photoImageView.kf_setImageWithURL(NSURL(string: photosUrl![indexPath.row])!, placeholderImage: nil)
        if photosDescription![indexPath.row] != "" {
            cell.descriptionTextView.text = photosDescription![indexPath.row]
            let formatter = NSDateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            cell.photoDateLabel.text = formatter.stringFromDate(photosDate![indexPath.row])
            cell.descriptionTextView.hidden = false
            cell.descriptionIcon.hidden = false
            cell.descriptionLabel.hidden = false
        }
        else {
            cell.descriptionTextView.hidden = true
            cell.descriptionIcon.hidden = true
            cell.descriptionLabel.hidden = true
        }
        return cell;
    }
    
}
