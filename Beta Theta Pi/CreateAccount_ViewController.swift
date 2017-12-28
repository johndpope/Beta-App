//
//  CreateAccount_ViewController.swift
//  Beta Theta Pi
//
//  Created by James Weber on 12/20/17.
//  Copyright © 2017 James Weber. All rights reserved.
//

import UIKit
import KeychainSwift
import CoreData

class CreateAccount_ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var betaEmail: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var streetAddress: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zip: UITextField!
    @IBOutlet weak var appEmail: UITextField!
    @IBOutlet weak var appUsername: UITextField!
    @IBOutlet weak var appPassword: UITextField!
    @IBOutlet weak var appConfirmPassword: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var passwordError: UILabel!
    
    let keychain = KeychainSwift()
    
    private let imageView = UIImageView()
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self as? UIScrollViewDelegate
        
        userImage.layer.borderWidth = 1
        userImage.layer.masksToBounds = false
        userImage.layer.borderColor = UIColor.clear.cgColor
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.clipsToBounds = true
        
        userImage.isUserInteractionEnabled = true
        userImage.contentMode = .scaleAspectFit
        
        firstName.delegate = self
        lastName.delegate = self
        betaEmail.delegate = self
        phone.delegate = self
        streetAddress.delegate = self
        city.delegate = self
        state.delegate = self
        zip.delegate = self
        appEmail.delegate = self
        appUsername.delegate = self
        appPassword.delegate = self
        appConfirmPassword.delegate = self
        
        
        getAllValues()
        
        if(getCoreData_Bool("defaultImageSet") && getCoreData_Bool("linkedToFB")){
            print("Profile Pic Set")
            userImage.image = getCoreDataImage("profilePic")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goBack(_ sender: Any) {
        setAllValues()
        performSegue(withIdentifier: "backToMainSegue", sender: self)
    }
    
    // MARK: Actions
    func setAllValues() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let newUser = NSEntityDescription.insertNewObject(forEntityName: "UserInfo", into: context)
        newUser.setValue(appEmail.text, forKey: "appEmail")
        newUser.setValue(appUsername.text, forKey: "appUsername")
        newUser.setValue(city.text, forKey: "city")
        newUser.setValue(betaEmail.text, forKey: "email")
        newUser.setValue(firstName.text, forKey: "firstName")
        newUser.setValue(lastName.text, forKey: "lastName")
        newUser.setValue(Int(phone.text!), forKey: "phone")
        newUser.setValue(state.text, forKey: "state")
        newUser.setValue(streetAddress.text, forKey: "streetAddress")
        newUser.setValue(Int(zip.text!), forKey: "zip")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func getAllValues() {
        appEmail.text = getCoreData_String("appEmail")
        appUsername.text = getCoreData_String("appUsername")
        city.text = getCoreData_String("city")
        betaEmail.text = getCoreData_String("email")
        firstName.text = getCoreData_String("firstName")
        lastName.text = getCoreData_String("lastName")
        phone.text = getCoreData_Int("phone") == 0 ? String() : String(getCoreData_Int("phone"))
        state.text = getCoreData_String("state")
        streetAddress.text = getCoreData_String("streetAddress")
        zip.text = getCoreData_Int("zip") == 0 ? String() : String(getCoreData_Int("zip"))
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func setUserInformation(_ attribute: String, attributeString: String) {
    }
    
    func getCoreData_String(_ attribute: String) -> String {
        var stringArr:[String] = []
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if let stringValue = data.value(forKey: attribute) as? String
                {
                    stringArr.append(stringValue)
                }
            }
        } catch {
            print("Failed")
        }
        let count = stringArr.count
        if(count > 0){
            return stringArr[count - 1]
        }
        else{
            return ""
        }
    }
    
    func getCoreData_Bool(_ attribute: String) -> Bool {
        var boolArr:[Bool] = []
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if let boolValue = data.value(forKey: attribute) as? Bool
                {
                    boolArr.append(boolValue)
                }
            }
        } catch {
            print("Failed")
        }
        let count = boolArr.count
        if(count > 0){
            return boolArr[count - 1]
        }
        else{
            return false
        }
    }
    
    func getCoreData_Int(_ attribute: String) -> Int32 {
        var intArr:[Int32] = []
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if let intValue = data.value(forKey: attribute) as? Int32
                {
                    intArr.append(intValue)
                }
            }
        } catch {
            print("Failed")
        }
        let count = intArr.count
        if(count > 0){
            return intArr[count - 1]
        }
        else{
            return 0
        }
        
    }
    
    func getCoreDataImage(_ attribute: String) -> UIImage {
        var urlStringArr:[String] = []

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                if let urltext = data.value(forKey: "profilePic") as? String{
                    urlStringArr.append(urltext)
                }
            }
        } catch {
            print("Failed")
        }
        let count = urlStringArr.count
        let url = URL(string: urlStringArr[count - 1])
        print(url!)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        return UIImage(data: data!)!
    }
    
    /* * * * * * * * * * * From TOCropViewController Example * * * * * * * * * * */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        cropController.delegate = self
        
        cropController.aspectRatioPreset = .presetSquare; //Set the initial aspect ratio as a square
        cropController.aspectRatioLockEnabled = true // The crop box is locked to the aspect ratio and can't be resized aw
        
        cropController.toolbarPosition = .top
        
        // Set photoImageView to display the selected image.
        
        self.image = image
        
        
        //If profile picture, push onto the same navigation stack
        if croppingStyle == .circular {
            picker.pushViewController(cropController, animated: true)
        }
        else { //otherwise dismiss, and then present from the main controller
            picker.dismiss(animated: true, completion: {
                self.present(cropController, animated: true, completion: nil)
            })
        }
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
        userImage.image = image
        print("image updated #1")
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
        userImage.image = image
    }
    
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        imageView.image = image
        layoutImageView()
        
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        if cropViewController.croppingStyle != .circular {
            imageView.isHidden = true
            
            cropViewController.dismissAnimatedFrom(self, withCroppedImage: image,
                                                   toView: imageView,
                                                   toFrame: CGRect.zero,
                                                   setup: { self.layoutImageView() },
                                                   completion: { self.imageView.isHidden = false })
        }
        else {
            self.imageView.isHidden = false
            cropViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    public func layoutImageView() {
        guard imageView.image != nil else { return }
        
        let padding: CGFloat = 20.0
        
        var viewFrame = self.view.bounds
        viewFrame.size.width -= (padding * 2.0)
        viewFrame.size.height -= ((padding * 2.0))
        
        var imageFrame = CGRect.zero
        imageFrame.size = imageView.image!.size;
        
        if imageView.image!.size.width > viewFrame.size.width || imageView.image!.size.height > viewFrame.size.height {
            let scale = min(viewFrame.size.width / imageFrame.size.width, viewFrame.size.height / imageFrame.size.height)
            imageFrame.size.width *= scale
            imageFrame.size.height *= scale
            imageFrame.origin.x = (self.view.bounds.size.width - imageFrame.size.width) * 0.5
            imageFrame.origin.y = (self.view.bounds.size.height - imageFrame.size.height) * 0.5
            imageView.frame = imageFrame
        }
        else {
            self.imageView.frame = imageFrame;
            self.imageView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        }
    }
    /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
    
    @IBAction func gestureRecognition(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        resignAllKeyboads()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func resignAllKeyboads() {
        // Hide the keyboard.
        firstName.resignFirstResponder()
        lastName.resignFirstResponder()
        betaEmail.resignFirstResponder()
        phone.resignFirstResponder()
        streetAddress.resignFirstResponder()
        city.resignFirstResponder()
        state.resignFirstResponder()
        zip.resignFirstResponder()
        appEmail.resignFirstResponder()
        appPassword.resignFirstResponder()
        appConfirmPassword.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignAllKeyboads()
        return false
    }
    
    @IBAction func createAccount(_ sender: Any) {
        var firstNameBool = false
        var lastNameBool = false
        var betaEmailBool = false
        var phoneBool = false
        var streetAddressBool = false
        var cityBool = false
        var stateBool = false
        var zipBool = false
        var appEmailBool = false
        var usernameBool = false
        var passwordBool = false
        var confirmPasswordBool = false
        
        // e25a5a - darker
        // e25a5a - lighter
        
        if(firstName.text == ""){
            firstName.backgroundColor = hexStringToUIColor(hex: "e25a5a")
        } else {
            firstName.backgroundColor = UIColor.white
            firstNameBool = true
        }
        if(lastName.text == ""){
            lastName.backgroundColor = hexStringToUIColor(hex: "e25a5a")
        } else {
            lastName.backgroundColor = UIColor.white
            lastNameBool = true
        }
        if(betaEmail.text == ""){
            betaEmail.backgroundColor = hexStringToUIColor(hex: "e25a5a")
        } else {
            betaEmail.backgroundColor = UIColor.white
            betaEmailBool = true
        }
        if(phone.text == ""){
            phone.backgroundColor = hexStringToUIColor(hex: "e25a5a")
        } else {
            phone.backgroundColor = UIColor.white
            phoneBool = true
        }
        if(streetAddress.text == ""){
            streetAddress.backgroundColor = hexStringToUIColor(hex: "e25a5a")
        } else {
            streetAddress.backgroundColor = UIColor.white
            streetAddressBool = true
        }
        if(city.text == ""){
            city.backgroundColor = hexStringToUIColor(hex: "e25a5a")
        } else {
            city.backgroundColor = UIColor.white
            cityBool = true
        }
        if(state.text == ""){
            state.backgroundColor = hexStringToUIColor(hex: "e25a5a")
        } else {
            state.backgroundColor = UIColor.white
            stateBool = true
        }
        if(zip.text == ""){
            zip.backgroundColor = hexStringToUIColor(hex: "e25a5a")
        } else {
            zip.backgroundColor = UIColor.white
            zipBool = true
        }
        if(appEmail.text == ""){
            appEmail.backgroundColor = hexStringToUIColor(hex: "e25a5a")
        } else {
            appEmail.backgroundColor = UIColor.white
            appEmailBool = true
        }
        if(appUsername.text == ""){
            appUsername.backgroundColor = hexStringToUIColor(hex: "e25a5a")
        } else {
            appUsername.backgroundColor = UIColor.white
            usernameBool = true
        }
        if(appPassword.text == ""){
            appPassword.backgroundColor = hexStringToUIColor(hex: "e25a5a")
        } else {
            appPassword.backgroundColor = UIColor.white
            passwordBool = true
        }
        if(appConfirmPassword.text == ""){
            appConfirmPassword.backgroundColor = hexStringToUIColor(hex: "e25a5a")
        } else {
            appConfirmPassword.backgroundColor = UIColor.white
            confirmPasswordBool = true
        }
        
        var passwordsMatch = false
        
        if(appPassword.text != appConfirmPassword.text){
            passwordError.text = "Passwords do not match!"
        } else {
            passwordError.text = "Passwords match!"
            passwordsMatch = true
        }
        
        if(firstNameBool && lastNameBool && betaEmailBool && phoneBool && streetAddressBool && cityBool && stateBool && zipBool && appEmailBool && usernameBool && passwordBool && confirmPasswordBool && passwordsMatch){
            setAllValues()
            keychain.set(appPassword.text!, forKey: "password")
            performSegue(withIdentifier: "createAccountToSplitViewSegue", sender: self)
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
