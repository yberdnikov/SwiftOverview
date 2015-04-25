//
//  TSAProfileViewController.swift
//  test
//
//  Created by Yuriy Berdnikov on 4/24/15.
//  Copyright (c) 2015 Yuriy Berdnikov. All rights reserved.
//

import UIKit
import Cartography
import SwiftLoader
import Haneke

class TSAProfileViewController: UIViewController {

    internal var userInfo : NSDictionary?
    
    let profileBGView : UIView!
    let profileCoverImageView : UIImageView!
    let userImageView : UIImageView!
    let userDetailsContainerView : UIView!
    let usernameLabel : UILabel!
    let usernameDescriptionLabel : UILabel!
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {

        profileBGView = UIView()
        profileCoverImageView = UIImageView()
        userImageView = UIImageView()
        userDetailsContainerView = UIView()
        usernameLabel = UILabel()
        usernameDescriptionLabel = UILabel()
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(profileBGView)
        self.view.addSubview(profileCoverImageView)
        self.view.addSubview(userImageView)
        self.view.addSubview(userDetailsContainerView)
        self.userDetailsContainerView.addSubview(usernameLabel)
        self.userDetailsContainerView.addSubview(usernameDescriptionLabel)
        
        self.layoutUIElements()
        self.decorateUIElements()
        self.populateViewWithUserData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UI related
    func layoutUIElements() {
        layout(profileCoverImageView, userImageView, userDetailsContainerView) { profileCoverImageView, userImageView, userDetailsContainerView in
            profileCoverImageView.top == profileCoverImageView.superview!.top
            profileCoverImageView.left == profileCoverImageView.superview!.left
            profileCoverImageView.right == profileCoverImageView.superview!.right
            profileCoverImageView.height == 200.0

            userImageView.width == 150.0
            userImageView.height == 150.0
            userImageView.centerX == userImageView.superview!.centerX
            userImageView.centerY == profileCoverImageView.bottom
            
            userDetailsContainerView.top == userImageView.bottom + 30.0
            userDetailsContainerView.bottom == userDetailsContainerView.superview!.bottom - 30.0
            userDetailsContainerView.left == userDetailsContainerView.superview!.left + 30.0
            userDetailsContainerView.right == userDetailsContainerView.superview!.right - 30.0
        }
        
        layout(usernameLabel, usernameDescriptionLabel) { usernameLabel, usernameDescriptionLabel in
            
            usernameLabel.top == usernameLabel.superview!.top + 20.0
            usernameLabel.left == usernameLabel.superview!.left + 20.0
            usernameLabel.right == usernameLabel.superview!.right + 20.0
            
            usernameDescriptionLabel.top == usernameLabel.bottom + 10.0
            usernameDescriptionLabel.left == usernameDescriptionLabel.superview!.left + 30.0
            usernameDescriptionLabel.right == usernameDescriptionLabel.superview!.right - 30.0
            usernameDescriptionLabel.bottom == usernameDescriptionLabel.superview!.bottom - 30.0
        }
    }
    
    func decorateUIElements() {
        
        self.view.backgroundColor = UIColor.greenColor()
        
        self.profileCoverImageView.backgroundColor = UIColor.redColor()
        self.profileCoverImageView.contentMode = .ScaleAspectFill
        self.profileCoverImageView.clipsToBounds = true
        
        self.userImageView.backgroundColor = UIColor.whiteColor()
        self.userImageView.layer.cornerRadius = CGRectGetHeight(self.userImageView.bounds) / 2.0
        self.userImageView.layer.masksToBounds = true
        self.userImageView.contentMode = .ScaleAspectFill
        self.userImageView.clipsToBounds = true
        
        self.userDetailsContainerView.backgroundColor = UIColor.whiteColor()
        
        self.usernameLabel.font = UIFont.boldSystemFontOfSize(25.0)
        
        self.usernameDescriptionLabel.numberOfLines = 0
        self.usernameDescriptionLabel.lineBreakMode = .ByWordWrapping
    }
    
    func populateViewWithUserData() {
        
        if let userInfo = self.userInfo {
            if let userDisplayName = userInfo["user_display_name"] as? String {
                self.usernameLabel.text = userDisplayName
            }
            
            if let coverImageURL = userInfo["user_cover_image_url"] as? String {
                self.profileCoverImageView.hnk_setImageFromURL(NSURL(string: coverImageURL)!)
            }
            
            if let profileImageURL = userInfo["user_main_image_url"] as? String {
                self.userImageView.hnk_setImageFromURL(NSURL(string: profileImageURL)!)
            }
            
            if let userDescription = userInfo["user_description"] as? String {
                self.usernameDescriptionLabel.text = userDescription
            }
            
        } else {
            
            // remove - only for testing
            
            self.usernameLabel.text = "yuewwe wefybewufyew"
            self.usernameDescriptionLabel.text = "yuewwe wefybewufyew\n1sfsddfsf\n4565464\n8973"
            self.profileCoverImageView.hnk_setImageFromURL(NSURL(string: "http://www.joomlaworks.net/images/demos/galleries/abstract/7.jpg")!)
            self.userImageView.hnk_setImageFromURL(NSURL(string: "http://upload.wikimedia.org/wikipedia/commons/thumb/b/bf/GOES-13_First_Image_jun_22_2006_1730Z.jpg/1438px-GOES-13_First_Image_jun_22_2006_1730Z.jpg")!)
        }
    }
}
