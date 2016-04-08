//
//  MainScreenController.swift
//  Facebook Photos App
//
//  Created by Andrei Oltean on 3/28/16.
//  Copyright © 2016 Andrei Oltean. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Kingfisher
import Alamofire
import ObjectMapper

class MainScreenController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var loginManager: FBSDKLoginManager! = FBSDKLoginManager.init()
    var albums: Array<Album> = []
    
    @IBOutlet weak var coverPhoto: UIImageView!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var nrOfPhotosLabel: UILabel!
    @IBOutlet weak var nrOfAlbumsLabel: UILabel!
    @IBOutlet weak var addAlbumButton: UIButton!
    @IBOutlet weak var albumsTableView: UITableView!
    @IBOutlet weak var addAlbumView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        let logoutImage = UIImage(named: "Logout-icon")
        let backButton = UIBarButtonItem(image: logoutImage, style: .Plain, target: self, action: #selector(goBack))
        backButton.tintColor = UIColor.whiteColor()
        self.title = "Profile"
        self.navigationItem.setLeftBarButtonItem(backButton, animated: animated)
        
        albumsTableView.registerNib(UINib(nibName: "AlbumTableViewCell", bundle: nil), forCellReuseIdentifier: "AlbumTableViewCell")
        
        getCoverPhoto()
        getProfileName()
        loadAlbumsData()
    }
    
    func goBack() {
        self.navigationController?.popViewControllerAnimated(true)
        loginManager.logOut()
    }
    
    func getCoverPhoto() {
        
        class Cover : Mappable{
            var id: String!
            var offset_y: Int!
            var source: String!
            
            required init?(_ map: ObjectMapper.Map) {
                
            }
            
            func mapping(map: ObjectMapper.Map) {
                id <- map["id"]
                offset_y <- map["offset_y"]
                source <- map["source"]
            }
        }
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "cover"], HTTPMethod: "GET")
            request.startWithCompletionHandler { (connection, result, error) in
                let cover = Mapper<Cover>().map(result.valueForKey("cover"))!
                self.coverPhoto.clipsToBounds = true
                self.coverPhoto.kf_setImageWithURL(NSURL(string: cover.source)!, placeholderImage: nil)
            }
        }
    }
    
    func getProfileName() {
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "name"], HTTPMethod: "GET")
            request.startWithCompletionHandler { (connection, result, error) in
                self.profileNameLabel.text = (result.valueForKey("name")! as! String)
            }
        }
    }
    
    func getProfilePic() {
        
        for album in albums {
            if album.name == "Profile Pictures" {
                self.profilePicture.kf_setImageWithURL(NSURL(string: album.photoUrl)!, placeholderImage: nil)
                self.profilePicture.clipsToBounds = true
                self.profilePicture.layer.cornerRadius = self.profilePicture.frame.height / 2.0
            }
        }
    }
    
    func loadAlbumsData() {
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            
//            Alamofire.request(.GET, "https://graph.facebook.com/v2.5/me?", parameters: ["fields" : "albums{count}", "access_token" : "CAAWeZCWv2NGABAGGKHBblIPeu8jzXrZAOjZBuYal6ONQzoA1MimEDg1PlqDcGsN0DzhRx6FbpIrfxZAEtlZCnfv6Xn6ZAGE0ZC9dZBrA470NEWR3GZB2J6I9Fk0Mm3j8ZAKkdxGIYKR6HSZBhEkPmexaMVII9YJXViRG6nyHAqChmORzf0S2ezPL76pp7Mxd3SUfDvYhwUZAgpJbJgZDZD"]).responseJSON(completionHandler: { (response) in
//                print(response.result.value!)
//            })
            
            let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "albums{count,name,picture}"], HTTPMethod: "GET")
            request.startWithCompletionHandler { (connection, result, error) in
                let albums: Array<Album> = Mapper<Album>().mapArray((result.valueForKey("albums")!).valueForKey("data")!)!
                self.albums = albums
                self.nrOfAlbumsLabel.text = String(albums.count)
                var nrOfPhotos = 0
                for album in albums {
                    nrOfPhotos += album.nrOfPhotos
                }
                self.nrOfPhotosLabel.text = String(nrOfPhotos)
                self.getProfilePic()
                self.albumsTableView.reloadData()
            }
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(self.nrOfAlbumsLabel.text!) ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlbumTableViewCell")! as! AlbumTableViewCell
        cell.albumNameLabel.text = albums[indexPath.row].name
        cell.nrOfPhotosLabel.text = "\(albums[indexPath.row].nrOfPhotos) photos"
        cell.albumImageView.layer.cornerRadius = 8.0
        cell.albumImageView.clipsToBounds = true
        cell.albumImageView.kf_setImageWithURL(NSURL(string: albums[indexPath.row].photoUrl)!, placeholderImage: nil)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.dequeueReusableCellWithIdentifier("AlbumTableViewCell")!.frame.height
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc: PhotoGalleryController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(String(PhotoGalleryController)) as! PhotoGalleryController
        vc.album = self.albums[indexPath.row]
        vc.loginManager = self.loginManager
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapAddAlbumButton(sender: AnyObject) {
        if !(FBSDKAccessToken.currentAccessToken().hasGranted("publish_actions")) {
            loginManager.logInWithPublishPermissions(["publish_actions"], fromViewController: self) { (result, error) in
                if error != nil {
                    NSLog("Process error")
                } else if result.isCancelled {
                    NSLog("Cancelled")
                } else {
                    NSLog("Logged in with publish persmissions")
                    //expand add album view
                    let addAlbumExpandedView = UINib(nibName: "AddAlbumExpandedView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! AddAlbumExpandedView
                    addAlbumExpandedView.frame = CGRectMake(self.addAlbumView.frame.origin.x, self.addAlbumView.frame.origin.y, addAlbumExpandedView.frame.width, addAlbumExpandedView.frame.height)
                    addAlbumExpandedView.mainScreenController = self
                    addAlbumExpandedView.framesDifference = abs(addAlbumExpandedView.frame.height - self.addAlbumView.frame.height)
                    UIView.transitionFromView(self.addAlbumView, toView: addAlbumExpandedView, duration: 0.3, options: [.CurveLinear, .TransitionCrossDissolve], completion: { (completed) in
                    })
                    
                    //shrink albums table view
                    self.albumsTableView.frame = CGRectMake(self.albumsTableView.frame.origin.x, self.albumsTableView.frame.origin.y + addAlbumExpandedView.framesDifference, self.albumsTableView.frame.width, self.albumsTableView.frame.height - addAlbumExpandedView.framesDifference)
                }
            }
        }
        else {
            //expand add album view
            let addAlbumExpandedView = UINib(nibName: "AddAlbumExpandedView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! AddAlbumExpandedView
            addAlbumExpandedView.frame = CGRectMake(addAlbumView.frame.origin.x, addAlbumView.frame.origin.y, addAlbumExpandedView.frame.width, addAlbumExpandedView.frame.height)
            addAlbumExpandedView.addAlbumView = self.addAlbumView
            addAlbumExpandedView.mainScreenController = self
            addAlbumExpandedView.framesDifference = abs(addAlbumExpandedView.frame.height - self.addAlbumView.frame.height)
            UIView.transitionFromView(addAlbumView, toView: addAlbumExpandedView, duration: 0.3, options: [.CurveEaseIn, .TransitionCrossDissolve], completion: { (completed) in
            })
            
            //shrink albums table view
            self.albumsTableView.frame = CGRectMake(self.albumsTableView.frame.origin.x, self.albumsTableView.frame.origin.y + addAlbumExpandedView.framesDifference, self.albumsTableView.frame.width, self.albumsTableView.frame.height - addAlbumExpandedView.framesDifference)
        }
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
    
}
