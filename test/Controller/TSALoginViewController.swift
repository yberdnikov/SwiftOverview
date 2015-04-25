//
//  TSALoginViewController.swift
//  test
//
//  Created by Yuriy Berdnikov on 4/24/15.
//  Copyright (c) 2015 Yuriy Berdnikov. All rights reserved.
//

import UIKit
import Cartography
import Alamofire
import SwiftLoader

class TSALoginViewController: UIViewController {

    let usernameTextField : UITextField
    let passwordTextField : UITextField
    let submitButton : UIButton
    
    required init(coder aDecoder: NSCoder) {
        
        usernameTextField = UITextField()
        passwordTextField = UITextField()
        submitButton = UIButton.buttonWithType(.System) as! UIButton
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(usernameTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(submitButton)
        
        self.layoutUIElements()
        self.decorateUIElements()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI related
    func layoutUIElements() {
        layout(usernameTextField, passwordTextField, submitButton) { usernameTextField, passwordTextField, submitButton in
            usernameTextField.leading == usernameTextField.superview!.left + 50.0
            usernameTextField.trailing == usernameTextField.superview!.right - 50.0
            usernameTextField.centerY == usernameTextField.superview!.centerY - 100.0
            
            passwordTextField.left == usernameTextField.left
            passwordTextField.right == usernameTextField.right
            passwordTextField.top == usernameTextField.bottom + 20
            
            submitButton.height == 50.0
            submitButton.top == passwordTextField.bottom + 20
            submitButton.left == usernameTextField.left
            submitButton.right == usernameTextField.right
        }
    }
    
    func decorateUIElements() {
        usernameTextField.borderStyle = .RoundedRect
        usernameTextField.placeholder = NSLocalizedString("Username", comment: "")
        
        passwordTextField.borderStyle = .RoundedRect
        passwordTextField.secureTextEntry = true
        passwordTextField.placeholder = NSLocalizedString("Password", comment: "")
     
        submitButton.setTitle(NSLocalizedString("Submit", comment: ""), forState: .Normal)
        submitButton.addTarget(self, action: "submitButtonPressed:", forControlEvents: .TouchUpInside)
        
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5)
        SwiftLoader.setConfig(config)
    }
    
    // MARK: - UIButton selector
    func submitButtonPressed(button : UIButton) {
        if usernameTextField.text.isEmpty {
            UIAlertView(title: "", message: NSLocalizedString("Please enter username", comment: ""), delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "")).show()
            return
        }
        
        if passwordTextField.text.isEmpty {
            UIAlertView(title: "", message: NSLocalizedString("Please enter password", comment: ""), delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "")).show()
            return
        }
        
        SwiftLoader.show(animated: true)
        
        let params = ["user_username" : usernameTextField.text, "user_password" : passwordTextField.text]
        
        Alamofire.request(.POST, "http://api-wya.rhcloud.com/api/v1/user/v1/login", parameters: params)
            .responseJSON { (req, res, json, error) in
                
                SwiftLoader.hide()
                
                if (error != nil) {
                    UIAlertView(title: NSLocalizedString("Error", comment: ""), message: error!.localizedDescription, delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "")).show()
                }
                else {
                    
                    if let data = json as? NSDictionary {
                        
                        if ((data["success"]?.boolValue) == true) {
                            
                            let profileViewController = TSAProfileViewController()
                            profileViewController.userInfo = data["user"] as? NSDictionary
                            
                            self.navigationController?.pushViewController(profileViewController, animated: true)
                        }
                        else {
                            if let message = data["message"] as? String {
                                UIAlertView(title: NSLocalizedString("Error", comment: ""), message: message, delegate: nil, cancelButtonTitle: NSLocalizedString("OK", comment: "")).show()
                            }
                        }
                    }
                }
        }
    }
}
