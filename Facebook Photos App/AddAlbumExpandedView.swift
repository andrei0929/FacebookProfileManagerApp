//
//  AddAlbumExpandedView.swift
//  Facebook Photos App
//
//  Created by Andrei Oltean on 4/8/16.
//  Copyright © 2016 Andrei Oltean. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class AddAlbumExpandedView: UIView, UITextFieldDelegate {
    
    var framesDifference: CGFloat!
    var mainScreenController: MainScreenController!
    var addAlbumView: UIView!

    @IBOutlet weak var createAlbumButton: UIButton!
    @IBOutlet weak var albumNameTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        createAlbumButton.layer.cornerRadius = 13.0
        createAlbumButton.layer.borderWidth = 1.0
        createAlbumButton.layer.borderColor = UIColor(red: 2.0 / 255.0, green: 106.0 / 255.0, blue: 221.0 / 255.0, alpha: 1.0).CGColor
    }

    @IBAction func createAlbum(sender: AnyObject) {
        if FBSDKAccessToken.currentAccessToken() != nil {
            let request = FBSDKGraphRequest(graphPath: "me/albums", parameters: ["name" : albumNameTextField.text!], HTTPMethod: "POST")
            request.startWithCompletionHandler { (connection, result, error) in
                UIView.transitionFromView(self, toView: self.addAlbumView, duration: 0.3, options: [.CurveEaseIn, .TransitionCrossDissolve], completion: { (completed) in
                })
                
                //shrink albums table view
                self.mainScreenController.albumsTableView.frame = CGRectMake(self.mainScreenController.albumsTableView.frame.origin.x, self.mainScreenController.albumsTableView.frame.origin.y - self.framesDifference, self.mainScreenController.albumsTableView.frame.width, self.mainScreenController.albumsTableView.frame.height + self.framesDifference)
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
}
