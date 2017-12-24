//
//  ViewController.swift
//  Beta Theta Pi
//
//  Created by James Weber on 12/16/17.
//  Copyright © 2017 James Weber. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit
import AWSAuthCore
import AWSAuthUI
import AWSMobileClient
import AWSUserPoolsSignIn
import AWSFacebookSignIn
import AWSGoogleSignIn
import LocalAuthentication
import KeychainSwift

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var betaImage: UIImageView!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !AWSSignInManager.sharedInstance().isLoggedIn {
            presentAuthUIViewController()
        }
        
        if(getUsername() != ""){
            setUserInformation(getUsername())
        } else {
            setUserInformation("")
        }
        
        usernameField.delegate = self
        passwordField.delegate = self
        passwordField.isSecureTextEntry = true
        
        usernameField.text = getUsername()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signIn(_ sender: Any) {
        // Disable keyboards
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        if usernameField.text != "" && passwordField.text != "" {
            if let passwordKey = keychain.get("password") {
                if (passwordField.text == passwordKey) && (usernameField.text == getUsername()) {
                    self.performSegue(withIdentifier: "loginToSplitViewSegue", sender: self)
                }
                else if (passwordField.text == passwordKey) || (usernameField.text != getUsername()) {
                    errorMessage.text = "Incorrect username or password"
                }
                else if (passwordField.text != passwordKey) || (usernameField.text != getUsername()) {
                    errorMessage.text = "Incorrect username or password"
                }
                else {
                    errorMessage.text = "Password incorrect"
                }
            }
            else
            {
                errorMessage.text = "No account created for yet!"
            }
        }
        else {
            errorMessage.text = "Username or Password field empty"
        }
    }
    
    func getUsername() -> String {
        var usernameArr:[String] = []
    
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if let username = data.value(forKey: "appUsername") as? String
                {
                    usernameArr.append(username)
                }
            }
        } catch {
            print("Failed")
        }
        let count = usernameArr.count
        if(count > 0){
            return usernameArr[usernameArr.count - 1]
        }
        else{
            return ""
        }
    }
    
    func getLinkedToFB() -> Bool {
        var linkedToFBArr:[Bool] = []
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if let linkedToFB = data.value(forKey: "linkedToFB") as? Bool
                {
                    linkedToFBArr.append(linkedToFB)
                }
            }
        } catch {
            print("Failed")
        }
        let count = linkedToFBArr.count
        if(count > 0){
            return linkedToFBArr[linkedToFBArr.count - 1]
        }
        else{
            return false
        }
    }
    
    func setUserInformation(_ username: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "UserInfo", into: context)
        newUser.setValue(username, forKey: "appUsername")
        newUser.setValue(true, forKey: "defaultImageSet")
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func setUserInformationFromFB() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "UserInfo", into: context)
        
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    newUser.setValue(true, forKey: "linkedToFB")
                    //everything works print the user data
                    print("--------- USER DATA --------")
                    let fbDetails = result as! NSDictionary
                    
                    let id: String = fbDetails.object(forKey: "id") as! String
                    let intID: Int = Int(id)!
                    print(intID)
                    
                    let first_name: String = fbDetails.object(forKey: "first_name") as! String
                    print(first_name)
                    
                    let last_name: String = fbDetails.object(forKey: "last_name") as! String
                    print(last_name)
                    
                    let profilePicDict1 = fbDetails.object(forKey: "picture") as! NSDictionary
                    let profilePicDict2 = profilePicDict1.object(forKey: "data") as! NSDictionary
                    let profilePicUrl: String = profilePicDict2.object(forKey: "url") as! String
                    
                    newUser.setValue(profilePicUrl, forKey: "profilePic")
                    
                    //let profilePicUrl = profilePic
                    //print(profilePic)
                    
                    /*let url = URL(string: image.url)
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    imageView.image = UIImage(data: data!)
                    */
                    print("----------------------------")
                }
            })
        }
    }
    
    func printUserInformation(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print("Username: ")
                print(data.value(forKey: "appUsername") as! String)
            }
        } catch {
            print("Failed")
        }
    }
    
    /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
    // Code from https://stackoverflow.com/questions/36380389/customized-facebook-login-button-after-integration
    @IBAction func loginFacebookAction(sender: AnyObject) {//action of the custom button in the storyboard
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if((fbloginresult.grantedPermissions) != nil)
                {
                    if(self.getLinkedToFB()){
                        print("gucci")
                        self.setUserInformationFromFB()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            // your code here For Pushing to Another Screen
                            self.performSegue(withIdentifier: "createAccountSegue", sender: self)
                        }
                    }
                    else {
                        print("not gucci")
                        // create the alert
                        let alert = UIAlertController(title: "Create Account with FB?", message: "If you choose not to, you will be filling out more information!", preferredStyle: UIAlertControllerStyle.alert)
                        
                        // add the actions (buttons)
                        let alertAction = UIAlertAction( title : "Continue", style: UIAlertActionStyle.default) { action in
                            self.setUserInformationFromFB()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                // your code here For Pushing to Another Screen
                                self.performSegue(withIdentifier: "createAccountSegue", sender: self)
                            }
                        }
                        alert.addAction(alertAction)
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        
    }
    /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
    
    var username: String = String()
    var password: String = String()
    
    @IBAction func displayUserName(_ sender: Any){
        username = usernameField.text!
        password = passwordField.text!
        setUserInformation(username)
    }
    
    @IBAction func touchIDSignIn(_ sender: Any) {
        authenticationWithTouchID(sender)
    }
    
    func presentAuthUIViewController() {
        let config = AWSAuthUIConfiguration()
        config.enableUserPoolsUI = true
        config.addSignInButtonView(class: AWSFacebookSignInButton.self)
        config.addSignInButtonView(class: AWSGoogleSignInButton.self)
        config.backgroundColor = UIColor.blue
        config.font = UIFont (name: "Helvetica Neue", size: 20)
        config.isBackgroundColorFullScreen = true
        config.canCancel = true
        
        /*AWSAuthUIViewController.presentViewController(
            with: self.navigationController!,
            configuration: config, completionHandler: { (provider: AWSSignInProvider, error: Error?) in
                if error == nil {
                    // SignIn succeeded.
                } else {
                    // end user faced error while loggin in, take any required action here.
                }
        }) */
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        return false
    }

    func authenticationWithTouchID(_ sender: Any) {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Use Passcode"
        
        var authError: NSError?
        let reasonString = "Allow for access to Beta Theta Pi App"
        
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString) { success, evaluateError in
                
                if success {
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01){
                        // your code here For Pushing to Another Screen
                        self.performSegue(withIdentifier: "loginToSplitViewSegue", sender: self)
                    }
                    //TODO: User authenticated successfully, take appropriate action
                    
                    
                } else {
                    //TODO: User did not authenticate successfully, look at error and take appropriate action
                    guard let error = evaluateError else {
                        return
                    }
                    
                    print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error._code))
                    
                    //TODO: If you have choosen the 'Fallback authentication mechanism selected' (LAError.userFallback). Handle gracefully
                    
                }
            }
        } else {
            
            guard let error = authError else {
                return
            }
            //TODO: Show appropriate alert if biometry/TouchID/FaceID is lockout or not enrolled
            print(self.evaluateAuthenticationPolicyMessageForLA(errorCode: error.code))
        }
    }
    
    func evaluatePolicyFailErrorMessageForLA(errorCode: Int) -> String {
        var message = ""
        if #available(iOS 11.0, macOS 10.13, *) {
            switch errorCode {
            case LAError.biometryNotAvailable.rawValue:
                message = "Authentication could not start because the device does not support biometric authentication."
                
            case LAError.biometryLockout.rawValue:
                message = "Authentication could not continue because the user has been locked out of biometric authentication, due to failing authentication too many times."
                
            case LAError.biometryNotEnrolled.rawValue:
                message = "Authentication could not start because the user has not enrolled in biometric authentication."
                
            default:
                message = "Did not find error code on LAError object"
            }
        } else {
            switch errorCode {
            case LAError.touchIDLockout.rawValue:
                message = "Too many failed attempts."
                
            case LAError.touchIDNotAvailable.rawValue:
                message = "TouchID is not available on the device"
                
            case LAError.touchIDNotEnrolled.rawValue:
                message = "TouchID is not enrolled on the device"
                
            default:
                message = "Did not find error code on LAError object"
            }
        }
        
        return message;
    }
    
    func evaluateAuthenticationPolicyMessageForLA(errorCode: Int) -> String {
        
        var message = ""
        
        switch errorCode {
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.notInteractive.rawValue:
            message = "Not interactive"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = evaluatePolicyFailErrorMessageForLA(errorCode: errorCode)
        }
        
        return message
    }
    
}

