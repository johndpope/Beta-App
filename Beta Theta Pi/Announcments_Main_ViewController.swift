//
//  Announcments_Main_ViewController.swift
//  Beta Theta Pi
//
//  Created by James Weber on 12/22/17.
//  Copyright © 2017 James Weber. All rights reserved.

import UIKit
import SideMenu

class Announcments_Main_ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //performSegue(withIdentifier: "announcementSegue", sender: self)
        
        //let image = UIImage(named: "hambugerButton")
        //navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
        
            //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        
        // Left Side Menu
        let hButtonContainer:UIView = UIView()
        hButtonContainer.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        
        let hButtonImage = UIImage(named: "hamburgerButton")
        
        let hButton = UIButton.init(type: .custom)
        hButton.setImage(hButtonImage, for: .normal)
        hButton.frame = hButtonContainer.frame
        hButton.addTarget(self, action: #selector(hButtonAction), for: .touchUpInside)
        
        hButtonContainer.addSubview(hButton)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: hButtonContainer)
        SideMenuManager.default.menuWidth = view.frame.width * 0.75
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor.clear
        SideMenuManager.default.menuBlurEffectStyle = .light

        // Right Side Menu
        let sButtonContainer:UIView = UIView()
        sButtonContainer.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        
        let sButtonImage = UIImage(named: "settingsIcon")
        
        let sButton = UIButton.init(type: .custom)
        sButton.setImage(sButtonImage, for: .normal)
        sButton.frame = sButtonContainer.frame
        sButton.addTarget(self, action: #selector(sButtonAction), for: .touchUpInside)
        
        sButtonContainer.addSubview(sButton)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: sButtonContainer)
        SideMenuManager.default.menuWidth = view.frame.width * 0.75
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor.clear
        SideMenuManager.default.menuBlurEffectStyle = .light

        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func hButtonAction() {
        performSegue(withIdentifier: "sideMenuNavigator", sender: self)
    }
    
    @objc func sButtonAction() {
        performSegue(withIdentifier: "settingsNavigator", sender: self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
