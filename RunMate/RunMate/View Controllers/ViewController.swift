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

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
        viewResultsOutlet.layer.cornerRadius = 15
        viewResultsOutlet.layer.masksToBounds = true
        showPastRoutesOutlet.layer.cornerRadius = 10
        showPastRoutesOutlet.layer.masksToBounds = true
        distanceTextField.layer.cornerRadius = 15
        distanceTextField.layer.masksToBounds = true
        tripSettingSegmentedControl.layer.cornerRadius = 10
        tripSettingSegmentedControl.layer.masksToBounds = true
        travelModeSegmentedControl.layer.cornerRadius = 10
        travelModeSegmentedControl.layer.masksToBounds = true
        tripSettingSegmentedControl.frame = CGRect(x: 30, y: 250, width: 300, height: 100)
        travelModeSegmentedControl.frame = CGRect(x: 30, y: 400, width: 300, height: 100)
        tripSettingSegmentedControl.removeBorders()
        travelModeSegmentedControl.removeBorders()
        
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
            let distance = Conversion.milestoMeters(miles: miles) //distance in meters
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
                PlacesService.findRoundTripNearbyPlaces(lat: 37.7808727, lng: -122.4183261, originalRadius: distance, travelMode: travelMode) { (routes) in
                    self.performSegue(withIdentifier: "viewResults", sender: routes)
                }
                //            PlacesService.findRoundTripNearbyPlaces(lat: (coordinate?.latitude)!, lng: (coordinate?.longitude)!, originalRadius: distance, travelMode: travelMode) { (routes) in
                //                self.performSegue(withIdentifier: "viewResults", sender: routes)
            //            }
            default:
                PlacesService.findOneWayNearbyPlaces(lat: 37.7808727, lng: -122.4183261, radius: distance, travelMode: travelMode) { (routes) in
                    self.performSegue(withIdentifier: "viewResults", sender: routes)
                }
                //            PlacesService.findOneWayNearbyPlaces(lat: (coordinate?.latitude)!, lng: (coordinate?.longitude)!, radius: distance, travelMode: travelMode) { (routes) in
                //                self.performSegue(withIdentifier: "viewResults", sender: routes)
                //            }
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

