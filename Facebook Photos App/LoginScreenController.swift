//
//  ViewController.swift
//  Facebook Photos App
//
//  Created by Andrei Oltean on 3/25/16.
//  Copyright © 2016 Andrei Oltean. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginScreenController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let welcomeMessage = UILabel(frame: CGRectMake(68.0, 135.0, 240.0, 21.0))
        welcomeMessage.textColor = UIColor(red: 2.0 / 255.0, green: 106.0 / 255.0, blue: 221.0 / 255.0, alpha: 1.0)
        welcomeMessage.text = "Welcome to"
        welcomeMessage.font = UIFont.systemFontOfSize(18.0)
        welcomeMessage.textAlignment = NSTextAlignment.Center
        
        let logoImage = UIImage(named: "App-logo")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.frame = CGRectMake(97.0, 226.7, 181.7, 142.6)
        
        // Add a custom login button to the app
        let loginButton = UIButton(type: .Custom)
        loginButton.backgroundColor = UIColor.clearColor()
        loginButton.setTitleColor(UIColor(red: 2.0 / 255.0, green: 106.0 / 255.0, blue: 221.0 / 255.0, alpha: 1.0), forState: .Normal)
        loginButton.frame = CGRectMake(66.0, 466.0, 237.0, 48.0)
        loginButton.layer.cornerRadius = 15.0
        loginButton.layer.borderWidth = 1.0
        loginButton.layer.borderColor = UIColor(red: 2.0 / 255.0, green: 106.0 / 255.0, blue: 221.0 / 255.0, alpha: 1.0).CGColor
        loginButton.setTitle("Login with Facebook", forState: .Normal)
        
        // Handle clicks on the button
        loginButton.addTarget(self, action: #selector(loginButtonClicked), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(loginButton)
        self.view.addSubview(logoImageView)
        self.view.addSubview(welcomeMessage)
    }

    func loginButtonClicked() {
        let login = FBSDKLoginManager.init()
        
        login.logInWithReadPermissions(["public_profile", "user_photos", "user_posts", "user_status"], fromViewController: self) { (result, error) in
            if error != nil {
                NSLog("Process error")
            } else if result.isCancelled {
                NSLog("Cancelled")
            } else {
                NSLog("Logged in with read permissions")
                
                //store access token info
                NSUserDefaults.standardUserDefaults().setObject(FBSDKAccessToken.currentAccessToken().tokenString, forKey: "tokenString")
                NSUserDefaults.standardUserDefaults().setObject(NSSet(set: FBSDKAccessToken.currentAccessToken().permissions).allObjects, forKey: "permissions")
                NSUserDefaults.standardUserDefaults().setObject(NSSet(set: FBSDKAccessToken.currentAccessToken().declinedPermissions).allObjects, forKey: "declinedPermissions")
                NSUserDefaults.standardUserDefaults().setObject(FBSDKAccessToken.currentAccessToken().appID, forKey: "appID")
                NSUserDefaults.standardUserDefaults().setObject(FBSDKAccessToken.currentAccessToken().userID, forKey: "userID")
                NSUserDefaults.standardUserDefaults().setObject(FBSDKAccessToken.currentAccessToken().expirationDate, forKey: "expirationDate")
                NSUserDefaults.standardUserDefaults().setObject(FBSDKAccessToken.currentAccessToken().refreshDate, forKey: "refreshDate")
                
                let vc: MainScreenController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(String(MainScreenController)) as! MainScreenController
                vc.loginManager = login
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
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

