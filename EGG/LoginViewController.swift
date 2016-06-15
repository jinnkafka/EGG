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
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate{
    
    // MARK: Constants
     let toAllTabs = "toAllTabs"
    
    // MARK: Outlets
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var login: UIButton!
    
    // MARK: UIViewController Lifecycle
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func showTextAlert(_ title:String, msg:String, doneMsg:String, doneAction: (String) -> Void){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let sendAction = UIAlertAction(title: "Send", style: .default) { (action) in
            let emailField = alert.textFields![0]
            if self.isValidEmail(emailField.text!){
                FIRAuth.auth()?.sendPasswordReset(withEmail: emailField.text!, completion: { (error) in
                    if let error = error{
                        self.showError(error.localizedDescription)
                    }
                    else {
                        doneAction(doneMsg)
                    }
                })
            }
            else {
                self.showEmailError()
            }
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your usc email"
        }
        alert.addAction(sendAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func resetAction(_ sender: AnyObject) {
        showTextAlert("Password reset", msg: "Please enter your Email", doneMsg: "A password reset email has been delivered to your Email account.", doneAction: showSuccess)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.password.delegate = self;
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        try! FIRAuth.auth()?.signOut()

        // Lazy-Y: I'm not sure what these lines do.
//        ref.observeAuthEventWithBlock { (authData) -> Void in
//            
//            if authData != nil {
//                self.performSegueWithIdentifier(self.toAllTabs, sender: nil)
//            }
//            
//        }
    }
    
    // MARK: Actions
    @IBAction func loginDidTouch(_ sender: AnyObject) {
        
        FIRAuth.auth()?.signIn(withEmail: username.text!, password: password.text!, completion: { (user, error) in
            if error != nil {
                // an error occured while attempting login
                let alert = UIAlertController(title: "Login Error", message: "Please check your username and password", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                
            } else {
                if user?.isEmailVerified == true{
                    // user is logged in, check authData for data
                    print("Logged in");
                    self.performSegue(withIdentifier: self.toAllTabs, sender: nil)
                }
                else {
                    user?.sendEmailVerification(completion: { (error) in
                        if let error = error{
                            self.showError(error.localizedDescription)
                        }
                        else {
                            self.showError("A verification Email has been sent to your Email. Please verify your Email.")
                        }
                    })
                }
            }
        })
        
    }
    
    func isValidEmail(_ testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = Predicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidPassword(_ testStr:String)->Bool {
        
        if (testStr.characters.count >= 6){
            
            return true;
            
        }
        
        return false;
        
    }
    
    private func showEmailError(){
        let alert = UIAlertController(title: "Email Address Error", message: "Please check your email address", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSuccess(_ msg:String){
        let alert = UIAlertController(title: "Done", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showError(_ msg:String){
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signUpDidTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Register",
            message: "Register",
            preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Register",
            style: .default) { (action: UIAlertAction!) -> Void in
                
                let emailField = alert.textFields![0]
                let passwordField = alert.textFields![1]
                
                if(!self.isValidEmail(emailField.text!)){
                    self.showEmailError()
                }
                else if(!self.isValidPassword(passwordField.text!)){
                    
                    let alert = UIAlertController(title: "Password Error", message: "Please enter a password that has least 6 characters", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }
                    
                    
                else{
                    FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: self.password.text!, completion: { (user, error) in
                        if let error = error{
                            self.showError(error.localizedDescription)
                        }
                        else {
                            if let user = user{
                                user.sendEmailVerification(completion: { (error) in
                                    if let error = error{
                                        self.showError(error.localizedDescription)
                                    }
                                    else {
                                        self.showSuccess("A verification Email has been sent to your Email. Please verify your Email.")
                                    }
                                })
                            }
                            else {
                                self.showError("Cannot signup with this user")
                            }
                        }
                    })
                }
                
        }
    
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addTextField {
            (textEmail) -> Void in
            textEmail.placeholder = "Enter your usc email"
        }
        
        alert.addTextField {
            (textPassword) -> Void in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert,
            animated: true,
            completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        
        self.view.endEditing(true)
        
        login.sendActions(for: .touchUpInside)
        
        return false;
    }
    
    
    
}
