//
//  ViewController.swift
//  RunMate
//
//  Created by Sakura Rapolu on 7/31/18.
//  Copyright © 2018 MakeSchool. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    let locationManager = CLLocationManager()
    let numberToolbar: UIToolbar = UIToolbar()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        numberToolbar.barStyle = UIBarStyle.blackTranslucent
        numberToolbar.items=[
            UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(hoopla)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(boopla))
        ]
        
        numberToolbar.sizeToFit()
        
        distanceTextField.inputAccessoryView = numberToolbar //do it for every relevant textfield if there are more than one
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
        //constraining text field to only allow numerics
        distanceTextField.delegate = self
        distanceTextField.keyboardType = UIKeyboardType.numberPad
        
        //UI stuff
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Futura", size: 25)!]
        self.navigationController?.navigationBar.tintColor = UIColor(red: 230, green: 252, blue: 249, alpha: 0.8)
        viewResultsOutlet.layer.cornerRadius = 20
        viewResultsOutlet.layer.masksToBounds = true
        showPastRoutesOutlet.layer.cornerRadius = 10
        showPastRoutesOutlet.layer.masksToBounds = true
        distanceTextField.layer.cornerRadius = 20
        distanceTextField.layer.masksToBounds = true
//        tripSettingSegmentedControl.removeBorders()
//        travelModeSegmentedControl.removeBorders()
        
        self.tripSettingSegmentedControl.layer.cornerRadius = 25.0
        let colorLiteral = UIColor(red: 125, green: 192, blue: 175, alpha: 1)
        self.tripSettingSegmentedControl.layer.borderColor = colorLiteral.cgColor
        self.tripSettingSegmentedControl.layer.borderWidth = 1
        self.tripSettingSegmentedControl.layer.masksToBounds = true

        self.travelModeSegmentedControl.layer.cornerRadius = 25.0
        self.travelModeSegmentedControl.layer.borderColor = colorLiteral.cgColor
        self.travelModeSegmentedControl.layer.borderWidth = 1
        self.travelModeSegmentedControl.layer.masksToBounds = true
        
        dropShadow(scale: true, sender: distanceTextField)
        dropShadow(scale: true, sender: viewResultsOutlet)
        dropShadow(scale: true, sender: showPastRoutesOutlet)
        
        //changes font of segmented control
        let font = UIFont.systemFont(ofSize: 24)
        tripSettingSegmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: font],
                                                for: .normal)
        travelModeSegmentedControl.setTitleTextAttributes([NSAttributedStringKey.font: font],
                                                          for: .normal)
    }
    
    @IBOutlet weak var showPastRoutesOutlet: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.startUpdatingLocation()
    }
    
    
    @IBOutlet weak var viewResultsOutlet: UIButton!
    
    @IBAction func viewResultsButton(_ sender: Any) {
        if let miles = Double(distanceTextField.text!) {
            let distance = Conversion.milestoMeters(miles: miles)
            print(distance) //distance in meters
            let coordinate = locationManager.location?.coordinate
            locationManager.stopUpdatingLocation()
            let travelModeIndex = travelModeSegmentedControl.selectedSegmentIndex
            let travelMode: String
            switch travelModeIndex {
            case 1:
                travelMode = "bicycling"
            default:
                travelMode = "walking"
            }
            let tripSettingIndex = tripSettingSegmentedControl.selectedSegmentIndex
            switch tripSettingIndex {
            case 1:
                if let _ = (coordinate?.latitude) {
                    PlacesService.findRoundTripNearbyPlaces(lat: (coordinate?.latitude)!, lng: (coordinate?.longitude)!, originalRadius: distance, travelMode: travelMode) { (routes) in
                        self.performSegue(withIdentifier: "viewResults", sender: routes)
                    }
                } else {
                    PlacesService.findRoundTripNearbyPlaces(lat: 52.530095, lng: 13.3889753, originalRadius: distance, travelMode: travelMode) { (routes) in
                        self.performSegue(withIdentifier: "viewResults", sender: routes)
                    }
                }

            default:
                if let _ = (coordinate?.latitude) {
                    PlacesService.findOneWayNearbyPlaces(lat: (coordinate?.latitude)!, lng: (coordinate?.longitude)!, radius: distance, travelMode: travelMode) { (routes) in
                        self.performSegue(withIdentifier: "viewResults", sender: routes)
                    }
                } else {
//                    PlacesService.findOneWayNearbyPlaces(lat: 37.7808727, lng: -122.4183261, radius: distance, travelMode: travelMode) { (routes) in
//                        self.performSegue(withIdentifier: "viewResults", sender: routes)
//                    }
                    PlacesService.findOneWayNearbyPlaces(lat: 52.530095, lng: 13.3889753, radius: distance, travelMode: travelMode) { (routes) in
                        self.performSegue(withIdentifier: "viewResults", sender: routes)
                    }
                }
            }
        }
        else {
            print("button wass pressed but there was no distance value")
        }
        
    }
    
    @IBAction func viewPreviousRoutesButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showPastRoutes", sender: self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var tripSettingSegmentedControl: UISegmentedControl!
    @IBOutlet weak var travelModeSegmentedControl: UISegmentedControl!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        
        switch identifier {
        case "viewResults":
            let routes = sender as! [Route]
            let destination = segue.destination as! DisplayResultsViewController
            destination.routes = routes
        case "showPastRoutes":
            let destination = segue.destination as! PreviousRouteViewController
            //print(CoreDataHelper.retrieveRoutes().count)
            destination.routes = CoreDataHelper.retrieveRoutes()
        default:
            print("i dont recognize this")
        }
    }
    
    func dropShadow(scale: Bool = true, sender: UIView) {
        sender.layer.masksToBounds = false
        sender.layer.shadowColor = UIColor.black.cgColor
        sender.layer.shadowOpacity = 0.6
        sender.layer.shadowOffset = CGSize(width: -1, height: 1)
        sender.layer.shadowRadius = 1.5
        sender.layer.shouldRasterize = true
        sender.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    @objc func boopla() {
        distanceTextField.resignFirstResponder()
    }
    
    @objc func hoopla() {
        distanceTextField.resignFirstResponder()
    }
}

extension UISegmentedControl {
    func removeBorders() {
        setBackgroundImage(imageWithColor(color: backgroundColor!), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: tintColor!), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}

