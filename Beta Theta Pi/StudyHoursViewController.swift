//
//  StudyHoursViewController.swift
//  Beta Theta Pi
//
//  Created by James Weber on 12/23/17.
//  Copyright © 2017 James Weber. All rights reserved.
//

import UIKit
import SideMenu

class StudyHoursViewController: UIViewController {

    @IBOutlet weak var sideMenu: UIBarButtonItem!
    @IBOutlet weak var settings: UIBarButtonItem!
    @IBOutlet weak var setLocationButton: UIButton!
    @IBOutlet weak var selectClassButton: LeftAlignedIconButton!
    
    override func viewDidLoad() {
        
        setupNavBarButtons()
        
        //setLocationButton.leftImage(image: UIImage(named: "location")!)
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupNavBarButtons() {
        if self.revealViewController() != nil {
            sideMenu.target = self.revealViewController()
            sideMenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.revealViewController().rearViewRevealWidth = self.view.frame.width * 0.7
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            settings.target = self.revealViewController()
            settings.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            self.revealViewController().rightViewRevealWidth = self.view.frame.width * 0.7
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
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

@IBDesignable
class LeftAlignedIconButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        contentHorizontalAlignment = .left
        let availableSpace = UIEdgeInsetsInsetRect(bounds, contentEdgeInsets)
        var availableWidth = availableSpace.width - imageEdgeInsets.right - (imageView?.frame.width ?? 0) - (titleLabel?.frame.width ?? 0)
        availableWidth -= (imageView?.frame.width)!
        titleEdgeInsets = UIEdgeInsets(top: 0, left: availableWidth/2, bottom: 0, right: 0)
    }
}
