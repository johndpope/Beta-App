//
//  StudyHoursViewController.swift
//  Beta Theta Pi
//
//  Created by James Weber on 12/23/17.
//  Copyright © 2017 James Weber. All rights reserved.
//

import UIKit
import SideMenu
import CoreLocation
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class StudyHoursViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var sideMenu: UIBarButtonItem!
    @IBOutlet weak var settings: UIBarButtonItem!
    @IBOutlet weak var setLocationButton: UIButton!
    @IBOutlet weak var selectClassButton: LeftAlignedIconButton!
    
    let locationManager = CLLocationManager()
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBarButtons()
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
    
    @IBAction func pickPlace(_ sender: Any) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            print("yeeeet")
            locationManager.startUpdatingLocation()
        }
        
        let locValue:CLLocationCoordinate2D = locationManager.location!.coordinate
        
        print(locValue)
        
        let center = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude) 
        let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
        let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePicker(config: config)
        
        //let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        //mapView.settings.scrollGestures = false
        
        placePicker.pickPlace(callback: {(place, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
                // self.nameLabel.text = place.name
                // self.addressLabel.text = place.formattedAddress?.components(separatedBy: ", ").joined(separator: "\n")
                print(locValue)
                print("----------------------")
                print(place.name)
                print(place.coordinate)
                print("----------------------")
                print(self.compareCoordinates(place.coordinate, locValue))
                
                if(!self.compareCoordinates(place.coordinate, locValue)){
                    let alert = UIAlertController(title: "Invalid Location!", message: "The location you chose is too far away from your current location.", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in  }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    
    @IBAction func selectClass(_ sender: Any) {
    
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Enter Your Class", message: "This should either be the subject or the course number (e.g. CS 159)", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
            textField.textAlignment = .center
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(String(describing: textField!.text))")
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    
    }
    func compareCoordinates(_ cllc2d1 : CLLocationCoordinate2D, _ cllc2d2 : CLLocationCoordinate2D) -> Bool {
        
        var epsilon = 0.00075
        
        print("fabs 1: \(fabs(cllc2d1.latitude - cllc2d2.latitude))")
        print("fabs 2: \(fabs(cllc2d1.longitude - cllc2d2.longitude))")
        
        return  fabs(cllc2d1.latitude - cllc2d2.latitude) <= epsilon && fabs(cllc2d1.longitude - cllc2d2.longitude) <= epsilon
    }
    
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
