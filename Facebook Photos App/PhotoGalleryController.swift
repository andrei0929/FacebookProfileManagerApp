//
//  PhotoGalleryController.swift
//  Facebook Photos App
//
//  Created by Andrei Oltean on 4/1/16.
//  Copyright © 2016 Andrei Oltean. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import ObjectMapper
import Kingfisher

class PhotoGalleryController: UICollectionViewController {
    
    var album: Album? = nil
    var photos: Array<Photo> = []
    
    @IBOutlet var photoGalleryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.title = album?.name
        getPhotos()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func getPhotos() {
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            let request = FBSDKGraphRequest(graphPath: (album?.id)!, parameters: ["fields" : "photos{images}"], HTTPMethod: "GET")
            request.startWithCompletionHandler { (connection, result, error) in
                let photos: Array<Photo> = Mapper<Photo>().mapArray((result.valueForKey("photos")!).valueForKey("data")!)!
                self.photos = photos
                
                self.photoGalleryCollectionView.reloadData()
            }
        }
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (album?.nrOfPhotos)!
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = photoGalleryCollectionView.dequeueReusableCellWithReuseIdentifier("PhotoCollectionViewCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        cell.photoImageView.layer.cornerRadius = 8.0
        cell.photoImageView.clipsToBounds = true
        if indexPath.row < self.photos.count {
            let image = self.photos[indexPath.row].images[0]
            cell.photoImageView.kf_setImageWithURL(NSURL(string: image.source)!, placeholderImage: nil)
        }
        return cell
    }
    
    func getLargestPhotoUrl(images: [Image]) -> String {
        var largestImage: Image = images[0]
        var largestSize = 0
        for image in images {
            if (image.height * image.width) > largestSize {
                largestImage = image
                largestSize = image.height * image.width
            }
        }
        return largestImage.source
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let vc: FullscreenPhotoController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(String(FullscreenPhotoController)) as! FullscreenPhotoController
        var photosUrl: [String] = []
        for photo in self.photos {
            photosUrl.append(getLargestPhotoUrl(photo.images))
        }
        vc.startIndex = indexPath
        vc.photosUrl = photosUrl
        self.navigationController?.pushViewController(vc, animated: true)
    }
}