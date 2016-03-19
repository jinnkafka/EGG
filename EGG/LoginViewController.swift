//
//  LoginViewController.swift
//  EGG
//
//  Created by Yuan Fu on 3/18/16.
//  Copyright © 2016 Chen Jin. All rights reserved.
//

//
//  FireLoginViewController.swift
//  FireChat-Swift
//
//  Created by Yuan Fu on 3/18/16.
//  Copyright © 2016 Firebase. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate{
    
    // MARK: Constants
     let toAllTabs = "toAllTabs"
    
    // MARK: Outlets
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var login: UIButton!
    
    // MARK: Properties
    let ref = Firebase(url: "\(BASE_URL)")
    
    // MARK: UIViewController Lifecycle
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        self.password.delegate = self;
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ref.unauth()
        
        ref.observeAuthEventWithBlock { (authData) -> Void in
            
            if authData != nil {
                self.performSegueWithIdentifier(self.toAllTabs, sender: nil)
            }
            
        }
    }
    
    // MARK: Actions
    @IBAction func loginDidTouch(sender: AnyObject) {
        
        ref.authUser(username.text, password: password.text, withCompletionBlock: { (error, auth) -> Void in
            
            if error != nil {
                // an error occured while attempting login
                let alert = UIAlertController(title: "Login Error", message: "Please check your username and password", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
                
            } else {
                // user is logged in, check authData for data
                print("Logged in");
            }
        })
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    func isValidPassword(testStr:String)->Bool {
        
        if (testStr.characters.count >= 6){
            
            return true;
            
        }
        
        return false;
        
    }
    
    
    @IBAction func signUpDidTouch(sender: AnyObject) {
        let alert = UIAlertController(title: "Register",
            message: "Register",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Register",
            style: .Default) { (action: UIAlertAction!) -> Void in
                
                let emailField = alert.textFields![0]
                let passwordField = alert.textFields![1]
                
                if(!self.isValidEmail(emailField.text!)){
                    
                    let alert = UIAlertController(title: "Email Address Error", message: "Please check your email address", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    
            }
                else if(!self.isValidPassword(passwordField.text!)){
                    
                    let alert = UIAlertController(title: "Password Error", message: "Please enter a password that has least 6 characters", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    
                }
                    
                    
                else{
                    
                    self.ref.createUser(emailField.text, password: passwordField.text) { (error: NSError!) in
                        
                        if error == nil {
                            
                            self.ref.authUser(emailField.text, password: passwordField.text, withCompletionBlock: { (error, auth) in
                                
                            })
                        }
                    }
                    
                }
                
        }
    
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textEmail) -> Void in
            textEmail.placeholder = "Enter your usc email"
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textPassword) -> Void in
            textPassword.secureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        
        self.view.endEditing(true)
        
        login.sendActionsForControlEvents(.TouchUpInside)
        
        return false;
    }
    
    
    
}
