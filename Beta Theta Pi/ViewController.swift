//
//  ViewController.swift
//  Beta Theta Pi
//
//  Created by James Weber on 12/16/17.
//  Copyright © 2017 James Weber. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var betaImage: UIImageView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    
    var username: String = String()
    var password: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        passwordField.delegate = self
        passwordField.isSecureTextEntry = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func displayUserName(_ sender: Any){
        username = usernameField.text!
        password = passwordField.text!
    }
    
}


// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        return false
    }
}
