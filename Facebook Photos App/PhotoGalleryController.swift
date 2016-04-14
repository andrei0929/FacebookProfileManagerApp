//
//  PhotoGalleryController.swift
//  Facebook Photos App
//
//  Created by Andrei Oltean on 4/1/16.
//  Copyright © 2016 Andrei Oltean. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import ObjectMapper
import Kingfisher

class PhotoGalleryController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FBSDKGraphRequestConnectionDelegate {
    
    var loginManager: FBSDKLoginManager! = FBSDKLoginManager.init()
    var album: Album? = nil
    var photos: Array<Photo> = []
    var uploadingPhoto = false
    var addingPhotoCell: AddingPhotoCollectionViewCell?
    
    @IBOutlet var photoGalleryCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.title = album?.name
        photoGalleryCollectionView.registerNib(UINib(nibName: "AddPhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddPhotoCollectionViewCell")
        photoGalleryCollectionView.registerNib(UINib(nibName: "AddingPhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AddingPhotoCollectionViewCell")
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
            let request = FBSDKGraphRequest(graphPath: (album?.id)! + "/photos", parameters: ["fields" : "name,images,created_time", "limit" : "\((album?.nrOfPhotos)!)"], HTTPMethod: "GET")
            request.startWithCompletionHandler { (connection, result, error) in
                let photos: Array<Photo> = Mapper<Photo>().mapArray(result.valueForKey("data")!)!
                self.photos = photos
                
                self.photoGalleryCollectionView.reloadData()
            }
        }
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (album?.nrOfPhotos)! + 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = photoGalleryCollectionView.dequeueReusableCellWithReuseIdentifier("PhotoCollectionViewCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        cell.photoImageView.layer.cornerRadius = 8.0
        cell.photoImageView.clipsToBounds = true
        if indexPath.row < self.photos.count {
            let image = self.photos[indexPath.row].images[0]
            cell.photoImageView.kf_setImageWithURL(NSURL(string: image.source)!, placeholderImage: nil)
        }
        else {
            if self.uploadingPhoto == false {
                let addCell = photoGalleryCollectionView.dequeueReusableCellWithReuseIdentifier("AddPhotoCollectionViewCell", forIndexPath: indexPath) as! AddPhotoCollectionViewCell
                return addCell
            }
            else {
                return self.addingPhotoCell!
            }
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
        //selected a photo
        if indexPath.row < self.photos.count {
            let vc: FullscreenPhotoController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(String(FullscreenPhotoController)) as! FullscreenPhotoController
            var photosDescription: [String] = []
            var photosDate: [NSDate] = []
            var photosUrl: [String] = []
            for photo in self.photos {
                photosDescription.append(photo.description ?? "")
                photosDate.append(photo.date)
                photosUrl.append(getLargestPhotoUrl(photo.images))
            }
            vc.startIndex = indexPath
            vc.photosDescription = photosDescription
            vc.photosDate = photosDate
            vc.photosUrl = photosUrl
            self.navigationController?.pushViewController(vc, animated: true)
        }
        //selected the add photo icon
        else {
            if !(FBSDKAccessToken.currentAccessToken().hasGranted("publish_actions")) {
                loginManager.logInWithPublishPermissions(["publish_actions"], fromViewController: self) { (result, error) in
                    self.didTapAddPhotoButton(indexPath)
                }
            }
            else {
                self.didTapAddPhotoButton(indexPath)
            }
        }
    }
    
    func didTapAddPhotoButton(indexPath: NSIndexPath) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.addingPhotoCell = self.photoGalleryCollectionView.dequeueReusableCellWithReuseIdentifier("AddingPhotoCollectionViewCell", forIndexPath: indexPath) as? AddingPhotoCollectionViewCell
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                imagePicker.sourceType = .PhotoLibrary
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        })
        let cameraAction = UIAlertAction(title: "Camera", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                imagePicker.sourceType = .Camera
                self.presentViewController(imagePicker, animated: true, completion: nil)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(photoLibraryAction)
        optionMenu.addAction(cameraAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true) {
            //make API call to upload the photo
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.uploadingPhoto = true
            self.addingPhotoCell?.photoImageView.image = image
            self.photoGalleryCollectionView.reloadData()
            if FBSDKAccessToken.currentAccessToken() != nil {
                let request = FBSDKGraphRequest(graphPath: (self.album?.id)! + "/photos", parameters: ["source" : UIImagePNGRepresentation(image)!], HTTPMethod: "POST")
                let connection = FBSDKGraphRequestConnection()
                connection.delegate = self
                connection.addRequest(request, completionHandler: { (connection, result, error) in
                    if error != nil {
                        let alertView = UIAlertView(title: "Error", message: "Code: \(error.userInfo["com.facebook.sdk:FBSDKGraphRequestErrorHTTPStatusCodeKey"]!)\nMessage: \(error.userInfo["com.facebook.sdk:FBSDKErrorDeveloperMessageKey"]!)", delegate: nil, cancelButtonTitle: "OK")
                        alertView.show()
                    }
                    else {
                        self.album!.nrOfPhotos = self.album!.nrOfPhotos + 1
                        self.getPhotos()
                    }
                })
                connection.start()
            }
        }
    }
    
    func requestConnection(connection: FBSDKGraphRequestConnection!, didSendBodyData bytesWritten: Int, totalBytesWritten: Int, totalBytesExpectedToWrite: Int) {
        self.addingPhotoCell?.uploadStatusProgressView.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        if totalBytesWritten == totalBytesExpectedToWrite {
            self.uploadingPhoto = false
        }
    }
}